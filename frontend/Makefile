# ─── Directories ────────────────────────────────────────────────────────────────

BUILD_OUTPUT_DIR  ?= build/outputs
APK_OUTPUT_DIR    := $(BUILD_OUTPUT_DIR)/apk
AAB_OUTPUT_DIR    := $(BUILD_OUTPUT_DIR)/aab

# ─── Version Info ───────────────────────────────────────────────────────────────

VERSION_LINE      := $(shell grep '^version:' pubspec.yaml)
BUILD_NAME        := $(shell echo $(VERSION_LINE) | cut -d' ' -f2 | cut -d+ -f1)
BUILD_NUMBER      := $(shell echo $(VERSION_LINE) | cut -d' ' -f2 | cut -d+ -f2)

# Mac/Linux-compatible sed
SED_CMD ?= sed -i
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
	SED_CMD := sed -i ''
endif

# Firebase Configuration
FIREBASE_PROJECT ?= kidzgo-292ba
FIREBASE_APP_ID  ?= 1:186292467757:android:b2013b9cdd71826ce860a4 
TESTERS_FILE     ?= testers.txt
RELEASE_NOTES    ?= "Bug fixes and improvements"

# ─── Phony Targets ──────────────────────────────────────────────────────────────

.PHONY: all clean clean_cache deep_clean gen l10n \
        increment_build increment_patch increment_minor increment_major \
        prebuild build build_apk build_aab \
        firebase_config pods_install run \
        distribute release_apk release_aab

# ─── Default ────────────────────────────────────────────────────────────────────

all: build

# ─── Cleaning ───────────────────────────────────────────────────────────────────

clean:
	@echo "flutter clean…"
	flutter clean

deep_clean: clean
	@echo "Removing artifacts and caches…"
	rm -rf .dart_tool .packages .pub build pubspec.lock
	flutter clean
	rm -rf ios/Pods
	rm -rf ios/Podfile.lock

clean_cache:
	@echo "Cleaning pub cache…"
	flutter pub cache repair

# ─── Codegen & Localization ─────────────────────────────────────────────────────

gen:
	@echo "Generating code (build_runner)…"
	flutter pub run build_runner build --delete-conflicting-outputs

l10n:
	@echo "Generating localization files…"
	flutter gen-l10n

# ─── Firebase & CocoaPods ───────────────────────────────────────────────────────

firebase_config:
	@echo "Configuring Firebase for project '$(FIREBASE_PROJECT)'…"
	flutterfire configure --project $(FIREBASE_PROJECT)

pods_install:
	@echo "Installing iOS pods…"
	cd ios && pod install

# ─── Version Increments ─────────────────────────────────────────────────────────

increment_build:
	@echo "Incrementing BUILD number…"
	@ver="$(BUILD_NAME)"; \
	 build="$(BUILD_NUMBER)"; \
	 new_build=`expr $$build + 1`; \
	 $(SED_CMD) 's/^version:.*/version: '"$$ver+$$new_build"'/' pubspec.yaml; \
	 echo "→ version updated to $$ver+$$new_build"

increment_patch:
	@echo "Incrementing PATCH version…"
	@ver="$(BUILD_NAME)"; \
	 IFS='.' read -r major minor patch <<< "$$ver"; \
	 new_patch=`expr $$patch + 1`; \
	 new_ver="$$major.$$minor.$$new_patch"; \
	 $(SED_CMD) 's/^version:.*/version: '"$$new_ver+0"'/' pubspec.yaml; \
	 echo "→ version updated to $$new_ver+0"

increment_minor:
	@echo "Incrementing MINOR version…"
	@ver="$(BUILD_NAME)"; \
	 IFS='.' read -r major minor patch <<< "$$ver"; \
	 new_minor=`expr $$minor + 1`; \
	 new_ver="$$major.$$new_minor.0"; \
	 $(SED_CMD) 's/^version:.*/version: '"$$new_ver+0"'/' pubspec.yaml; \
	 echo "→ version updated to $$new_ver+0"

increment_major:
	@echo "Incrementing MAJOR version…"
	@ver="$(BUILD_NAME)"; \
	 IFS='.' read -r major minor patch <<< "$$ver"; \
	 new_major=`expr $$major + 1`; \
	 new_ver="$$new_major.0.0"; \
	 $(SED_CMD) 's/^version:.*/version: '"$$new_ver+0"'/' pubspec.yaml; \
	 echo "→ version updated to $$new_ver+0"

install:
	@echo "Running prebuild setup (no version change)…"
	flutter pub get
	@$(MAKE) pods_install

# ─── Build Targets ──────────────────────────────────────────────────────────────

shore_release: 
	@shorebird release --platforms='ios,android'

build: build_apk build_aab

build_apk:
	@$(MAKE) increment_build
	@echo "Building Android APK…"
	@mkdir -p $(APK_OUTPUT_DIR)
	flutter build apk --release --build-name=$(BUILD_NAME) --build-number=$(BUILD_NUMBER)
	@APK_FILE="$(APK_OUTPUT_DIR)/app-$(BUILD_NAME)+$(BUILD_NUMBER).apk"; \
	cp build/app/outputs/flutter-apk/app-release.apk $$APK_FILE; \
	echo "→ APK saved to $$APK_FILE"

build_aab:
	@$(MAKE) increment_build
	@echo "Building Android App Bundle…"
	@mkdir -p $(AAB_OUTPUT_DIR)
	flutter build appbundle --release --build-name=$(BUILD_NAME) --build-number=$(BUILD_NUMBER)
	cp build/app/outputs/bundle/release/app-release.aab \
		$(AAB_OUTPUT_DIR)/app-$(BUILD_NAME)+$(BUILD_NUMBER).aab
	@echo "→ AAB saved to $(AAB_OUTPUT_DIR)"

# ─── Distribution Targets ──────────────────────────────────────────────────────

distribute:
	@echo "Available APKs in $(APK_OUTPUT_DIR):"
	@ls -la $(APK_OUTPUT_DIR)/*.apk 2>/dev/null || echo "No APK files found"
	@echo ""
	@APK_FILE=$$(ls -t $(APK_OUTPUT_DIR)/*.apk 2>/dev/null | head -n1); \
	if [ -z "$$APK_FILE" ]; then \
		echo "Error: No APK files found in $(APK_OUTPUT_DIR)"; \
		echo "Please build the APK first with 'make build_apk'"; \
		exit 1; \
	fi; \
	echo "Using most recent APK: $$APK_FILE"; \
	$(MAKE) distribute_apk APK_FILE="$$APK_FILE"

distribute_apk:
	@if [ ! -f "$(APK_FILE)" ]; then \
		echo "Error: APK file '$(APK_FILE)' not found"; \
		echo "Please build the APK first with 'make build_apk'"; \
		exit 1; \
	fi
	@if [ ! -f "$(TESTERS_FILE)" ]; then \
		echo "Error: Testers file '$(TESTERS_FILE)' not found"; \
		exit 1; \
	fi
	@echo "Distributing $(APK_FILE) to testers..."
	@firebase appdistribution:distribute "$(APK_FILE)" \
		--app "$(FIREBASE_APP_ID)" \
# 		--release-notes "$(RELEASE_NOTES)" \
# 		--testers-file "$(TESTERS_FILE)" || \
		(echo "Firebase distribution failed"; exit 1)
	@echo "Distribution complete!"

# Combined build and distribute targets
release_apk: build_apk
	@APK_FILE="$(APK_OUTPUT_DIR)/app-$(BUILD_NAME)+$(BUILD_NUMBER).apk"; \
	if [ ! -f "$$APK_FILE" ]; then \
		echo "Error: APK file $$APK_FILE not found after build"; \
		exit 1; \
	fi; \
	$(MAKE) distribute_apk APK_FILE="$$APK_FILE"
	@echo "APK built and distributed successfully!"

release_aab: build_aab
	@echo "AAB built successfully! (Note: Firebase App Distribution only supports APKs)"

# ─── Run ────────────────────────────────────────────────────────────────────────

run:
	@echo "Running on connected device/emulator…"
	flutter run

help:
	@echo "Available targets:"
	@echo "  build            - Build both APK and AAB"
	@echo "  build_apk        - Build release APK"
	@echo "  build_aab        - Build release AAB"
	@echo "  release_apk      - Build and distribute APK to testers"
	@echo "  distribute_apk   - Distribute specific APK (set APK_FILE=path/to/apk)"
	@echo "  increment_*      - Version number management (major/minor/patch/build)"
	@echo "  firebase_config  - Configure Firebase"
	@echo "  clean            - Clean build artifacts"
	@echo "  run              - Run on connected device"