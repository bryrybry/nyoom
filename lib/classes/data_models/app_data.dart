import 'package:nyoom/classes/data_models/bt_search_result.dart';

class AppData {
  final String email;
  final List<BTSearchResult> btSearchResultsCache;

  const AppData({
    required this.email,
    required this.btSearchResultsCache,
  });

  AppData copyWith({String? email, List<BTSearchResult>? btSearchResultsCache}) {
    return AppData(
      email: email ?? this.email,
      btSearchResultsCache: btSearchResultsCache ?? this.btSearchResultsCache
    );
  }
}
