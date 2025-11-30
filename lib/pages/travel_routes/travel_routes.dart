import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/main.dart';
import 'package:nyoom/classes/colors.dart';

class TravelRoutes extends ConsumerStatefulWidget implements PageSettings {
  const TravelRoutes({super.key});

  @override
  ConsumerState<TravelRoutes> createState() => _BookmarksState();

  @override
  String? get pageTitle => "Find a Route";
  @override
  bool get noNavBar => false;
}

class _BookmarksState extends ConsumerState<TravelRoutes> {
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
              onPressed: () {},
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
                    "From...",
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
              onPressed: () {},
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
                    "To where?",
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
