import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/app_state.dart';
import 'package:nyoom/classes/colors.dart';
import 'package:nyoom/classes/data_models/bus_service.dart';
import 'package:nyoom/classes/data_models/bus_stop.dart';
import 'package:nyoom/classes/data_models/bus_times_search_result.dart';
import 'package:nyoom/classes/static_data.dart';
import 'package:nyoom/pages/bus_times/bt_list.dart';

class BusTimes extends ConsumerStatefulWidget {
  const BusTimes({super.key});

  @override
  ConsumerState<BusTimes> createState() => _BookmarksState();
}

enum FilterState { services, stops, normal }

class _BookmarksState extends ConsumerState<BusTimes> {
  FilterState filterState = FilterState.normal;
  List<String> busServices = [];
  List<BusStop> busStops = [];
  List<BTSearchResult> searchResults = [];
  String searchValue = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    busServices = await StaticData.busServices();
    busStops = await StaticData.busStops();
  }

  void onSearchChanged(String value) {
    searchValue = value;
    setState(() {
      searchResults.clear();
      if (value.isNotEmpty) {
        if (filterState != FilterState.stops) {
          for (var service in busServices) {
            if (service.toLowerCase().trim().contains(
              value.toLowerCase().trim(),
            )) {
              searchResults.add(
                BTSearchResult.fromBusService(BusService(busService: service)),
              );
            }
          }
        }
        if (filterState != FilterState.services) {
          for (var stop in busStops) {
            if (stop.busStopCode.toLowerCase().trim().contains(
                  value.toLowerCase().trim(),
                ) ||
                stop.busStopName.toLowerCase().trim().contains(
                  value.toLowerCase().trim(),
                )) {
              searchResults.add(BTSearchResult.fromBusStop(stop));
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 45.h,
        children: [
          // View Map Button
          SizedBox(
            width: 1120.w,
            height: 180.h,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 84.sp, color: AppColors.primary(ref)),
                  SizedBox(width: 32.w),
                  Text(
                    "View Map",
                    style: TextStyle(
                      fontSize: 64.sp,
                      color: AppColors.primary(ref),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Search Bar
          SizedBox(
            width: 1120.w,
            height: 180.h,
            child: TextField(
              style: TextStyle(
                fontSize: 56.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.primary(ref),
              ),
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.backgroundPanel(ref),
                hintText: switch (filterState) {
                  FilterState.normal => "Find...",
                  FilterState.services => "Find Bus Services...",
                  FilterState.stops => "Find Bus Stops...",
                },
                hintStyle: TextStyle(fontSize: 56.sp),
                // hintText: '900, 901A, Dover Stn Exit A...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(60.r),
                ),
                prefixIcon: Icon(switch (filterState) {
                  FilterState.normal => Icons.search,
                  FilterState.services => Icons.directions_bus,
                  FilterState.stops => Icons.location_on,
                }),
              ),
            ),
          ),
          // 2 Filter Buttons
          Row(
            spacing: 45.w,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bus Services Filter
              SizedBox(
                width: 537.5.w,
                height: 140.h,
                child: Opacity(
                  opacity: (filterState == FilterState.stops) ? 0.5 : 1,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filterState = (filterState == FilterState.services)
                            ? FilterState.normal
                            : FilterState.services;
                      });
                      onSearchChanged(searchValue);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.r),
                      ),
                      backgroundColor: (filterState == FilterState.stops)
                          ? AppColors.buttonPanelPressed(ref)
                          : AppColors.buttonPanel(ref),
                      elevation: 3,
                      shadowColor: switch (filterState) {
                        FilterState.normal => Colors.transparent,
                        FilterState.services => Colors.black,
                        FilterState.stops => AppColors.hintGray(ref),
                      },
                      padding: EdgeInsets.zero,
                    ),
                    child: Center(
                      child: Text(
                        "Bus Services",
                        style: TextStyle(
                          fontSize: 52.sp,
                          color: AppColors.primary(ref),
                          fontWeight: (filterState == FilterState.services)
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Bus Stops Filter
              SizedBox(
                width: 537.5.w,
                height: 140.h,
                child: Opacity(
                  opacity: (filterState == FilterState.services) ? 0.5 : 1,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        filterState = (filterState == FilterState.stops)
                            ? FilterState.normal
                            : FilterState.stops;
                      });
                      onSearchChanged(searchValue);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.r),
                      ),
                      backgroundColor: (filterState == FilterState.services)
                          ? AppColors.buttonPanelPressed(ref)
                          : AppColors.buttonPanel(ref),
                      elevation: 3,
                      shadowColor: switch (filterState) {
                        FilterState.normal => Colors.transparent,
                        FilterState.services => AppColors.hintGray(ref),
                        FilterState.stops => Colors.black,
                      },
                      padding: EdgeInsets.zero,
                    ),
                    child: Center(
                      child: Text(
                        "Bus Stops",
                        style: TextStyle(
                          fontSize: 52.sp,
                          color: AppColors.primary(ref),
                          fontWeight: (filterState == FilterState.stops)
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Search Results
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: searchResults.map((searchResult) {
                return BTSearchResultPanel(
                  searchResult: searchResult,
                  onPressed: () {
                    ref
                        .read(navigationProvider)
                        ?.call(
                          BTList(
                            searchResult: searchResult,
                            searchHistoryList: [],
                          ),
                        );
                  },
                  ref: ref,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class BTSearchResultPanel extends StatelessWidget {
  final BTSearchResult searchResult;
  final VoidCallback? onPressed;
  final WidgetRef ref;

  const BTSearchResultPanel({
    super.key,
    required this.searchResult,
    required this.onPressed,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(settingsProvider).isDarkMode;
    return Column(
      children: [
        Center(
          child: SizedBox(
            width: 1120.w,
            height: 200.h,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(150.r),
                ),
                backgroundColor: AppColors.buttonPanel(ref),
                elevation: 3,
                padding: EdgeInsets.zero,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20.w),
                  SizedBox(
                    height: 140.w,
                    width: 140.w,
                    child: Center(
                      child: Icon(
                        searchResult.type == "busStop"
                            ? Icons.location_on
                            : Icons.directions_bus,
                        size: 120.sp,
                        color: AppColors.hintGray(ref),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 0,
                      children: [
                        Text(
                          searchResult.header,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 72.sp,
                            color: isDarkMode
                                ? AppColors.nyoomYellow(ref)
                                : AppColors.nyoomDarkYellow,
                            fontWeight: FontWeight.w500,
                            height: 1.0,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Text(
                              searchResult.subheader1,
                              style: TextStyle(
                                fontSize: 48.sp,
                                color: AppColors.nyoomBlue,
                                fontWeight: FontWeight.w800,
                                height: 1.0,
                              ),
                            ),
                            SizedBox(width: 40.w),
                            Text(
                              searchResult.subheader2,
                              style: TextStyle(
                                fontSize: 48.sp,
                                color: AppColors.nyoomGreen,
                                fontWeight: FontWeight.w700,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 40.w),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 25.h),
      ],
    );
  }
}
