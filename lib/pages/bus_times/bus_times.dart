import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nyoom/app_state.dart';
import 'package:nyoom/classes/colors.dart';
import 'package:nyoom/classes/data_models/bus_service.dart';
import 'package:nyoom/classes/data_models/bus_stop.dart';
import 'package:nyoom/classes/data_models/bt_search_result.dart';
import 'package:nyoom/classes/helper.dart';
import 'package:nyoom/classes/static_data.dart';
import 'package:nyoom/pages/bus_times/bt_list.dart';
import 'package:nyoom/pages/bus_times/bt_map.dart';

class BusTimes extends ConsumerStatefulWidget {
  const BusTimes({super.key});

  @override
  ConsumerState<BusTimes> createState() => _BookmarksState();
}

enum FilterState { services, stops, nearby, normal }

enum NearbyModeState { loading, failed, ready }

enum NearbyModeFailureType { unknown, connection, locationPerms, tooFar }

class _BookmarksState extends ConsumerState<BusTimes> {
  FilterState filterState = FilterState.normal;
  List<String> busServices = [];
  List<BusStop> busStops = [];
  List<BTSearchResult> searchResults = [];
  String searchValue = "";
  NearbyModeState nearbyModeState = NearbyModeState.loading;
  NearbyModeFailureType nearbyModeFailureType = NearbyModeFailureType.unknown;
  List<NearbyBusStop> nearestBusStopsCache = [];

  @override
  void initState() {
    super.initState();
    searchResults = getBTSearchResultsCache();
    loadData();
  }

  Future<void> loadData() async {
    busServices = await StaticData.busServices();
    busStops = await StaticData.busStops();
  }

  void onSearchChanged({String? newValue}) {
    if (newValue != null) {
      searchValue = newValue;
    }
    setState(() {
      searchResults.clear();
      if (filterState == FilterState.nearby) {
        nearbySearch();
        return;
      }
      if (searchValue.isNotEmpty) {
        if (filterState != FilterState.stops) {
          for (var service in busServices) {
            if (service.toLowerCase().trim().contains(
              searchValue.toLowerCase().trim(),
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
                  searchValue.toLowerCase().trim(),
                ) ||
                stop.busStopName.toLowerCase().trim().contains(
                  searchValue.toLowerCase().trim(),
                )) {
              searchResults.add(BTSearchResult.fromBusStop(stop));
            }
          }
        }
      } else {
        searchResults = getBTSearchResultsCache();
      }
    });
  }

  void nearbySearch() async {
    final int nearbyStopsCount = 8;
    List<NearbyBusStop> nearestBusStops = [];
    if (nearestBusStopsCache.isNotEmpty) {
      nearestBusStops = List.from(nearestBusStopsCache);
    } else {
      try {
        bool hasInternet = await Helper.hasInternet();
        if (!hasInternet) {
          setState(() {
            nearbyModeState = NearbyModeState.failed;
            nearbyModeFailureType = NearbyModeFailureType.connection;
          });
          return;
        }
        Position? position = await Helper.getLocation();
        if (position == null || busStops.isEmpty) {
          setState(() {
            nearbyModeState = NearbyModeState.failed;
            nearbyModeFailureType = NearbyModeFailureType.locationPerms;
          });
          return;
        }
        for (BusStop stop in busStops) {
          if (stop.latitude == null || stop.longitude == null) continue;
          double distance = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            stop.latitude!,
            stop.longitude!,
          );
          if (distance <= 2500) {
            if (nearestBusStops.isEmpty) {
              nearestBusStops.add(NearbyBusStop(distance, stop));
            } else {
              if (distance < nearestBusStops.last.distance ||
                  nearestBusStops.length < nearbyStopsCount) {
                int insertionIndex = nearestBusStops.indexWhere(
                  (s) => s.distance > distance,
                );
                if (insertionIndex == -1) {
                  nearestBusStops.add(NearbyBusStop(distance, stop));
                } else {
                  nearestBusStops.insert(
                    insertionIndex,
                    NearbyBusStop(distance, stop),
                  );
                }
                if (nearestBusStops.length > nearbyStopsCount) {
                  nearestBusStops.removeLast();
                }
              }
            }
          }
        }
      } catch (e) {
        setState(() {
          nearbyModeState = NearbyModeState.failed;
          nearbyModeFailureType = NearbyModeFailureType.unknown;
        });
        return;
      }
    }
    setState(() {
      if (nearestBusStops.isEmpty) {
        nearbyModeState = NearbyModeState.failed;
        nearbyModeFailureType = NearbyModeFailureType.tooFar;
        return;
      }
      if (filterState != FilterState.nearby) return;
      for (NearbyBusStop stop in nearestBusStops) {
        searchResults.add(BTSearchResult.fromNearbyBusStop(stop));
      }
      nearbyModeState = NearbyModeState.ready;
      nearestBusStopsCache = List.from(nearestBusStops);
    });
  }

  List<BTSearchResult> getBTSearchResultsCache() {
    return List.from(ref.read(appDataProvider).btSearchResultsCache.reversed);
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
              onPressed: () {
                ref.read(navigationProvider)?.call(BTMap());
              },
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
                    "Bus Stops Map View",
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
              enabled: filterState != FilterState.nearby,
              style: TextStyle(
                fontSize: 56.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.primary(ref),
              ),
              onChanged: (value) => onSearchChanged(newValue: value),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.backgroundPanel(ref),
                hintText: switch (filterState) {
                  FilterState.normal || FilterState.nearby => "Find...",
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
                  FilterState.stops || FilterState.nearby => Icons.location_on,
                }),
              ),
            ),
          ),
          // 3 Filter Buttons
          SizedBox(
            width: 1120.w,
            height: 120.h,
            child: Row(
              spacing: 30.w,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bus Services Filter
                Expanded(
                  child: Opacity(
                    opacity:
                        (filterState == FilterState.services ||
                            filterState == FilterState.normal)
                        ? 1
                        : 0.5,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          filterState = (filterState == FilterState.services)
                              ? FilterState.normal
                              : FilterState.services;
                        });
                        onSearchChanged();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                        backgroundColor:
                            (filterState == FilterState.services ||
                                filterState == FilterState.normal)
                            ? AppColors.buttonPanel(ref)
                            : AppColors.buttonPanelPressed(ref),
                        elevation: 3,
                        shadowColor: switch (filterState) {
                          FilterState.normal => Colors.transparent,
                          FilterState.services => Colors.black,
                          FilterState.stops ||
                          FilterState.nearby => AppColors.hintGray(ref),
                        },
                        padding: EdgeInsets.zero,
                      ),
                      child: Center(
                        child: Text(
                          "Services",
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
                Expanded(
                  child: Opacity(
                    opacity:
                        (filterState == FilterState.stops ||
                            filterState == FilterState.normal)
                        ? 1
                        : 0.5,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          filterState = (filterState == FilterState.stops)
                              ? FilterState.normal
                              : FilterState.stops;
                        });
                        onSearchChanged();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                        backgroundColor:
                            (filterState == FilterState.stops ||
                                filterState == FilterState.normal)
                            ? AppColors.buttonPanel(ref)
                            : AppColors.buttonPanelPressed(ref),
                        elevation: 3,
                        shadowColor: switch (filterState) {
                          FilterState.normal => Colors.transparent,
                          FilterState.stops => Colors.black,
                          FilterState.nearby ||
                          FilterState.services => AppColors.hintGray(ref),
                        },
                        padding: EdgeInsets.zero,
                      ),
                      child: Center(
                        child: Text(
                          "Stops",
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
                // Nearby Mode
                Expanded(
                  child: Opacity(
                    opacity:
                        (filterState == FilterState.nearby ||
                            filterState == FilterState.normal)
                        ? 1
                        : 0.5,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          filterState = (filterState == FilterState.nearby)
                              ? FilterState.normal
                              : FilterState.nearby;
                        });
                        onSearchChanged();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                        backgroundColor:
                            (filterState == FilterState.nearby ||
                                filterState == FilterState.normal)
                            ? AppColors.buttonPanel(ref)
                            : AppColors.buttonPanelPressed(ref),
                        elevation: 3,
                        shadowColor: switch (filterState) {
                          FilterState.normal => Colors.transparent,
                          FilterState.nearby => AppColors.black,
                          FilterState.services ||
                          FilterState.stops => AppColors.hintGray(ref),
                        },
                        padding: EdgeInsets.zero,
                      ),
                      child: Center(
                        child: Text(
                          "Near Me",
                          style: TextStyle(
                            fontSize: 52.sp,
                            color: AppColors.primary(ref),
                            fontWeight: (filterState == FilterState.nearby)
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
          ),
          // Search Results
          if (getBTSearchResultsCache().isNotEmpty ||
              filterState == FilterState.nearby)
            Text(
              "————— ${filterState == FilterState.nearby ? "Nearby Bus Stops" : "Recent"} —————",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 42.sp,
                color: AppColors.hintGray(ref),
                fontWeight: FontWeight.w500,
                height: 0.5,
              ),
            ),
          Expanded(
            child:
                (filterState != FilterState.nearby ||
                    nearbyModeState == NearbyModeState.ready)
                ? ListView(
                    padding: EdgeInsets.zero,
                    children: searchResults.map((searchResult) {
                      return BTSearchResultPanel(
                        searchResult: searchResult,
                        onPressed: () {
                          ref
                              .read(appDataProvider.notifier)
                              .addSearchResultCache(
                                BTSearchResult.cleanDistanceSubheader(
                                  searchResult,
                                ),
                              );
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
                  )
                : Center(
                    child: nearbyModeState == NearbyModeState.loading
                        ? CircularProgressIndicator(
                            strokeWidth: 4,
                            color: AppColors.hintGray(ref),
                          )
                        : Text(
                          "Could not find nearby bus stops.\n${
                            switch (nearbyModeFailureType) {
                              NearbyModeFailureType.unknown =>
                                "Please try again later.",
                              NearbyModeFailureType.connection =>
                                "Please check your internet connection.",
                              NearbyModeFailureType.locationPerms =>
                                "Please enable location access.",
                              NearbyModeFailureType.tooFar =>
                                "Are you even in Singapore?",
                            }}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 42.sp,
                              color: AppColors.hintGray(ref),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
                          spacing: 40.w,
                          children: [
                            if (searchResult.distanceSubheader != null)
                              Text(
                                searchResult.distanceSubheader!,
                                style: TextStyle(
                                  fontSize: 48.sp,
                                  color: AppColors.errorRed,
                                  fontWeight: FontWeight.w800,
                                  height: 1.0,
                                ),
                              ),
                            Text(
                              searchResult.subheader1,
                              style: TextStyle(
                                fontSize: 48.sp,
                                color: AppColors.nyoomBlue,
                                fontWeight: FontWeight.w800,
                                height: 1.0,
                              ),
                            ),
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
