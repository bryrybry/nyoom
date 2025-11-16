import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/app_state.dart';
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
  bool isOtherDirection = false;

  @override
  void initState() {
    super.initState();
    busService = widget.busService;
    generateList();
  }
  // TODO: STORE DIRECTION

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
        if (tempStops2.isNotEmpty) {
          stops2.addAll(tempStops2);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<BusStopAT> selectedStops = isOtherDirection ? stops2 : stops;
    return Column(
      children: [
        if (stops2.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isOtherDirection = !isOtherDirection;
                });
              },
              child: AutoSizeText(
                !isOtherDirection
                    ? "${selectedStops[0].busStopName}  ▷  ${selectedStops[selectedStops.length - 1].busStopName}"
                    : "${selectedStops[selectedStops.length - 1].busStopName}  ◁  ${selectedStops[0].busStopName}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 60.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          )
        else
          Container(),
        SizedBox(height: 40.h),
        Expanded(
          child: GridView.builder(
            key: ValueKey(isOtherDirection),
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 20.h,
              crossAxisSpacing: 20.w,
              childAspectRatio: 2.8,
            ),
            itemCount: selectedStops.length,
            itemBuilder: (context, index) {
              return BusStopPanel(busStopAT: selectedStops[index]);
            },
          ),
        ),
      ],
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  busStopAT.busStopName,
                  style: TextStyle(
                    fontSize: 96.sp,
                    color: AppColors.primary(ref),
                    fontWeight: FontWeight.w700,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            busStopAT.roadName,
                            style: TextStyle(
                              fontSize: 60.sp,
                              color: ref.watch(isDarkModeProvider)
                                  ? AppColors.nyoomYellow(ref)
                                  : AppColors.nyoomDarkYellow,
                              fontWeight: FontWeight.w500,
                              height: 1.0,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "(${busStopAT.busStopCode})",
                            style: TextStyle(
                              fontSize: 48.sp,
                              color: AppColors.hintGray(ref),
                              fontWeight: FontWeight.w500,
                              height: 2.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: SizedBox(
                        width: 5.w,
                        child: Container(color: AppColors.darkGray(ref)),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Arriving in:",
                          style: TextStyle(
                            fontSize: 42.sp,
                            color: AppColors.hintGray(ref),
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 400.w,
                            child: Stack(children: [
                              
                            ],),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
