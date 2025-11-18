import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/classes/colors.dart';

class ArrivalTimeDisplay extends ConsumerStatefulWidget {
  final List<int> arrivalTimes;

  const ArrivalTimeDisplay({super.key, required this.arrivalTimes});

  @override
  ConsumerState<ArrivalTimeDisplay> createState() => _ArrivalTimeDisplayState();
}

class _ArrivalTimeDisplayState extends ConsumerState<ArrivalTimeDisplay> {
  late List<String> arrivalTimes;
  @override
  void initState() {
    super.initState();
    onArrivalTimesUpdated(widget.arrivalTimes);
  }

  @override
  void didUpdateWidget(covariant ArrivalTimeDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.arrivalTimes != widget.arrivalTimes) {
      onArrivalTimesUpdated(widget.arrivalTimes);
    }
  }

  onArrivalTimesUpdated(List<int> arrivalTimesRaw) {
    List<String> newArrivalTimes = List.filled(arrivalTimesRaw.length, "");
    for (int i = 0; i < arrivalTimesRaw.length; i++) {
      switch (arrivalTimesRaw[i]) {
        case 0:
          newArrivalTimes[i] = "Now";
          break;
        case -1:
          newArrivalTimes[i] = "";
          break;
        default:
          newArrivalTimes[i] = arrivalTimesRaw[i].toString();
          break;
      }
    }
    setState(() {
      arrivalTimes = newArrivalTimes;
    });
  }

  @override
  Widget build(BuildContext context) {
    onArrivalTimesUpdated([10, 20, 55]);
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
                    (arrivalTimes[0] == "Now")
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
                            arrivalTimes[0],
                            style: TextStyle(
                              fontSize: 160.sp,
                              color: AppColors.nyoomYellow(ref),
                              fontWeight: FontWeight.w800,
                              height: 1.0,
                            ),
                          ),
                    (arrivalTimes[0] == "Now")
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
                        "${arrivalTimes[1]} ${arrivalTimes[2]}",
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
