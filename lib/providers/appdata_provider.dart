import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nyoom/classes/data_models/app_data.dart';
import 'package:nyoom/classes/data_models/bt_search_result.dart';
import 'package:nyoom/classes/helper.dart';
import 'package:nyoom/services/api_service.dart';

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
      email: _box.get('email', defaultValue: ""),
      btSearchResultsCache:
          (_box.get('btSearchResultsCache', defaultValue: []) as List)
              .cast<BTSearchResult>(),
      onemapAccessToken: _box.get('onemapAccessToken', defaultValue: ""),
      onemapAccessTokenExpiryTimestamp: _box.get(
        'onemapAccessTokenExpiryTimestamp',
        defaultValue: 0,
      ),
    );
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
    _box.put('email', email);
  }

  void addSearchResultCache(BTSearchResult btSearchResult) {
    List<BTSearchResult> btSearchResultsCache = List<BTSearchResult>.from(
      (_box.get('btSearchResultsCache', defaultValue: []) as List),
    );
    if (btSearchResultsCache.any((e) => e.header == btSearchResult.header)) {
      btSearchResultsCache.removeWhere(
        (e) => e.header == btSearchResult.header,
      );
    }
    btSearchResultsCache.add(btSearchResult);
    while (btSearchResultsCache.length > 10) {
      btSearchResultsCache.removeAt(0);
    }
    state = state.copyWith(btSearchResultsCache: btSearchResultsCache);
    _box.put('btSearchResultsCache', btSearchResultsCache);
  }

  Future<void> clearSearchResultCache() async {
    state = state.copyWith(btSearchResultsCache: []);
    await _box.put('btSearchResultsCache', []);
  }

  Future<String> getOnemapAccessToken() async {
    const int allowedMinBeforeExpiry = 10;
    String onemapAccessToken = _box.get('onemapAccessToken') ?? "";
    int onemapAccessTokenExpiryTimestamp =
        _box.get('onemapAccessTokenExpiryTimestamp') ?? 0;
    int timeNowEpoch = await Helper.timeNowEpoch();
    if (onemapAccessToken.isEmpty ||
        timeNowEpoch >
            onemapAccessTokenExpiryTimestamp - allowedMinBeforeExpiry * 60) {
      Map<String, dynamic> map = await ApiService.getNewOnemapAccessToken();
      if (map.isEmpty) {
        return "";
      }
      String newOnemapAccessToken = map["access_token"] ?? "";
      int newOnemapAccessTokenExpiryTimestamp = int.parse(
        map["expiry_timestamp"] ?? "0",
      );
      _box.putAll({
        'onemapAccessToken': newOnemapAccessToken,
        'onemapAccessTokenExpiryTimestamp': newOnemapAccessTokenExpiryTimestamp,
      });
      return newOnemapAccessToken;
    }
    return onemapAccessToken;
  }
}
