import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nyoom/classes/colors.dart';
import 'package:nyoom/classes/data_models/bus_stop.dart';
import 'package:nyoom/classes/helper.dart';
import 'package:nyoom/classes/static_data.dart';
import 'package:nyoom/pages/bus_times/busservices_list.dart';
import 'package:nyoom/widgets/wide_button.dart';

class BTMap extends ConsumerStatefulWidget {
  const BTMap({super.key});

  @override
  ConsumerState<BTMap> createState() => _BTMapState();
}

enum MapPreparationState { loading, failed, ready }

enum FailureType { unknown, connection, locationPerms }

enum ArrivalTimeUIState { hideBar, showBar, showAT }

class _BTMapState extends ConsumerState<BTMap> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  late LatLng _initialPosition;
  late List<BusStop> busStopsStaticData;
  LatLngBounds? _lastBounds;
  bool _mapReady = false;
  BusStop? activeBusStop;
  ArrivalTimeUIState arrivalTimeUIState = ArrivalTimeUIState.hideBar;
  MapPreparationState mapPreparationState = MapPreparationState.loading;
  FailureType failureType = FailureType.unknown;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setState(() => mapPreparationState = MapPreparationState.loading);

    try {
      bool hasInternet = await Helper.hasInternet();
      if (!hasInternet) {
        setState(() {
          failureType = FailureType.connection;
          mapPreparationState = MapPreparationState.failed;
        });
        return;
      }
      Position? position = await Helper.getLocation();
      if (position == null) {
        setState(() {
          failureType = FailureType.locationPerms;
          mapPreparationState = MapPreparationState.failed;
        });
        return;
      }
      _initialPosition = LatLng(position.latitude, position.longitude);
      busStopsStaticData = await StaticData.busStops();
    } catch (e) {
      setState(() {
        failureType = FailureType.unknown;
        mapPreparationState = MapPreparationState.failed;
      });
      return;
    }

    setState(() => mapPreparationState = MapPreparationState.ready);
  }

  Future<void> updateMarkers() async {
    if (!_mapReady) return;

    final bounds = await _mapController.getVisibleRegion();

    // Avoid unnecessary rebuilds
    if (_lastBounds == bounds) return;
    _lastBounds = bounds;

    final newMarkers = <Marker>{};

    for (final busStop in busStopsStaticData) {
      if (busStop.latitude == null || busStop.longitude == null) continue;

      final pos = LatLng(busStop.latitude!, busStop.longitude!);

      if (_isInBounds(bounds, pos)) {
        newMarkers.add(
          Marker(
            markerId: MarkerId(busStop.busStopCode),
            position: pos,
            infoWindow: InfoWindow(title: busStop.busStopName),
            onTap: () {
              setState(() {
                arrivalTimeUIState = ArrivalTimeUIState.showBar;
                activeBusStop = busStop;
              });
            },
          ),
        );
      }
    }

    setState(() {
      _markers
        ..clear()
        ..addAll(newMarkers);
    });
  }

  bool _isInBounds(LatLngBounds bounds, LatLng point) {
    return point.latitude >= bounds.southwest.latitude &&
        point.latitude <= bounds.northeast.latitude &&
        point.longitude >= bounds.southwest.longitude &&
        point.longitude <= bounds.northeast.longitude;
  }

  @override
  Widget build(BuildContext context) {
    return (mapPreparationState == MapPreparationState.ready)
        ? Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 18,
                ),
                markers: _markers,
                onMapCreated: (controller) {
                  _mapController = controller;
                  _mapReady = true;
                  updateMarkers();
                },
                onTap: (_) {
                  setState(() {
                    arrivalTimeUIState = ArrivalTimeUIState.hideBar;
                    activeBusStop = null;
                  });
                },
                onCameraIdle: updateMarkers,
                zoomGesturesEnabled: true, // allow pinch zoom
                zoomControlsEnabled: true, // optional + / - buttons
                scrollGesturesEnabled: true, // allow panning
                minMaxZoomPreference: const MinMaxZoomPreference(16, 19),
              ),
              if (arrivalTimeUIState == ArrivalTimeUIState.showBar)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsetsGeometry.directional(bottom: 40.h),
                    child: WideButton(
                      onPressed: () {
                        setState(() {
                          arrivalTimeUIState = ArrivalTimeUIState.showAT;
                        });
                      },
                      color: AppColors.nyoomBlue,
                      textColor: AppColors.white,
                      text: "Check Bus Arrival Times",
                    ),
                  ),
                ),
              if (activeBusStop != null &&
                  arrivalTimeUIState == ArrivalTimeUIState.showAT) ...[
                Container(color: AppColors.black.withAlpha(191)),
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.w,
                          vertical: 40.h,
                        ),
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  arrivalTimeUIState =
                                      ArrivalTimeUIState.showBar;
                                });
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 120.sp,
                                color: AppColors.white,
                              ),
                            ),
                            Center(
                              child: Text(
                                "Bus ${activeBusStop!.busStopName}",
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 72.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: BusServicesList(busStop: activeBusStop!)),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ],
            ],
          )
        : Center(
            child: mapPreparationState == MapPreparationState.loading
                ? CircularProgressIndicator(
                    strokeWidth: 4,
                    color: AppColors.hintGray(ref),
                  )
                : Text(
                    "Cannot load map.\n${switch (failureType) {
                      FailureType.unknown => "Unable to load map. Try again later.",
                      FailureType.connection => "Please check your internet connection.",
                      FailureType.locationPerms => "Please enable location access.",
                    }}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 42.sp,
                      color: AppColors.hintGray(ref),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          );
  }
}
