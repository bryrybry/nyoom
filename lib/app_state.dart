import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nyoom/classes/data_models/bookmark.dart';

// Hive init
Future<void> initHive() async {
  await Hive.initFlutter(); 
  await Hive.openBox('settings');
  Hive.registerAdapter(BookmarkAdapter());
  await Hive.openBox<Map>('bookmarks');
}

// Dark/Light Mode
final isDarkModeProvider = NotifierProvider<DarkModeNotifier, bool>(
  () => DarkModeNotifier(),
);

class DarkModeNotifier extends Notifier<bool> {
  @override
  bool build() {
    final box = Hive.box('settings');
    return box.get('isDarkMode', defaultValue: false);
  }

  void toggleTheme() {
    final box = Hive.box('settings');
    final newValue = !state;
    state = newValue;
    box.put('isDarkMode', newValue);
  }
}

final bookmarksProvider = NotifierProvider<BookmarksNotifier, Map<String, Bookmark>>(
  () => BookmarksNotifier(),
);

class BookmarksNotifier extends Notifier<Map<String, Bookmark>> {
  late final Box<Map> _box;

  @override
  Map<String, Bookmark> build() {
    _box = Hive.box<Map>('bookmarks');
    final saved = _box.get('bookmarks');
    if (saved != null) {
      return Map<String, Bookmark>.from(saved);
    }
    return {};
  }

  String _key(Bookmark bookmark) => '${bookmark.busStopCode}_${bookmark.busService}';

  void addBookmark(Bookmark bookmark) {
    final key = _key(bookmark);
    state = {
      ...state,
      key: bookmark,
    };
    _box.put('bookmarks', state);
  }

  void removeBookmark(Bookmark bookmark) {
    final key = _key(bookmark);
    final newState = Map<String, Bookmark>.from(state)..remove(key);
    state = newState;
    _box.put('bookmarks', state);
  }

  void toggleBookmark(Bookmark bookmark) {
    final key = _key(bookmark);
    if (state.containsKey(key)) {
      removeBookmark(bookmark);
    } else {
      addBookmark(bookmark);
    }
  }

  bool bookmarkExists(Bookmark bookmark) {
    final key = _key(bookmark);
    return state.containsKey(key);
  }

  Map<String, Bookmark> getBookmarks() {
    final saved = _box.get('bookmarks');
    if (saved != null) {
      return Map<String, Bookmark>.from(saved);
    }
    return {};
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
