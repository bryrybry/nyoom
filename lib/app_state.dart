import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Dark/Light Mode
final isDarkModeProvider = NotifierProvider<DarkModeNotifier, bool>(
  () => DarkModeNotifier(),
);

class DarkModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggleTheme() {
    state = !state;
  }
}

// Navigation Provider
final navigationProvider =
    NotifierProvider<NavigationNotifier, void Function(Widget)?>(
      () => NavigationNotifier(),
    );

class NavigationNotifier extends Notifier<void Function(Widget)?> {
  @override
  void Function(Widget)? build() => null;

  void setCallback(void Function(Widget) callback) {
    state = callback;
  }
}
