import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/main.dart';
import 'package:nyoom/themes/colors.dart';

class Bookmarks extends ConsumerStatefulWidget implements HasPageTitle {
  const Bookmarks({super.key});

  @override
  ConsumerState<Bookmarks> createState() => _BookmarksState();

  @override
  String? get pageTitle => "Your Bookmarks";
}

class _BookmarksState extends ConsumerState<Bookmarks> {
  @override
  Widget build(BuildContext context) {
    final noBookmarks = true; // Placeholder for neowww
    // ignore: dead_code
    return noBookmarks ? SadBookmark() : Container();
  }
}

class SadBookmark extends StatelessWidget {
  const SadBookmark({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/sadbookmark.png',
              width: 600.w,
              height: 800.h,
              fit: BoxFit.cover,
            ),
            Text(
              "No Bookmarks",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 96.sp,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            Text(
              "at the moment!",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 72.sp,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
