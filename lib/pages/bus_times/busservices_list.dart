import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/app_state.dart';
import 'package:nyoom/classes/colors.dart';
import 'package:nyoom/classes/data_models/bookmark.dart';
import 'package:nyoom/classes/data_models/bus_arrival.dart';
import 'package:nyoom/classes/data_models/bus_service.dart';
import 'package:nyoom/classes/data_models/bus_stop.dart';
import 'package:nyoom/classes/data_models/bus_times_search_result.dart';
import 'package:nyoom/classes/static_data.dart';
import 'package:nyoom/pages/bus_times/arrival_time_display.dart';
import 'package:nyoom/pages/bus_times/bookmark_star.dart';
import 'package:nyoom/pages/bus_times/bt_list.dart';
import 'package:nyoom/services/api_service.dart';

class BusServicesList extends ConsumerStatefulWidget {
  final BusStop busStop;

  const BusServicesList({super.key, required this.busStop});

  @override
  ConsumerState<BusServicesList> createState() => _BusServicesListState();
}

class _BusServicesListState extends ConsumerState<BusServicesList> {
  late Map<String, List<String>> busServicesAtStopStaticData;
  late BusStop busStop;
  final List<BusServiceAT> services = [];

  @override
  void initState() {
    super.initState();
    busStop = widget.busStop;
    init();
  }

  Future<void> init() async {
    busServicesAtStopStaticData = await StaticData.busServicesAtStop();
    await initList();
    await refreshList();
  }

  Future<void> initList() async {
    List<BusServiceAT> tempServices = [];

    List<String> busServices =
        busServicesAtStopStaticData[busStop.busStopCode] ?? [];
    List<BusArrivalService> arrivalServices = busServices.map((_) {
      return BusArrivalService.initBusArrivalService();
    }).toList();
    for (int index = 0; index < arrivalServices.length; index++) {
      tempServices.add(
        BusServiceAT(
          busService: busServices[index],
          busArrivalService: arrivalServices[index],
        ),
      );
    }
    if (!mounted) return;
    setState(() {
      services
        ..clear()
        ..addAll(tempServices);
    });
  }

  Future<void> refreshList() async {
    List<BusServiceAT> tempServices = [];

    List<String> busServices =
        busServicesAtStopStaticData[busStop.busStopCode] ?? [];
    List<BusArrivalService> arrivalServices =
        await ApiService.busArrivalMultiqueue(
          busStopCodes: [busStop.busStopCode],
          busServices: busServices,
        );
    for (int index = 0; index < arrivalServices.length; index++) {
      tempServices.add(
        BusServiceAT(
          busService: busServices[index],
          busArrivalService: arrivalServices[index],
        ),
      );
    }
    if (!mounted) return;
    setState(() {
      services
        ..clear()
        ..addAll(tempServices);
    });
  }

  Future<void> refreshAT(BusServiceAT busServiceAT) async {
    for (int n = 0; n < services.length; n++) {
      if (services[n].busService == busServiceAT.busService) {
        setState(() {
          services[n] = BusServiceAT(
            busService: busServiceAT.busService,
            busArrivalService: BusArrivalService.initBusArrivalService(),
          );
        });
        final newArrival = await ApiService.busArrival(
          busStop.busStopCode,
          busServiceAT.busService,
        );
        if (!mounted) return;
        setState(() {
          services[n] = BusServiceAT(
            busService: busServiceAT.busService,
            busArrivalService: newArrival,
          );
        });
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20.h,
        crossAxisSpacing: 20.w,
        childAspectRatio: 0.975,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return BusServicePanel(
          busServiceAT: services[index],
          onRefresh: () {
            refreshAT(services[index]);
          },
          bookmark: Bookmark.fromBusDataModels(busStop, services[index]),
        );
      },
    );
  }
}

class BusServicePanel extends ConsumerStatefulWidget {
  final BusServiceAT busServiceAT;
  final VoidCallback? onRefresh;
  final Bookmark bookmark;

  const BusServicePanel({
    super.key,
    required this.busServiceAT,
    required this.onRefresh,
    required this.bookmark,
  });

  @override
  ConsumerState<BusServicePanel> createState() => _BusServicePanelState();
}

class _BusServicePanelState extends ConsumerState<BusServicePanel> {
  late BusServiceAT busServiceAT;
  @override
  void initState() {
    super.initState();
    busServiceAT = widget.busServiceAT;
  }

  @override
  void didUpdateWidget(covariant BusServicePanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.busServiceAT != widget.busServiceAT) {
      setState(() {
        busServiceAT = widget.busServiceAT;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      color: AppColors.buttonPanel(ref),
      borderRadius: BorderRadius.circular(80.r),
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(80.r)),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
            child: Stack(
              children: [
                Column(
                  children: [
                    Text(
                      "Bus",
                      style: TextStyle(
                        fontSize: 42.sp,
                        color: AppColors.hintGray(ref),
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ref
                            .read(navigationProvider)
                            ?.call(
                              BTList(
                                key: ValueKey(busServiceAT.busService),
                                searchResult: BTSearchResult.fromBusService(
                                  busServiceAT,
                                ),
                              ),
                            );
                      },
                      child: Text(
                        busServiceAT.busService,
                        style: TextStyle(
                          fontSize: 180.sp,
                          color: AppColors.primary(ref),
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: SizedBox(
                        height: 5.h,
                        width: double.infinity,
                        child: Container(color: AppColors.darkGray(ref)),
                      ),
                    ),
                    ArrivalTimeDisplay(
                      busArrivalService: busServiceAT.busArrivalService,
                      onRefresh: widget.onRefresh,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Transform.translate(
                    offset: Offset(0, 16.h),
                    child: BookmarkStar(bookmark: widget.bookmark),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
