import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/classes/colors.dart';
import 'package:nyoom/classes/data_models/bus_service.dart';
import 'package:nyoom/classes/data_models/bus_stop.dart';
import 'package:nyoom/classes/static_data.dart';

class BusStopsList extends ConsumerStatefulWidget {
  final BusService busService;

  const BusStopsList({super.key, required this.busService});

  @override
  ConsumerState<BusStopsList> createState() => _BusStopsListState();
}

class _BusStopsListState extends ConsumerState<BusStopsList> {
  late BusService busService;
  final List<BusStopAT> stops = [];
  final List<BusStopAT> stops2 = [];
  List<BusStop> startend_stops = [];
  bool isOtherDirection = false;

  @override
  void initState() {
    super.initState();
    busService = widget.busService;
    generateList();
  }

  void generateList() {
    StaticData.busStopsMap().then((data) async {
      List<BusStopAT> tempStops = [];
      List<BusStopAT> tempStops2 = [];
      List<BusStop> allBusStops = await StaticData.busStops();
      for (var service in data.entries) {
        if (service.key == busService.busService) {
          for (var stop in service.value["1"] ?? []) {
            tempStops.add(
              BusStopAT.fromBusStopCode(stop[0], [" ", " ", " "], allBusStops),
            );
          }
          for (var stop in service.value["2"] ?? []) {
            tempStops2.add(
              BusStopAT.fromBusStopCode(stop[0], [" ", " ", " "], allBusStops),
            );
          }
          break;
        }
      }
      setState(() {
        stops.clear();
        stops2.clear();
        stops.addAll(tempStops);
        startend_stops = [tempStops[0], tempStops[tempStops.length - 1]];
        if (tempStops2.isNotEmpty) {
          stops2.addAll(tempStops2);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<BusStopAT> selectedStops = isOtherDirection ? stops2 : stops;
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 20.h,
        crossAxisSpacing: 20.w,
        childAspectRatio: 3,
      ),
      itemCount: selectedStops.length,
      itemBuilder: (context, index) {
        return BusStopPanel(busStopAT: selectedStops[index]);
      },
    );
  }
}

class BusStopPanel extends ConsumerStatefulWidget {
  final BusStopAT busStopAT;

  const BusStopPanel({super.key, required this.busStopAT});

  @override
  ConsumerState<BusStopPanel> createState() => _BusStopPanelState();
}

class _BusStopPanelState extends ConsumerState<BusStopPanel> {
  late BusStopAT busStopAT;
  @override
  void initState() {
    super.initState();
    busStopAT = widget.busStopAT;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 140.h,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80.r),
          ),
          backgroundColor: AppColors.buttonPanel(ref),
          elevation: 3,
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: Text(
            widget.busStopAT.busStopName, // show the actual service
            style: TextStyle(
              fontSize: 52.sp,
              color: AppColors.primary(ref),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
