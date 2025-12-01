import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nyoom/classes/data_models/app_data.dart';

// The provider
final appDataProvider = NotifierProvider<AppDataNotifier, AppData>(
  () => AppDataNotifier(),
);

class AppDataNotifier extends Notifier<AppData> {
  late final Box _box;

  @override
  AppData build() {
    _box = Hive.box('appdata');
    return AppData(
      username: _box.get('username', defaultValue: ""),
      email: _box.get('email', defaultValue: ""),
      isGuestMode: _box.get('isGuestMode', defaultValue: null),
    );
  }

  void setGuestMode(bool? value) {
    state = state.copyWith(isGuestMode: value);
    _box.put('isGuestMode', value);
  }

  void setUsernameEmail(String username, String email) {
    state = state.copyWith(username: username, email: email);
    _box.put('username', username);
    _box.put('email', email);
  }
}
