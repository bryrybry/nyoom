import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/app_state.dart';
import 'package:nyoom/classes/colors.dart';
import 'package:nyoom/classes/data_models/bookmark.dart';

class BookmarkStar extends ConsumerStatefulWidget {
  final Bookmark bookmark;

  const BookmarkStar({super.key, required this.bookmark});

  @override
  ConsumerState<BookmarkStar> createState() => _BookmarkStarState();
}

class _BookmarkStarState extends ConsumerState<BookmarkStar> {
  late Bookmark bookmark;
  late bool isBookmarked;

  @override
  void initState() {
    super.initState();
    bookmark = widget.bookmark;
    isBookmarked = ref.read(bookmarksProvider.notifier).bookmarkExists(bookmark);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          ref.read(bookmarksProvider.notifier).toggleBookmark(bookmark);
          isBookmarked = !isBookmarked;
        });
      },
      child: Icon(
        Icons.star,
        size: 78.sp,
        color: isBookmarked
            ? AppColors.nyoomYellow(ref)
            : AppColors.hintGray(ref),
      ),
    );
  }
}
