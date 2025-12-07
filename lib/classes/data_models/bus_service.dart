import 'package:nyoom/classes/data_models/bus_arrival.dart';
import 'package:nyoom/classes/data_models/bt_search_result.dart';

class BusService {
  final String busService;

  BusService({required this.busService});
  factory BusService.fromSearchResult(BTSearchResult searchResult) {
    return BusService(busService: searchResult.value);
  }
}

class BusServiceAT extends BusService {
  final BusArrivalService busArrivalService;

  BusServiceAT({required super.busService, required this.busArrivalService});
}
