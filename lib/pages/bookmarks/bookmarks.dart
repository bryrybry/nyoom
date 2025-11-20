import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/app_state.dart';
import 'package:nyoom/classes/data_models/bookmark.dart';
import 'package:nyoom/main.dart';
import 'package:nyoom/classes/colors.dart';
import 'package:nyoom/pages/bus_times/bookmark_star.dart';

class Bookmarks extends ConsumerStatefulWidget implements HasPageTitle {
  const Bookmarks({super.key});

  @override
  ConsumerState<Bookmarks> createState() => _BookmarksState();

  @override
  String? get pageTitle => "Your Bookmarks";
}

class _BookmarksState extends ConsumerState<Bookmarks> {
  late Map<String, Bookmark> bookmarks;

  @override
  void initState() {
    super.initState();
    bookmarks = ref.read(bookmarksProvider.notifier).getBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkList = bookmarks.values.toList();
    return bookmarks.isEmpty
        ? SadBookmark()
        : GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20.h,
              crossAxisSpacing: 20.w,
              childAspectRatio: 3/4,
            ),
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              return BookmarkPanel(bookmark: bookmarkList[index]);
            },
          );
  }
}

class BookmarkPanel extends ConsumerStatefulWidget {
  final Bookmark bookmark;

  const BookmarkPanel({super.key, required this.bookmark});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookmarkPanelState();
}

class _BookmarkPanelState extends ConsumerState<BookmarkPanel> {
  late Bookmark bookmark;

  @override
  void initState() {
    super.initState();
    bookmark = widget.bookmark;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      color: AppColors.buttonPanel(ref),
      borderRadius: BorderRadius.circular(80.r),
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(80.r)),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
            child: Stack(
              children: [
                Column(
                  children: [
                    Text(
                      "Bus",
                      style: TextStyle(
                        fontSize: 42.sp,
                        color: AppColors.hintGray(ref),
                        fontWeight: FontWeight.w400,
                        height: 1.0,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        bookmark.busService,
                        style: TextStyle(
                          fontSize: 180.sp,
                          color: AppColors.primary(ref),
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                      width: double.infinity,
                      child: Container(color: AppColors.darkGray(ref)),
                    ),
                    // ArrivalTimeDisplay(
                    //   busArrivalService: busServiceAT.busArrivalService,
                    //   onRefresh: widget.onRefresh,
                    // ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Transform.translate(
                    offset: Offset(0, 16.h),
                    child: BookmarkStar(bookmark: widget.bookmark),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SadBookmark extends ConsumerWidget {
  const SadBookmark({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
