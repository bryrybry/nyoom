import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nyoom/classes/data_models/app_data.dart';
import 'package:nyoom/classes/data_models/bt_search_result.dart';

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
      btSearchResultsCache:
          (_box.get('btSearchResultsCache', defaultValue: []) as List)
              .cast<BTSearchResult>(),
    );
  }

  @override
  set state(AppData newState) {
    final oldCache = super.state.btSearchResultsCache
        .map((e) => e.header)
        .toList();
    super.state = newState;
    final newCache = newState.btSearchResultsCache
        .map((e) => e.header)
        .toList();

    if (oldCache.join(',') != newCache.join(',')) {
      print("💥 Cache changed! Old: $oldCache → New: $newCache");
    }
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

  void addSearchResultCache(BTSearchResult btSearchResult) {
    // Read existing cache from Hive
    List<BTSearchResult> btSearchResultsCache = List<BTSearchResult>.from(
      (_box.get('btSearchResultsCache', defaultValue: []) as List),
    );

    print("=== Adding Search Result ===");
    print(
      "Current cache (${btSearchResultsCache.length} items): ${btSearchResultsCache.map((e) => e.header).toList()}",
    );
    print("Trying to add: ${btSearchResult.header}");

    // Check for duplicates
    if (!btSearchResultsCache.any((e) => e.header == btSearchResult.header)) {
      btSearchResultsCache.add(btSearchResult);
      print("Added: ${btSearchResult.header}");
    } else {
      print("Skipped adding duplicate: ${btSearchResult.header}");
    }

    // Keep only the last 10 items
    while (btSearchResultsCache.length > 10) {
      final removed = btSearchResultsCache.removeAt(0);
      print("Removed oldest: ${removed.header}");
    }

    // Update state and Hive
    state = state.copyWith(btSearchResultsCache: btSearchResultsCache);
    _box.put('btSearchResultsCache', btSearchResultsCache);

    print(
      "Updated cache (${btSearchResultsCache.length} items): ${btSearchResultsCache.map((e) => e.header).toList()}",
    );
    print("=== End Add ===\n");
  }

  void clearSearchResultCache() {
    state = state.copyWith(btSearchResultsCache: []); // update Riverpod state
    _box.put('btSearchResultsCache', []); // update Hive
  }
}
