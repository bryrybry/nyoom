import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nyoom/classes/data_models/bookmark.dart';

final bookmarksProvider = NotifierProvider<BookmarksNotifier, List<Bookmark>>(
  () => BookmarksNotifier(),
);

class BookmarksNotifier extends Notifier<List<Bookmark>> {
  late final Box<List> _box;

  @override
  List<Bookmark> build() {
    _box = Hive.box<List>('bookmarks');
    final saved = _box.get('bookmarks');
    if (saved != null) {
      return List<Bookmark>.from(saved);
    }
    return [];
  }

  bool _equals(Bookmark a, Bookmark b) =>
      a.busStopCode == b.busStopCode && a.busService == b.busService;

  void addBookmark(Bookmark bookmark) {
    if (!state.any((b) => _equals(b, bookmark))) {
      state = [...state, bookmark];
      _box.put('bookmarks', state);
    }
  }

  void removeBookmark(Bookmark bookmark) {
    state = state.where((b) => !_equals(b, bookmark)).toList();
    _box.put('bookmarks', state);
  }

  void toggleBookmark(Bookmark bookmark) {
    if (state.any((b) => _equals(b, bookmark))) {
      removeBookmark(bookmark);
    } else {
      addBookmark(bookmark);
    }
  }

  bool bookmarkExists(Bookmark bookmark) {
    return state.any((b) => _equals(b, bookmark));
  }

  List<Bookmark> getBookmarks() {
    final saved = _box.get('bookmarks');
    if (saved != null) {
      return List<Bookmark>.from(saved);
    }
    return [];
  }
}