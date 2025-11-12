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
