import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/app_state.dart';
import 'package:nyoom/classes/colors.dart';
import 'package:nyoom/classes/data_models/bookmark.dart';
import 'package:nyoom/classes/data_models/bus_arrival.dart';
import 'package:nyoom/classes/data_models/bus_service.dart';
import 'package:nyoom/classes/data_models/bus_stop.dart';
import 'package:nyoom/classes/data_models/bt_search_result.dart';
import 'package:nyoom/classes/static_data.dart';
import 'package:nyoom/pages/bus_times/arrival_time_display.dart';
import 'package:nyoom/pages/bus_times/bookmark_star.dart';
import 'package:nyoom/pages/bus_times/bt_list.dart';
import 'package:nyoom/services/api_service.dart';

class BusStopsList extends ConsumerStatefulWidget {
  final BusService busService;
  final List<BTSearchResult> searchHistoryList;

  const BusStopsList({
    super.key,
    required this.busService,
    required this.searchHistoryList,
  });

  @override
  ConsumerState<BusStopsList> createState() => _BusStopsListState();
}

class _BusStopsListState extends ConsumerState<BusStopsList> {
  late Map<String, Map<String, List<dynamic>>> busStopsMapStaticData;
  late List<BusStop> busStopsStaticData;
  late BusService busService;
  final List<BusStopAT> stops = [];
  bool isOtherDirection = false;
  bool hasOtherDirection = false;

  @override
  void initState() {
    super.initState();
    busService = widget.busService;
    init();
  }

  Future<void> init() async {
    busStopsMapStaticData = await StaticData.busStopsMap();
    busStopsStaticData = await StaticData.busStops();
    await initList();
    await refreshList();
  }

  Future<void> initList() async {
    List<BusStopAT> tempStops = [];

    String selectedDirection = isOtherDirection ? "2" : "1";
    hasOtherDirection =
        busStopsMapStaticData[busService.busService]?.containsKey("2") ?? false;

    List<String> busStopCodes =
        (busStopsMapStaticData[busService.busService]?[selectedDirection]
                    ?.map((e) => e[0])
                    .toList()
                as List<dynamic>)
            .cast<String>();
    List<BusArrivalService> arrivalServices = busStopCodes.map((_) {
      return BusArrivalService.initBusArrivalService();
    }).toList();
    for (int index = 0; index < arrivalServices.length; index++) {
      tempStops.add(
        BusStopAT.fromBusStopCode(
          busStopCodes[index],
          arrivalServices[index],
          busStopsStaticData,
        ),
      );
    }
    if (!mounted) return;
    setState(() {
      stops
        ..clear()
        ..addAll(tempStops);
    });
  }

  Future<void> refreshList() async {
    List<BusStopAT> tempStops = [];

    String selectedDirection = isOtherDirection ? "2" : "1";
    hasOtherDirection =
        busStopsMapStaticData[busService.busService]?.containsKey("2") ?? false;

    List<String> busStopCodes =
        (busStopsMapStaticData[busService.busService]?[selectedDirection]
                    ?.map((e) => e[0])
                    .toList()
                as List<dynamic>)
            .cast<String>();
    List<BusArrivalService> arrivalServices =
        await ApiService.busArrivalMultiqueue(
          busStopCodes: busStopCodes,
          busServices: [busService.busService],
        );
    for (int index = 0; index < arrivalServices.length; index++) {
      tempStops.add(
        BusStopAT.fromBusStopCode(
          busStopCodes[index],
          arrivalServices[index],
          busStopsStaticData,
        ),
      );
    }
    if (!mounted) return;
    setState(() {
      stops
        ..clear()
        ..addAll(tempStops);
    });
  }

  Future<void> refreshAT(BusStopAT busStopAT) async {
    for (int n = 0; n < stops.length; n++) {
      if (stops[n].busStopCode == busStopAT.busStopCode) {
        setState(() {
          stops[n] = BusStopAT.fromBusStopCode(
            busStopAT.busStopCode,
            BusArrivalService.initBusArrivalService(),
            busStopsStaticData,
          );
        });
        final newArrival = await ApiService.busArrival(
          busStopAT.busStopCode,
          busService.busService,
        );
        if (!mounted) return;
        setState(() {
          stops[n] = BusStopAT.fromBusStopCode(
            busStopAT.busStopCode,
            newArrival,
            busStopsStaticData,
          );
        });
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (hasOtherDirection)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (stops[0].busArrivalService.nextBus.arrivalTime == -2) {
                    return;
                  }
                  isOtherDirection = !isOtherDirection;
                  initList();
                  refreshList();
                });
              },
              child: Material(
                elevation: 3,
                color: AppColors.buttonPanel(ref),
                borderRadius: BorderRadius.circular(80.r),
                child: Container(
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.w,
                      vertical: 20.h,
                    ),
                    child: AutoSizeText(
                      "${stops[0].busStopName}  ▷  ${stops[stops.length - 1].busStopName}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 60.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        if (hasOtherDirection) SizedBox(height: 40.h),
        Expanded(
          child: GridView.builder(
            key: ValueKey(isOtherDirection),
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 20.h,
              crossAxisSpacing: 20.w,
              childAspectRatio: 3.45,
            ),
            itemCount: stops.length,
            itemBuilder: (context, index) {
              return BusStopPanel(
                busStopAT: stops[index],
                onRefresh: () {
                  refreshAT(stops[index]);
                },
                bookmark: Bookmark.fromBusDataModels(stops[index], busService),
                searchHistoryList: [
                  ...widget.searchHistoryList,
                  BTSearchResult.fromBusService(busService),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class BusStopPanel extends ConsumerStatefulWidget {
  final BusStopAT busStopAT;
  final VoidCallback? onRefresh;
  final Bookmark bookmark;
  final List<BTSearchResult> searchHistoryList;

  const BusStopPanel({
    super.key,
    required this.busStopAT,
    required this.onRefresh,
    required this.bookmark,
    required this.searchHistoryList,
  });

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
  void didUpdateWidget(covariant BusStopPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.busStopAT != widget.busStopAT) {
      setState(() {
        busStopAT = widget.busStopAT;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Material(
        elevation: 3,
        color: AppColors.buttonPanel(ref),
        borderRadius: BorderRadius.circular(80.r),
        child: Container(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(80.r)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              ref
                                  .read(navigationProvider)
                                  ?.call(
                                    BTList(
                                      key: ValueKey(busStopAT.busStopCode),
                                      searchResult: BTSearchResult.fromBusStop(
                                        busStopAT,
                                      ),
                                      searchHistoryList:
                                          widget.searchHistoryList,
                                    ),
                                  );
                            },
                            child: SizedBox(
                              height: 120.h,
                              child: AutoSizeText(
                                busStopAT.busStopName,
                                maxLines: 2,
                                minFontSize: (48.sp).roundToDouble(),
                                maxFontSize: (84.sp).roundToDouble(),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 84.sp,
                                  color: AppColors.primary(ref),
                                  fontWeight: FontWeight.w800,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            busStopAT.roadName,
                            style: TextStyle(
                              fontSize: 48.sp,
                              color: ref.watch(settingsProvider).isDarkMode
                                  ? AppColors.nyoomYellow(ref)
                                  : AppColors.nyoomDarkYellow,
                              fontWeight: FontWeight.w600,
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
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Transform.translate(
                          offset: Offset(0, -16.h),
                          child: BookmarkStar(bookmark: widget.bookmark),
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
                ArrivalTimeDisplay(
                  busArrivalService: busStopAT.busArrivalService,
                  onRefresh: widget.onRefresh,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
