class BusServices {
  final String busService;

  BusServices({required this.busService});

  factory BusServices.fromJson(Map<String, dynamic> json) {
    return BusServices(busService: json['busService']);
  }
}