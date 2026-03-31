import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keyLocalFile = rootProject.file("key.local")
val keyLocalProperties = Properties()
val hasSigningFile = keyLocalFile.exists()

if (hasSigningFile) {
    keyLocalFile.inputStream().use { keyLocalProperties.load(it) }
}

val requiredSigningKeys = listOf(
    "keyAlias",
    "keyPassword",
    "storeFile",
    "storePassword",
)
val hasSigningConfig = requiredSigningKeys.all {
    !keyLocalProperties.getProperty(it).isNullOrBlank()
}

android {
    namespace = "com.basketvibe.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.basketvibe.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (hasSigningConfig) {
                keyAlias = keyLocalProperties["keyAlias"] as String
                keyPassword = keyLocalProperties["keyPassword"] as String
                storePassword = keyLocalProperties["storePassword"] as String
                storeFile = file(keyLocalProperties["storeFile"] as String)
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
