import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/classes/data_models/onemap_search_result.dart';
import 'package:nyoom/main.dart';
import 'package:nyoom/classes/colors.dart';
import 'package:nyoom/providers/settings_provider.dart';
import 'package:nyoom/services/api_service.dart';

class TRSearch extends ConsumerStatefulWidget implements PageSettings {
  final String searchBarHint;
  const TRSearch({super.key, required this.searchBarHint});

  @override
  ConsumerState<TRSearch> createState() => _TRSearchState();

  @override
  String? get pageTitle => "Find a Route";
  @override
  bool get noNavBar => false;
}

class _TRSearchState extends ConsumerState<TRSearch> {
  List<OnemapSearchResult> searchResults = [];
  String searchValue = "";

  Future<void> onSearchChanged(newValue) async {
    if (newValue != null) {
      searchValue = newValue;
    }
    List<OnemapSearchResult> onemapSearchResults =
        await ApiService.onemapSearch(ref, searchValue);
    setState(() {
      searchResults.clear();
      if (searchValue.isNotEmpty) {
        searchResults = [...onemapSearchResults];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 45.h,
        children: [
          SizedBox(
            width: 1120.w,
            height: 180.h,
            child: TextField(
              autofocus: true,
              style: TextStyle(
                fontSize: 56.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.primary(ref),
              ),
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.backgroundPanel(ref),
                hintText: widget.searchBarHint,
                hintStyle: TextStyle(fontSize: 56.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(60.r),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          YourLocationButton(ref: ref),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                return TRSearchResultPanel(
                  searchResult: searchResults[index],
                  ref: ref,
                );
              },
              separatorBuilder: (context, index) =>
                  SizedBox(height: 25.h), // fixed spacing
            ),
          ),
        ],
      ),
    );
  }
}

class TRSearchResultPanel extends StatelessWidget {
  final OnemapSearchResult searchResult;
  final WidgetRef ref;

  const TRSearchResultPanel({
    super.key,
    required this.searchResult,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(settingsProvider).isDarkMode;
    return Center(
      child: SizedBox(
        width: 1120.w,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(150.r),
            ),
            backgroundColor: AppColors.buttonPanel(ref),
            elevation: 3,
            padding: EdgeInsets.zero,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                vertical: 24.h,
                horizontal: 48.w,
              ),
              child: Text(
                searchResult.searchVal,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 72.sp,
                  color: isDarkMode
                      ? AppColors.nyoomYellow(ref)
                      : AppColors.nyoomDarkYellow,
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class YourLocationButton extends StatelessWidget {
  final WidgetRef ref;
  const YourLocationButton({super.key, required this.ref});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(settingsProvider).isDarkMode;
    return Center(
      child: SizedBox(
        width: 1120.w,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(150.r),
            ),
            backgroundColor: AppColors.buttonPanel(ref),
            elevation: 3,
            padding: EdgeInsets.zero,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 36.h),
              child: Row(
                spacing: 20.w,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 72.sp,
                    color: AppColors.primary(ref),
                  ),
                  Text(
                    "Your Location",
                    style: TextStyle(
                      fontSize: 72.sp,
                      color: AppColors.primary(ref),
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
