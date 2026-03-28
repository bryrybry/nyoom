import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/app_state.dart';
import 'package:nyoom/main.dart';
import 'package:nyoom/classes/colors.dart';
import 'package:nyoom/pages/travel_routes/tr_search.dart';

class TravelRoutes extends ConsumerStatefulWidget implements PageSettings {
  const TravelRoutes({super.key});

  @override
  ConsumerState<TravelRoutes> createState() => _TravelRoutesState();

  @override
  String? get pageTitle => "Find a Route";
  @override
  bool get noNavBar => false;
}

class _TravelRoutesState extends ConsumerState<TravelRoutes> {
  static const String searchBarHint1 = "From...";
  static const String searchBarHint2 = "To where?";
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 45.h,
        children: [
          SizedBox(
            width: 1120.w,
            height: 180.h,
            child: ElevatedButton(
              onPressed: () {
                ref
                    .read(navigationProvider)
                    ?.call(TRSearch(searchBarHint: searchBarHint1));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60.r),
                ),
                backgroundColor: AppColors.backgroundPanel(ref),
                elevation: 0,
                padding: EdgeInsets.zero,
              ),
              child: Row(
                children: [
                  SizedBox(width: 32.w),
                  Icon(
                    Icons.location_on,
                    size: 64.sp,
                    color: AppColors.hintGray(ref),
                  ),
                  SizedBox(width: 32.w),
                  Text(
                    searchBarHint1,
                    style: TextStyle(
                      fontSize: 56.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.hintGray(ref),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 1120.w,
            height: 180.h,
            child: ElevatedButton(
              onPressed: () {
                ref
                    .read(navigationProvider)
                    ?.call(TRSearch(searchBarHint: searchBarHint2));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60.r),
                ),
                backgroundColor: AppColors.backgroundPanel(ref),
                elevation: 0,
                padding: EdgeInsets.zero,
              ),
              child: Row(
                children: [
                  SizedBox(width: 32.w),
                  Icon(
                    Icons.location_on,
                    size: 64.sp,
                    color: AppColors.hintGray(ref),
                  ),
                  SizedBox(width: 32.w),
                  Text(
                    searchBarHint2,
                    style: TextStyle(
                      fontSize: 56.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.hintGray(ref),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
