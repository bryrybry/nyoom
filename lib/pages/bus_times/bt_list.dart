import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/app_state.dart';
import 'package:nyoom/classes/colors.dart';
import 'package:nyoom/classes/data_models/bus_service.dart';
import 'package:nyoom/classes/data_models/bus_stop.dart';
import 'package:nyoom/classes/data_models/bus_times_search_result.dart';
import 'package:nyoom/pages/bus_times/bus_times.dart';
import 'package:nyoom/pages/bus_times/busservices_list.dart';
import 'package:nyoom/pages/bus_times/busstops_list.dart';

class BTList extends ConsumerStatefulWidget {
  final BTSearchResult searchResult;
  final List<BTSearchResult> searchHistoryList;

  const BTList({
    super.key,
    required this.searchResult,
    required this.searchHistoryList,
  });

  @override
  ConsumerState<BTList> createState() => _BTListState();
}

class _BTListState extends ConsumerState<BTList> {
  late BTSearchResult searchResult;
  late List<BTSearchResult> searchHistoryList;

  @override
  void initState() {
    super.initState();
    searchResult = widget.searchResult;
    searchHistoryList = widget.searchHistoryList;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    if (searchHistoryList.isEmpty) {
                      ref.read(navigationProvider)?.call(BusTimes());
                      return;
                    }
                    ref
                        .read(navigationProvider)
                        ?.call(
                          BTList(
                            key: ValueKey(searchHistoryList.last.header),
                            searchResult: searchHistoryList.last,
                            searchHistoryList: searchHistoryList.sublist(
                              0,
                              searchHistoryList.length - 1,
                            ),
                          ),
                        );
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 120.sp,
                    color: AppColors.white,
                  ),
                ),
                Center(
                  child: Text(
                    "${searchResult.type == "busService" ? "Bus " : ""}${searchResult.header}",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 72.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          Expanded(
            child: searchResult.type == "busService"
                ? BusStopsList(
                    busService: BusService.fromSearchResult(searchResult),
                    searchHistoryList: searchHistoryList,
                  )
                : BusServicesList(
                    busStop: BusStop.fromSearchResult(searchResult),
                    searchHistoryList: searchHistoryList,
                  ),
          ),
        ],
      ),
    );
  }
}
