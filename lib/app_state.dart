import 'package:hive_flutter/adapters.dart';
import 'package:nyoom/classes/data_models/bookmark.dart';
import 'package:nyoom/classes/data_models/bt_search_result.dart';

export 'package:nyoom/providers/appdata_provider.dart';
export 'package:nyoom/providers/bookmarks_provider.dart';
export 'package:nyoom/providers/navigation_provider.dart';
export 'package:nyoom/providers/settings_provider.dart';

// Hive init
Future<void> initHive() async {
  await Hive.initFlutter(); 
  Hive.registerAdapter(BTSearchResultAdapter());
  await Hive.openBox('appdata');
  Hive.registerAdapter(BookmarkAdapter());
  await Hive.openBox<List>('bookmarks');
  await Hive.openBox('settings');
}
