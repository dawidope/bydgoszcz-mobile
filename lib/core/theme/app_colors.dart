import 'package:flutter/material.dart';

/// Paleta kolorów aplikacji "Magiczna Podróż po Bydgoszczy"
/// Kolory oparte na oficjalnym logo miasta Bydgoszcz: czerwony, żółty, niebieski
class AppColors {
  AppColors._();

  // ============================================
  // BYDGOSZCZ CITY COLORS - z oficjalnego logo
  // ============================================

  /// Czerwony Bydgoszcz - energia, pasja
  static const Color bydgoszczRed = Color(0xFFE63329);
  static const Color bydgoszczRedLight = Color(0xFFFF5A50);
  static const Color bydgoszczRedDark = Color(0xFFCC2920);

  /// Żółty Bydgoszcz - słońce, radość
  static const Color bydgoszczYellow = Color(0xFFFFD500);
  static const Color bydgoszczYellowLight = Color(0xFFFFE44D);
  static const Color bydgoszczYellowDark = Color(0xFFE6BF00);

  /// Niebieski Bydgoszcz - woda (Brda), spokój
  static const Color bydgoszczBlue = Color(0xFF009FE3);
  static const Color bydgoszczBlueLight = Color(0xFF4DC3FF);
  static const Color bydgoszczBlueDark = Color(0xFF0080B8);

  // ============================================
  // PRIMARY COLORS - Używamy czerwonego jako primary
  // ============================================

  static const Color primary = bydgoszczRed;
  static const Color primaryLight = bydgoszczRedLight;
  static const Color primaryDark = bydgoszczRedDark;

  // ============================================
  // SECONDARY COLORS - Niebieski jako secondary
  // ============================================

  static const Color secondary = bydgoszczBlue;
  static const Color secondaryLight = bydgoszczBlueLight;
  static const Color secondaryDark = bydgoszczBlueDark;

  // ============================================
  // ACCENT COLORS - Żółty jako accent
  // ============================================

  static const Color accent = bydgoszczYellow;
  static const Color accentLight = bydgoszczYellowLight;
  static const Color accentDark = bydgoszczYellowDark;

  /// Zielony sukcesu - osiągnięcia, postęp
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);

  // ============================================
  // BACKGROUND COLORS - Ciepłe i przyjazne
  // ============================================

  /// Kremowe tło - główne tło aplikacji
  static const Color background = Color(0xFFFFFBF5);

  /// Jasne tło dla kart
  static const Color surface = Color(0xFFFFFFFF);

  /// Delikatne żółtawe tło dla sekcji
  static const Color surfaceVariant = Color(0xFFFFF8E1);

  // ============================================
  // TEXT COLORS
  // ============================================

  /// Ciemny grafit - główny tekst
  static const Color textPrimary = Color(0xFF1A1A1A);

  /// Szary - tekst drugorzędny
  static const Color textSecondary = Color(0xFF666666);

  /// Jasny szary - tekst wyłączony
  static const Color textDisabled = Color(0xFFBDC3C7);

  /// Biały tekst na ciemnych tłach
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  /// Ciemny tekst na jasnych przyciskach
  static const Color textOnAccent = Color(0xFF2C3E50);

  // ============================================
  // UTILITY COLORS
  // ============================================

  static const Color error = Color(0xFFE74C3C);
  static const Color errorLight = Color(0xFFFDEDED);

  static const Color warning = Color(0xFFF39C12);
  static const Color warningLight = Color(0xFFFEF9E7);

  static const Color info = Color(0xFF3498DB);
  static const Color infoLight = Color(0xFFEBF5FB);

  // ============================================
  // GRADIENT DEFINITIONS - Bydgoszcz style
  // ============================================

  /// Gradient czerwony - primary
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bydgoszczRed, bydgoszczRedLight],
  );

  /// Gradient niebieski - secondary
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bydgoszczBlue, bydgoszczBlueLight],
  );

  /// Gradient żółty - accent
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bydgoszczYellow, bydgoszczYellowLight],
  );

  /// Gradient tła - ciepły kremowy
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFBF5), Color(0xFFFFF8E1)],
  );

  /// Gradient Bydgoszcz - wszystkie 3 kolory miasta!
  static const LinearGradient bydgoszczGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bydgoszczRed, bydgoszczYellow, bydgoszczBlue],
    stops: [0.0, 0.5, 1.0],
  );

  /// Gradient hero - czerwono-żółty
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bydgoszczRed, bydgoszczYellow],
  );

  // ============================================
  // SHADOW COLORS (kolorowe cienie)
  // ============================================

  static Color primaryShadow = primary.withOpacity(0.3);
  static Color secondaryShadow = secondary.withOpacity(0.3);
  static Color accentShadow = accent.withOpacity(0.3);
  static Color neutralShadow = const Color(0xFF2C3E50).withOpacity(0.08);
}
