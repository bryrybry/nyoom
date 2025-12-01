import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nyoom/classes/data_models/app_settings.dart';

// The provider
final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(
  () => SettingsNotifier(),
);

class SettingsNotifier extends Notifier<AppSettings> {
  late final Box _box;

  @override
  AppSettings build() {
    _box = Hive.box('settings');
    return AppSettings(
      isDarkMode: _box.get('isDarkMode', defaultValue: false),
    );
  }

  void toggleDarkMode() {
    final newValue = !state.isDarkMode;
    state = state.copyWith(isDarkMode: newValue);
    _box.put('isDarkMode', newValue);
  }
}
