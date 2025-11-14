import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyoom/app_state.dart';

class AppColors {
  // UNIVERSAL
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color nyoomBlue = Color(0xFF197FAF);
  static const Color nyoomGreen = Color(0xFF69B765);
  static const Color nyoomLightYellow = Color(0xFFFAE5B2);
  static const Color nyoomLightBlue = Color(0xFFB8E1F5);
  static const Color nyoomLightGreen = Color(0xFFC9E5C8);
  static const Color nyoomDarkYellow = Color(0xFF4D3805);
  static const Color nyoomDarkBlue = Color(0xFF0A3347);
  static const Color nyoomDarkGreen = Color(0xFF1A371A);
  static const Color errorRed = Color(0xFFF44336);
  static const Color transparent = Color(0x00000000);

  // DYNAMIC (THEME-BASED)
  static Color primary(WidgetRef ref) {
    return ref.watch(isDarkModeProvider)
        ? white
        : black;
  }
  
  static Color onPrimary(WidgetRef ref) {
    return ref.watch(isDarkModeProvider)
        ? black
        : white;
  }

  static Color nyoomYellow(WidgetRef ref) {
    return ref.watch(isDarkModeProvider)
        ? const Color(0xFFF2B938)
        : const Color(0xFFCF9C29);
  }
  
  static Color nyoomYellowInverted(WidgetRef ref) {
    return ref.watch(isDarkModeProvider)
        ? const Color(0xFFCF9C29)
        : const Color(0xFFF2B938);
  }

  static Color hintGray(WidgetRef ref) {
    return ref.watch(isDarkModeProvider)
        ? const Color(0xFF9599A8)
        : const Color(0xFF575E6A);
  }

  static Color buttonPanel(WidgetRef ref) {
    return ref.watch(isDarkModeProvider)
        ? const Color(0xFF26282D)
        : const Color(0xFFD2D5D9);
  }

  static Color backgroundPanel(WidgetRef ref) {
    return ref.watch(isDarkModeProvider)
        ? const Color(0xFF1F2023)
        : const Color(0xFFDCDDE0);
  }

  static Color mainBackground(WidgetRef ref) {
    return ref.watch(isDarkModeProvider)
        ? const Color(0xFF1A1B1F)
        : const Color(0xFFE0E1E5);
  }

  static Color navBarPanel(WidgetRef ref) {
    return ref.watch(isDarkModeProvider)
        ? const Color(0xFF1F2025)
        : const Color(0xFFDADDE0);
  }

  static Color darkGray(WidgetRef ref) {
    return ref.watch(isDarkModeProvider)
        ? const Color(0xFF373942)
        : const Color(0xFFBDC1C8);
  }

  static Color buttonPanelPressed(WidgetRef ref) {
    return ref.watch(isDarkModeProvider)
        ? const Color(0xFF202125)
        : const Color(0xFFDADCDF);
  }
}
