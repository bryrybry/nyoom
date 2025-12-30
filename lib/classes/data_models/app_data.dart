import 'package:nyoom/classes/data_models/bt_search_result.dart';

class AppData {
  final String username;
  final String email;
  final bool? isGuestMode;
  final List<BTSearchResult> btSearchResultsCache;

  const AppData({
    required this.username,
    required this.email,
    required this.isGuestMode,
    required this.btSearchResultsCache,
  });

  AppData copyWith({String? username, String? email, bool? isGuestMode, List<BTSearchResult>? btSearchResultsCache}) {
    return AppData(
      username: username ?? this.username,
      email: email ?? this.email,
      isGuestMode: isGuestMode ?? this.isGuestMode,
      btSearchResultsCache: btSearchResultsCache ?? this.btSearchResultsCache
    );
  }
}
