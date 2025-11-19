import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/classes/colors.dart';
import 'package:nyoom/classes/data_models/bus_arrival.dart';

class ArrivalTimeDisplay extends ConsumerStatefulWidget {
  final BusArrivalService busArrivalService;

  const ArrivalTimeDisplay({super.key, required this.busArrivalService});

  @override
  ConsumerState<ArrivalTimeDisplay> createState() => _ArrivalTimeDisplayState();
}

class _ArrivalTimeDisplayState extends ConsumerState<ArrivalTimeDisplay> {
  late int at1;
  late int at2;
  late int at3;
  bool isDoubleDecker = false;
  bool isEstimatedTime = false;
  bool isWheelchairAccessible = false;
  String load = "SEA";
  @override
  void initState() {
    super.initState();
    onArrivalTimesUpdated(widget.busArrivalService);
  }

  @override
  void didUpdateWidget(covariant ArrivalTimeDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.busArrivalService != widget.busArrivalService) {
      onArrivalTimesUpdated(widget.busArrivalService);
    }
  }

  onArrivalTimesUpdated(BusArrivalService busArrivalService) {
    setState(() {
      at1 = busArrivalService.nextBus.arrivalTime;
      at2 = busArrivalService.nextBus2.arrivalTime;
      at3 = busArrivalService.nextBus3.arrivalTime;
      isDoubleDecker = busArrivalService.nextBus.isDoubleDecker;
      isEstimatedTime = busArrivalService.nextBus.isEstimatedTime;
      isWheelchairAccessible = busArrivalService.nextBus.isWheelchairAccessible;
      load = busArrivalService.nextBus.load;
    });
  }

  String processAT(int at) {
    return (at == -1) ? " " : at.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Arriving in:",
          style: TextStyle(
            fontSize: 42.sp,
            color: AppColors.hintGray(ref),
            fontWeight: FontWeight.w600,
            height: 1.6,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: 240.h,
            width: 500.w,
            child: Stack(
              children: [
                // First Arrival Time
                Row(
                  children: [
                    (at1 == 0)
                        ? Text(
                            "N",
                            style: TextStyle(
                              fontSize: 160.sp,
                              color: AppColors.nyoomGreen,
                              fontWeight: FontWeight.w800,
                              height: 1.0,
                            ),
                          )
                        : Text(
                            processAT(at1),
                            style: TextStyle(
                              fontSize: 160.sp,
                              color: AppColors.nyoomYellow(ref),
                              fontWeight: FontWeight.w800,
                              height: 1.0,
                            ),
                          ),
                    (at1 == 0)
                        ? Transform.translate(
                            offset: Offset(0, -30.sp),
                            child: Text(
                              "ow",
                              style: TextStyle(
                                fontSize: 160.sp,
                                color: AppColors.nyoomGreen,
                                fontWeight: FontWeight.w800,
                                height: 1.0,
                              ),
                            ),
                          )
                        : Transform.translate(
                            offset: Offset(0, -20.sp),
                            child: Text(
                              "MIN",
                              style: TextStyle(
                                fontSize: 96.sp,
                                color: AppColors.nyoomYellow(ref),
                                fontWeight: FontWeight.w900,
                                height: 1.0,
                              ),
                            ),
                          ),
                  ],
                ),
                // Second & Third Arrival Times
                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Next:  ",
                        style: TextStyle(
                          fontSize: 56.sp,
                          color: AppColors.hintGray(ref),
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                        ),
                      ),
                      Text(
                        processAT(at2),
                        style: TextStyle(
                          fontSize: 96.sp,
                          color: AppColors.nyoomBlue,
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                        ),
                      ),
                      Text(
                        ", ",
                        style: TextStyle(
                          fontSize: 96.sp,
                          color: AppColors.hintGray(ref),
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                        ),
                      ),
                      Text(
                        processAT(at3),
                        style: TextStyle(
                          fontSize: 96.sp,
                          color: AppColors.nyoomBlue,
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                // Bus Special Icons
                Transform.translate(
                  offset: Offset(0, 20.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_bus,
                        size: 64.sp,
                        color: AppColors.hintGray(ref),
                      ),
                      Icon(
                        Icons.accessible,
                        size: 64.sp,
                        color: AppColors.hintGray(ref),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
