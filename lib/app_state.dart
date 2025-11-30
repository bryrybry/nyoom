import 'package:hive_flutter/adapters.dart';
import 'package:nyoom/classes/data_models/bookmark.dart';

export 'package:nyoom/providers/settings_provider.dart';
export 'package:nyoom/providers/bookmarks_provider.dart';
export 'package:nyoom/providers/navigation_provider.dart';

// Hive init
Future<void> initHive() async {
  await Hive.initFlutter(); 
  await Hive.openBox('settings');
  Hive.registerAdapter(BookmarkAdapter());
  await Hive.openBox<List>('bookmarks');
}
