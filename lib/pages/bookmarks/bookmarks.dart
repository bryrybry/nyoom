import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/app_state.dart';
import 'package:nyoom/classes/data_models/bookmark.dart';
import 'package:nyoom/classes/data_models/bus_arrival.dart';
import 'package:nyoom/classes/helper.dart';
import 'package:nyoom/main.dart';
import 'package:nyoom/classes/colors.dart';
import 'package:nyoom/pages/bus_times/arrival_time_display.dart';
import 'package:nyoom/pages/bus_times/bookmark_star.dart';
import 'package:nyoom/services/api_service.dart';

class Bookmarks extends ConsumerStatefulWidget implements PageSettings {
  const Bookmarks({super.key});

  @override
  ConsumerState<Bookmarks> createState() => _BookmarksState();

  @override
  String? get pageTitle => "Your Bookmarks";
  @override
  bool get noNavBar => false;
}

class _BookmarksState extends ConsumerState<Bookmarks> {
  late List<Bookmark> importedBookmarks;
  final List<BookmarkAT> bookmarks = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    importedBookmarks = ref.read(bookmarksProvider.notifier).getBookmarks();
    await initList();
    await refreshList();
  }

  Future<void> initList() async {
    List<BookmarkAT> tempBookmarks = [];

    List<BusArrivalService> arrivalServices = importedBookmarks.map((_) {
      return BusArrivalService.initBusArrivalService();
    }).toList();
    for (int index = 0; index < arrivalServices.length; index++) {
      tempBookmarks.add(
        BookmarkAT.fromBookmark(
          importedBookmarks[index],
          arrivalServices[index],
        ),
      );
    }
    if (!mounted) return;
    setState(() {
      bookmarks
        ..clear()
        ..addAll(tempBookmarks);
    });
  }

  Future<void> refreshList() async {
    List<BookmarkAT> tempBookmarks = [];

    List<BusArrivalService> arrivalServices =
        await ApiService.busArrivalMultiqueueByPairs(
          importedBookmarks
              .map((e) => MapEntry(e.busStopCode, e.busService))
              .toList(),
        );

    for (int index = 0; index < arrivalServices.length; index++) {
      tempBookmarks.add(
        BookmarkAT.fromBookmark(
          importedBookmarks[index],
          arrivalServices[index],
        ),
      );
    }
    if (!mounted) return;
    setState(() {
      bookmarks
        ..clear()
        ..addAll(tempBookmarks);
    });
  }

  Future<void> refreshAT(BookmarkAT bookmarkAT) async {
    for (int n = 0; n < bookmarks.length; n++) {
      if (bookmarks[n].busService == bookmarkAT.busService &&
          bookmarks[n].busStopCode == bookmarkAT.busStopCode) {
        setState(() {
          bookmarks[n] = BookmarkAT.fromBookmark(
            bookmarkAT,
            BusArrivalService.initBusArrivalService(),
          );
        });
        final newArrival = await ApiService.busArrival(
          bookmarkAT.busStopCode,
          bookmarkAT.busService,
        );
        if (!mounted) return;
        setState(() {
          bookmarks[n] = BookmarkAT.fromBookmark(bookmarkAT, newArrival);
        });
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return importedBookmarks.isEmpty
        ? SadBookmark()
        : GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20.h,
              crossAxisSpacing: 20.w,
              childAspectRatio: 0.825,
            ),
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              return BookmarkPanel(
                bookmarkAT: bookmarks[index],
                onRefresh: () {
                  refreshAT(bookmarks[index]);
                },
                init: init,
              );
            },
          );
  }
}

class BookmarkPanel extends ConsumerStatefulWidget {
  final BookmarkAT bookmarkAT;
  final VoidCallback? onRefresh;
  final VoidCallback? init;

  const BookmarkPanel({
    super.key,
    required this.bookmarkAT,
    required this.onRefresh,
    required this.init,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookmarkPanelState();
}

class _BookmarkPanelState extends ConsumerState<BookmarkPanel> {
  late BookmarkAT bookmarkAT;
  bool deletionConfirmationMode = false;
  Timer? deletionTimer;

  @override
  void initState() {
    super.initState();
    bookmarkAT = widget.bookmarkAT;
  }

  @override
  void didUpdateWidget(covariant BookmarkPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bookmarkAT != widget.bookmarkAT) {
      setState(() {
        bookmarkAT = widget.bookmarkAT;
      });
    }
  }

  void deletionConfirmation() {
    deletionTimer?.cancel();
    setState(() {
      deletionConfirmationMode = true;
    });
    deletionTimer = Timer(Duration(seconds: 5), () {
      setState(() {
        deletionConfirmationMode = false;
      });
    });
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
                    Text(
                      bookmarkAT.busService,
                      style: TextStyle(
                        fontSize: 180.sp,
                        color: AppColors.primary(ref),
                        fontWeight: FontWeight.w800,
                        height: 1.0,
                      ),
                    ),
                    SizedBox(
                      height: 120.h,
                      child: Center(
                        child: AutoSizeText(
                          Helper.twoLineTextBalancer(
                            bookmarkAT.busStopName,
                            14,
                          ),
                          maxLines: 2,
                          minFontSize: (36.sp).roundToDouble(),
                          maxFontSize: (72.sp).roundToDouble(),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 72.sp,
                            color: AppColors.nyoomYellow(ref),
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: SizedBox(
                        height: 5.h,
                        width: double.infinity,
                        child: Container(color: AppColors.darkGray(ref)),
                      ),
                    ),
                    deletionConfirmationMode
                        ? Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Are you sure?",
                                  style: TextStyle(
                                    fontSize: 72.sp,
                                    color: AppColors.errorRed,
                                    fontWeight: FontWeight.w600,
                                    height: 1.0,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    deletionTimer?.cancel();
                                    final bookmarksNotifier = ref.read(
                                      bookmarksProvider.notifier,
                                    );
                                    final scaffoldMessenger =
                                        ScaffoldMessenger.of(context);
                                    bookmarksNotifier.removeBookmark(
                                      bookmarkAT,
                                    );
                                    widget.init!();
                                    deletionConfirmationMode = false;
                                    scaffoldMessenger.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Deleted ${bookmarkAT.busService} (${bookmarkAT.busStopName})",
                                          style: const TextStyle(
                                            color: AppColors.white,
                                          ),
                                        ),
                                        backgroundColor: AppColors.nyoomBlue,
                                        action: SnackBarAction(
                                          label: "Undo",
                                          textColor: AppColors.white,
                                          onPressed: () {
                                            bookmarksNotifier.addBookmark(
                                              bookmarkAT,
                                            );
                                            widget.init!();
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: Material(
                                    elevation: 3,
                                    color: AppColors.errorRed,
                                    borderRadius: BorderRadius.circular(80.r),
                                    child: Container(
                                      padding: EdgeInsets.zero,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          80.r,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 20.h,
                                          horizontal: 40.w,
                                        ),
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(
                                            fontSize: 72.sp,
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w600,
                                            height: 1.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ArrivalTimeDisplay(
                            busArrivalService: bookmarkAT.busArrivalService,
                            onRefresh: widget.onRefresh,
                          ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Transform.translate(
                    offset: Offset(0, 16.h),
                    child: BookmarkStar(
                      bookmark: widget.bookmarkAT,
                      onTap: () {
                        deletionConfirmation();
                      },
                    ),
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
