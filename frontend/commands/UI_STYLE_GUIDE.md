# 🎨 UI/UX Style Guide
> Updated from design reference — light & dark mode crypto/community app

---

## Design Language
**Clean, modern fintech meets social community.**  
Mint-green primary accents, rounded cards, soft gradients, glassmorphism touches in dark mode. The app feels premium but approachable — bold numbers, clear hierarchy, playful avatar stacks.

---

## Color Palette

```dart
// core/styles/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── Primary (Mint Green) ──────────────────────────────────
  static const primary         = Color(0xFF00D4AA);   // Main CTA green
  static const primaryLight    = Color(0xFF33DDB9);
  static const primaryDark     = Color(0xFF00A886);
  static const primaryMuted    = Color(0x2600D4AA);   // 15% opacity — chip bg

  // ─── Accent Colors ────────────────────────────────────────
  static const accent          = Color(0xFFFF6B35);   // Orange highlight
  static const accentYellow    = Color(0xFFFFC107);   // Warning / coin
  static const accentPurple    = Color(0xFF7B61FF);   // NFT / special
  static const accentPink      = Color(0xFFFF4D8C);   // Trending / hot tag

  // ─── Light Mode ───────────────────────────────────────────
  static const lightBg         = Color(0xFFF5F7FA);   // Page scaffold
  static const lightSurface    = Color(0xFFFFFFFF);   // Cards, sheets
  static const lightSurface2   = Color(0xFFF0F2F5);   // Input bg, nested card
  static const lightBorder     = Color(0xFFE8EAED);   // Dividers
  static const lightShadow     = Color(0x0D000000);   // 5% black

  static const lightTextPrimary   = Color(0xFF0F1724);
  static const lightTextSecondary = Color(0xFF6B7A99);
  static const lightTextMuted     = Color(0xFFADB5C7);

  // ─── Dark Mode ────────────────────────────────────────────
  static const darkBg          = Color(0xFF0F1724);   // Page scaffold
  static const darkSurface     = Color(0xFF1A2336);   // Cards
  static const darkSurface2    = Color(0xFF222D42);   // Input bg, elevated
  static const darkSurface3    = Color(0xFF2C3A52);   // Nested chips
  static const darkBorder      = Color(0xFF2A3547);   // Dividers
  static const darkGlass       = Color(0x1AFFFFFF);   // 10% white glassmorphism

  static const darkTextPrimary   = Color(0xFFFFFFFF);
  static const darkTextSecondary = Color(0xFF8A9BBE);
  static const darkTextMuted     = Color(0xFF4A5A78);

  // ─── Semantic ─────────────────────────────────────────────
  static const success   = Color(0xFF00D4AA);
  static const error     = Color(0xFFFF4444);
  static const warning   = Color(0xFFFFC107);
  static const info      = Color(0xFF4D9FFF);

  static const priceUp   = Color(0xFF00D4AA);   // +% green
  static const priceDown = Color(0xFFFF4444);   // -% red

  // ─── Gradients ────────────────────────────────────────────
  static const walletCardGradient = LinearGradient(
    colors: [Color(0xFF00D4AA), Color(0xFF0094FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const nftCardGradient = LinearGradient(
    colors: [Color(0xFF7B61FF), Color(0xFFFF4D8C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const primaryButtonGradient = LinearGradient(
    colors: [Color(0xFF00D4AA), Color(0xFF00A886)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const exploreBgGradient = LinearGradient(
    colors: [Color(0xFFE8FFF9), Color(0xFFF5F7FA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
```

---

## Typography

```dart
// core/styles/app_text_styles.dart
// Font: 'Inter' — add via google_fonts or assets

class AppTextStyles {
  AppTextStyles._();

  // Display (wallet balance, hero numbers)
  static const displayXL = TextStyle(
    fontFamily: 'Inter', fontSize: 36,
    fontWeight: FontWeight.w800, letterSpacing: -1.0,
  );
  static const displayLG = TextStyle(
    fontFamily: 'Inter', fontSize: 28,
    fontWeight: FontWeight.w800, letterSpacing: -0.5,
  );

  // Headings
  static const h1 = TextStyle(
    fontFamily: 'Inter', fontSize: 22,
    fontWeight: FontWeight.w700, letterSpacing: -0.3,
  );
  static const h2 = TextStyle(
    fontFamily: 'Inter', fontSize: 18,
    fontWeight: FontWeight.w700, letterSpacing: -0.2,
  );
  static const h3 = TextStyle(
    fontFamily: 'Inter', fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  // Body
  static const bodyLG = TextStyle(
    fontFamily: 'Inter', fontSize: 15,
    fontWeight: FontWeight.w400, height: 1.5,
  );
  static const bodyMD = TextStyle(
    fontFamily: 'Inter', fontSize: 14,
    fontWeight: FontWeight.w400, height: 1.5,
  );
  static const bodySM = TextStyle(
    fontFamily: 'Inter', fontSize: 12,
    fontWeight: FontWeight.w400, height: 1.4,
  );

  // Labels / Captions
  static const labelLG = TextStyle(
    fontFamily: 'Inter', fontSize: 14,
    fontWeight: FontWeight.w600, letterSpacing: 0.1,
  );
  static const labelMD = TextStyle(
    fontFamily: 'Inter', fontSize: 12,
    fontWeight: FontWeight.w600, letterSpacing: 0.2,
  );
  static const labelSM = TextStyle(
    fontFamily: 'Inter', fontSize: 11,
    fontWeight: FontWeight.w500, letterSpacing: 0.3,
  );

  // Buttons
  static const buttonLG = TextStyle(
    fontFamily: 'Inter', fontSize: 15,
    fontWeight: FontWeight.w700, letterSpacing: 0.1,
  );
  static const buttonMD = TextStyle(
    fontFamily: 'Inter', fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  // Mono (prices, wallet addresses)
  static const monoLG = TextStyle(
    fontFamily: 'JetBrainsMono', fontSize: 15,
    fontWeight: FontWeight.w600, letterSpacing: 0.3,
  );
}
```

---

## Spacing System

```dart
// core/styles/app_spacing.dart
class AppSpacing {
  AppSpacing._();

  static const double xs   = 4.0;
  static const double sm   = 8.0;
  static const double md   = 12.0;
  static const double lg   = 16.0;
  static const double xl   = 20.0;
  static const double xxl  = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 48.0;

  static const EdgeInsets pagePadding    = EdgeInsets.symmetric(horizontal: 20.0);
  static const EdgeInsets cardPadding    = EdgeInsets.all(16.0);
  static const EdgeInsets cardPaddingLG  = EdgeInsets.all(20.0);

  static const SizedBox gapXS  = SizedBox(height: 4);
  static const SizedBox gapSM  = SizedBox(height: 8);
  static const SizedBox gapMD  = SizedBox(height: 12);
  static const SizedBox gapLG  = SizedBox(height: 16);
  static const SizedBox gapXL  = SizedBox(height: 24);
  static const SizedBox gapXXL = SizedBox(height: 32);

  static const SizedBox rowGapSM = SizedBox(width: 8);
  static const SizedBox rowGapMD = SizedBox(width: 12);
  static const SizedBox rowGapLG = SizedBox(width: 16);
}
```

---

## Border Radius

```dart
// core/styles/app_border_radius.dart
class AppRadius {
  AppRadius._();

  static const double xs   = 8.0;
  static const double sm   = 12.0;
  static const double md   = 16.0;    // Standard card
  static const double lg   = 20.0;    // Large card
  static const double xl   = 24.0;    // Bottom sheet
  static const double xxl  = 32.0;    // Hero card
  static const double pill = 100.0;   // Chips, tags, pill buttons

  static const brXS   = BorderRadius.all(Radius.circular(xs));
  static const brSM   = BorderRadius.all(Radius.circular(sm));
  static const brMD   = BorderRadius.all(Radius.circular(md));
  static const brLG   = BorderRadius.all(Radius.circular(lg));
  static const brXL   = BorderRadius.all(Radius.circular(xl));
  static const brXXL  = BorderRadius.all(Radius.circular(xxl));
  static const brPill = BorderRadius.all(Radius.circular(pill));
}
```

---

## App Theme (Light + Dark)

```dart
// core/styles/app_theme.dart
class AppTheme {
  AppTheme._();

  static ThemeData get light => _buildTheme(Brightness.light);
  static ThemeData get dark  => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark   = brightness == Brightness.dark;
    final bg       = isDark ? AppColors.darkBg       : AppColors.lightBg;
    final surface  = isDark ? AppColors.darkSurface  : AppColors.lightSurface;
    final surface2 = isDark ? AppColors.darkSurface2 : AppColors.lightSurface2;
    final border   = isDark ? AppColors.darkBorder   : AppColors.lightBorder;
    final textPri  = isDark ? AppColors.darkTextPrimary   : AppColors.lightTextPrimary;
    final textSec  = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      primaryColor: AppColors.primary,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.accentPurple,
        onSecondary: Colors.white,
        error: AppColors.error,
        onError: Colors.white,
        surface: surface,
        onSurface: textPri,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h2.copyWith(color: textPri),
        iconTheme: IconThemeData(color: textPri),
      ),

      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brMD),
        margin: EdgeInsets.zero,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: AppTextStyles.buttonLG,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.brPill),
          minimumSize: const Size(double.infinity, 52),
          elevation: 0,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.buttonMD,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.brPill),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.labelLG,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface2,
        border: OutlineInputBorder(
          borderRadius: AppRadius.brMD,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.brMD,
          borderSide: BorderSide(color: border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.brMD,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        hintStyle: AppTextStyles.bodyMD.copyWith(color: textSec),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: surface2,
        selectedColor: AppColors.primaryMuted,
        labelStyle: AppTextStyles.labelMD.copyWith(color: textPri),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brPill),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      dividerTheme: DividerThemeData(
        color: border,
        thickness: 1,
        space: 0,
      ),

      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brMD),
      ),
    );
  }
}
```

---

## Key UI Patterns

### Floating Pill Bottom Nav
The bottom nav is a **floating rounded container**, not full-width:
```dart
Container(
  margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
  decoration: BoxDecoration(
    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
    borderRadius: AppRadius.brXXL,
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 24, offset: const Offset(0, 8)),
    ],
  ),
  child: BottomNavigationBar(...),
)
```

### Wallet / Balance Card
Gradient card, white text, action buttons row:
- Background: `AppColors.walletCardGradient`
- Border radius: `AppRadius.brXXL` (32)
- Decorative blurred circle shapes in background (Positioned + blur)
- Actions: Buy / Send / Swap / More — column icon + label, 4-up grid

### FAB
Gradient circle 56px, green glow in dark mode:
```dart
BoxDecoration(
  gradient: AppColors.primaryButtonGradient,
  shape: BoxShape.circle,
  boxShadow: [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.4),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ],
)
```

### Category / Tab Chips (Trending, Top, Events)
Horizontally scrollable pill chips:
- Selected: `AppColors.primary` bg + white text
- Unselected: `surface2` bg + `textSecondary` text
- Height: 36px, pill border radius

### Coin / Player Row
```
[Avatar 40px] [Name bold + subtitle muted]   [sparkline 60px]   [price bold / badge]
```
% badge: green pill for +, red pill for -, small labelSM text

### Avatar Stack (Groups)
Overlapping circles offset by -10px each, followed by `+N` bubble:
```dart
// Stack of CircleAvatar widgets with negative left margin
// Final child: Container with primary color, "+N" white text
```

### Price % Badge
```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
  decoration: BoxDecoration(
    color: isPositive
        ? AppColors.priceUp.withOpacity(0.15)
        : AppColors.priceDown.withOpacity(0.15),
    borderRadius: AppRadius.brPill,
  ),
  child: Text(
    '+2.4%',
    style: AppTextStyles.labelSM.copyWith(
      color: isPositive ? AppColors.priceUp : AppColors.priceDown,
    ),
  ),
)
```

---

## Light vs Dark Mode Reference

| Element             | Light           | Dark            |
|---------------------|-----------------|-----------------|
| Scaffold bg         | `#F5F7FA`       | `#0F1724`       |
| Card bg             | `#FFFFFF`       | `#1A2336`       |
| Input / nested bg   | `#F0F2F5`       | `#222D42`       |
| Divider / border    | `#E8EAED`       | `#2A3547`       |
| Text primary        | `#0F1724`       | `#FFFFFF`       |
| Text secondary      | `#6B7A99`       | `#8A9BBE`       |
| Card shadow         | 5% black        | none (border)   |
| Primary CTA         | green `#00D4AA` | same            |
| Charts line         | green + white fill | green + dark fill |
| Glass overlay       | —               | 10% white       |
