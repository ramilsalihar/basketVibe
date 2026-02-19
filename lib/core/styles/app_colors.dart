import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── Primary (Mint Green) ──────────────────────────────────
  static const primary = Color(0xFF00D4AA); // Main CTA green
  static const primaryLight = Color(0xFF33DDB9);
  static const primaryDark = Color(0xFF00A886);
  static const primaryMuted = Color(0x2600D4AA); // 15% opacity — chip bg

  // ─── Accent Colors ────────────────────────────────────────
  static const accent = Color(0xFFFF6B35); // Orange highlight
  static const accentYellow = Color(0xFFFFC107); // Warning / coin
  static const accentPurple = Color(0xFF7B61FF); // NFT / special
  static const accentPink = Color(0xFFFF4D8C); // Trending / hot tag

  // ─── Light Mode ───────────────────────────────────────────
  static const lightBg = Color(0xFFF5F7FA); // Page scaffold
  static const lightSurface = Color(0xFFFFFFFF); // Cards, sheets
  static const lightSurface2 = Color(0xFFF0F2F5); // Input bg, nested card
  static const lightBorder = Color(0xFFE8EAED); // Dividers
  static const lightShadow = Color(0x0D000000); // 5% black

  static const lightTextPrimary = Color(0xFF0F1724);
  static const lightTextSecondary = Color(0xFF6B7A99);
  static const lightTextMuted = Color(0xFFADB5C7);

  // ─── Dark Mode ────────────────────────────────────────────
  static const darkBg = Color(0xFF0F1724); // Page scaffold
  static const darkSurface = Color(0xFF1A2336); // Cards
  static const darkSurface2 = Color(0xFF222D42); // Input bg, elevated
  static const darkSurface3 = Color(0xFF2C3A52); // Nested chips
  static const darkBorder = Color(0xFF2A3547); // Dividers
  static const darkGlass = Color(0x1AFFFFFF); // 10% white glassmorphism

  static const darkTextPrimary = Color(0xFFFFFFFF);
  static const darkTextSecondary = Color(0xFF8A9BBE);
  static const darkTextMuted = Color(0xFF4A5A78);

  // ─── Semantic ─────────────────────────────────────────────
  static const success = Color(0xFF00D4AA);
  static const error = Color(0xFFFF4444);
  static const warning = Color(0xFFFFC107);
  static const info = Color(0xFF4D9FFF);

  static const priceUp = Color(0xFF00D4AA); // +% green
  static const priceDown = Color(0xFFFF4444); // -% red

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
