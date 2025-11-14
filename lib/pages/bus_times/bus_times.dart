import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/classes/colors.dart';

class BusTimes extends ConsumerStatefulWidget {
  const BusTimes({super.key});

  @override
  ConsumerState<BusTimes> createState() => _BookmarksState();
}

enum FilterState { services, stops, normal }

class _BookmarksState extends ConsumerState<BusTimes> {
  FilterState filterState = FilterState.normal;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 45.h,
        children: [
          SizedBox(height: 90.h),
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
                fontSize: 48.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.primary(ref),
              ),
              onChanged: (value) {},
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
                      },),
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
                          fontWeight: (filterState == FilterState.services) ? FontWeight.w700 : FontWeight.w500,
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
                      });},
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
                          fontWeight: (filterState == FilterState.stops) ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
 