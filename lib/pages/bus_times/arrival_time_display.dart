import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/classes/colors.dart';
import 'package:nyoom/classes/data_models/bus_arrival.dart';

class ArrivalTimeDisplay extends ConsumerStatefulWidget {
  final BusArrivalService busArrivalService;
  final VoidCallback? onRefresh;

  const ArrivalTimeDisplay({
    super.key,
    required this.busArrivalService,
    required this.onRefresh,
  });

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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        widget.onRefresh?.call();
      },
      child: Column(
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
                  ...(at1 < 0)
                      ? [
                          if (at1 == -1)
                            Center(
                              child: Text(
                                "(Not In\nOperation)",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.errorRed,
                                  fontSize: 72.sp,
                                  height: 1.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          if (at1 == -2)
                            Center(
                              child: SizedBox(
                                width: 72.sp,
                                height: 72.sp,
                                child: CircularProgressIndicator(
                                  strokeWidth: 4,
                                  color: AppColors.hintGray(ref),
                                ),
                              ),
                            ),
                          if (at1 == -3)
                            Center(
                              child: Text(
                                "(No Estimate\nAvailable)",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.errorRed,
                                  fontSize: 72.sp,
                                  height: 1.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ]
                      : [
                          Row(
                            children: [
                              (at1 == 0)
                                  ? Text(
                                      "N",
                                      style: TextStyle(
                                        fontSize: 130.sp,
                                        color: AppColors.nyoomGreen,
                                        fontWeight: FontWeight.w800,
                                        height: 1.0,
                                      ),
                                    )
                                  : Text(
                                      processAT(at1),
                                      style: TextStyle(
                                        fontSize: 150.sp,
                                        color: AppColors.nyoomYellow(ref),
                                        fontWeight: FontWeight.w800,
                                        height: 1.0,
                                      ),
                                    ),
                              (at1 == 0)
                                  ? Transform.translate(
                                      offset: Offset(0, -20.sp),
                                      child: Text(
                                        "ow",
                                        style: TextStyle(
                                          fontSize: 130.sp,
                                          color: AppColors.nyoomGreen,
                                          fontWeight: FontWeight.w800,
                                          height: 1.0,
                                        ),
                                      ),
                                    )
                                  : Transform.translate(
                                      offset: Offset(0, -20.sp),
                                      child: Text(
                                        "min",
                                        style: TextStyle(
                                          fontSize: 64.sp,
                                          color: AppColors.nyoomYellow(
                                            ref,
                                          ).withAlpha(191),
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
                                Opacity(
                                  opacity: (at2 == -1) ? 0 : 1,
                                  child: Icon(
                                    Icons.subdirectory_arrow_right,
                                    size: 56.sp,
                                    color: AppColors.hintGray(ref),
                                    fontWeight: FontWeight.w800,
                                  ),
                                  // child: Text(
                                  //   "Next: ",
                                  //   style: TextStyle(
                                  //     fontSize: 56.sp,
                                  //     color: AppColors.hintGray(ref),
                                  //     fontWeight: FontWeight.w800,
                                  //     height: 1.0,
                                  //   ),
                                  // ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  processAT(at2),
                                  style: TextStyle(
                                    fontSize: 96.sp,
                                    color: AppColors.nyoomBlue,
                                    fontWeight: FontWeight.w800,
                                    height: 1.0,
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                Opacity(
                                  opacity: (at3 == -1) ? 0 : 1,
                                  child: Text(
                                    ",",
                                    style: TextStyle(
                                      fontSize: 84.sp,
                                      color: AppColors.hintGray(
                                        ref,
                                      ).withAlpha(127),
                                      fontWeight: FontWeight.w800,
                                      height: 1.0,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20.w),
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
                                if (isWheelchairAccessible)
                                  Icon(
                                    Icons.accessible,
                                    size: 64.sp,
                                    color: AppColors.hintGray(ref),
                                  ),
                                (isDoubleDecker)
                                    ? Image.asset(
                                        'assets/images/double_decker_bus.png',
                                        width: 64.sp,
                                        height: 64.sp,
                                        fit: BoxFit.contain,
                                        color: AppColors.hintGray(ref),
                                      )
                                    : Icon(
                                        Icons.directions_bus,
                                        size: 64.sp,
                                        color: AppColors.hintGray(ref),
                                      ),
                                SizedBox(width: 5.w),
                                Stack(
                                  children: [
                                    Image.asset(
                                      'assets/images/load3.png',
                                      width: 64.sp,
                                      height: 64.sp,
                                      fit: BoxFit.contain,
                                      color: AppColors.hintGray(ref),
                                    ),
                                    if (load == "SEA")
                                      Image.asset(
                                        'assets/images/load1.png',
                                        width: 64.sp,
                                        height: 64.sp,
                                        fit: BoxFit.contain,
                                        color: AppColors.nyoomGreen,
                                      ),
                                    if (load == "SDA")
                                      Image.asset(
                                        'assets/images/load2.png',
                                        width: 64.sp,
                                        height: 64.sp,
                                        fit: BoxFit.contain,
                                        color: AppColors.nyoomYellow(ref),
                                      ),
                                    if (load == "LSD")
                                      Image.asset(
                                        'assets/images/load3.png',
                                        width: 64.sp,
                                        height: 64.sp,
                                        fit: BoxFit.contain,
                                        color: AppColors.errorRed,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                  // Unavailable
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
