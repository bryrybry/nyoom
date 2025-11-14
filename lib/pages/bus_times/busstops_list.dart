import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyoom/classes/data_models/bus_service.dart';
import 'package:nyoom/classes/data_models/bus_stop.dart';
import 'package:nyoom/classes/static_data.dart';

class BusStopsList extends ConsumerStatefulWidget {
  final BusStop busStop;

  const BusStopsList({
    super.key,
    required this.busStop,
  });

  @override
  ConsumerState<BusStopsList> createState() => _BusStopsListState();
}

class _BusStopsListState extends ConsumerState<BusStopsList> {
  late BusStop busStop;
  final List<BusServiceAT> services = [];

  @override
  void initState() {
    super.initState();
    busStop = widget.busStop;
    generateList();
  }
  
  void generateList() {
    StaticData.busServicesAtStop().then((data) {
      List<BusServiceAT> tempServices = [];
      for (var entry in data.entries) {
        if (entry.key == busStop.busStopCode) {
          for (String service in entry.value) {
            tempServices.add(
            BusServiceAT(
              busService: service,
              arrivalTimes: [" ", " ", " "],
            ),
          );
          }
          break;
        }
      }
      setState(() {
        services.clear();
        services.addAll(tempServices);
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}