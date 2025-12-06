import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Niestandardowe cienie dla aplikacji
/// Używamy miękkich, kolorowych cieni dla bardziej przyjaznego wyglądu
class AppShadows {
  AppShadows._();

  // ============================================
  // NEUTRAL SHADOWS - Delikatne, standardowe
  // ============================================

  /// Bardzo subtelny cień dla kart
  static List<BoxShadow> get soft => [
    BoxShadow(
      color: AppColors.neutralShadow,
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  /// Średni cień dla elementów interaktywnych
  static List<BoxShadow> get medium => [
    BoxShadow(
      color: AppColors.neutralShadow,
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  /// Mocniejszy cień dla elementów "pływających"
  static List<BoxShadow> get elevated => [
    BoxShadow(
      color: AppColors.neutralShadow,
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: AppColors.neutralShadow.withOpacity(0.5),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  // ============================================
  // COLORED SHADOWS - Dla przycisków i akcentów
  // ============================================

  /// Pomarańczowy cień dla primary buttons
  static List<BoxShadow> get primary => [
    BoxShadow(
      color: AppColors.primaryShadow,
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  /// Turkusowy cień dla secondary elements
  static List<BoxShadow> get secondary => [
    BoxShadow(
      color: AppColors.secondaryShadow,
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  /// Żółty cień dla accent elements
  static List<BoxShadow> get accent => [
    BoxShadow(
      color: AppColors.accentShadow,
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  // ============================================
  // SPECIAL SHADOWS
  // ============================================

  /// Cień dla kart z obrazkami (mocniejszy na dole)
  static List<BoxShadow> get card => [
    BoxShadow(
      color: AppColors.neutralShadow,
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: AppColors.neutralShadow.withOpacity(0.3),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  /// Cień wewnętrzny (inset) dla pól tekstowych
  static List<BoxShadow> get inset => [
    BoxShadow(
      color: Colors.black.withOpacity(0.03),
      blurRadius: 4,
      offset: const Offset(0, 2),
      spreadRadius: -1,
    ),
  ];

  /// Efekt "glow" dla wybranych elementów
  static List<BoxShadow> primaryGlow(double intensity) => [
    BoxShadow(
      color: AppColors.primary.withOpacity(intensity),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> secondaryGlow(double intensity) => [
    BoxShadow(
      color: AppColors.secondary.withOpacity(intensity),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];
}

/// Dekoracje BoxDecoration gotowe do użycia
class AppDecorations {
  AppDecorations._();

  /// Standardowa karta
  static BoxDecoration get card => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(20),
    boxShadow: AppShadows.soft,
  );

  /// Karta z wyróżnieniem
  static BoxDecoration get cardElevated => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(24),
    boxShadow: AppShadows.elevated,
  );

  /// Kontener z gradientem primary
  static BoxDecoration get primaryGradient => BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: BorderRadius.circular(20),
    boxShadow: AppShadows.primary,
  );

  /// Kontener z gradientem secondary
  static BoxDecoration get secondaryGradient => BoxDecoration(
    gradient: AppColors.secondaryGradient,
    borderRadius: BorderRadius.circular(20),
    boxShadow: AppShadows.secondary,
  );

  /// Pole tekstowe
  static BoxDecoration get inputField => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: AppColors.textDisabled.withOpacity(0.3),
      width: 1.5,
    ),
  );

  /// Pole tekstowe aktywne
  static BoxDecoration get inputFieldFocused => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.primary, width: 2),
    boxShadow: AppShadows.primaryGlow(0.1),
  );
}
