import 'package:nyoom/classes/data_models/bus_times_search_result.dart';

class BusService {
  final String busService;

  BusService({
    required this.busService,
  });
  factory BusService.fromSearchResult(BTSearchResult searchResult) {
    return BusService(
      busService: searchResult.value,
    );
  }
}

class BusServiceAT extends BusService {
  final List<String> arrivalTimes;

  BusServiceAT({
    required super.busService,
    required this.arrivalTimes,
  });

  List<String> getArrivalTimes() {
    return arrivalTimes;
  }
}