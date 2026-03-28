// public String SEARCHVAL;
// public String BLK_NO;
// public String LATITUDE;
// public String LONGITUDE;
// public String ADDRESS;

class OnemapSearchResult {
  final String searchVal;
  final String blkNo;
  final String latitude;
  final String longitude;
  final String address;

  OnemapSearchResult({
    required this.searchVal,
    required this.blkNo,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  static OnemapSearchResult fromJson(Map<String, dynamic> json) {
    return OnemapSearchResult(
      searchVal: json["SEARCHVAL"],
      blkNo: json["BLK_NO"],
      latitude: json["LATITUDE"],
      longitude: json["LONGITUDE"],
      address: json["ADDRESS"],
    );
  }
}
