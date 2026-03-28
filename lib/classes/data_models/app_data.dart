import 'package:nyoom/classes/data_models/bt_search_result.dart';

class AppData {
  final String email;
  final List<BTSearchResult> btSearchResultsCache;
  final String onemapAccessToken;
  final int onemapAccessTokenExpiryTimestamp;

  const AppData({
    required this.email,
    required this.btSearchResultsCache,
    required this.onemapAccessToken,
    required this.onemapAccessTokenExpiryTimestamp,
  });

  AppData copyWith({
    String? email,
    List<BTSearchResult>? btSearchResultsCache,
    String? onemapAccessToken,
    int? onemapAccessTokenExpiryTimestamp,
  }) {
    return AppData(
      email: email ?? this.email,
      btSearchResultsCache: btSearchResultsCache ?? this.btSearchResultsCache,
      onemapAccessToken: onemapAccessToken ?? this.onemapAccessToken,
      onemapAccessTokenExpiryTimestamp:
          onemapAccessTokenExpiryTimestamp ??
          this.onemapAccessTokenExpiryTimestamp,
    );
  }
}
