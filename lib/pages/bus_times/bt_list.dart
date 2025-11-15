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

  const BTList({super.key, required this.searchResult});

  @override
  ConsumerState<BTList> createState() => _BTListState();
}

class _BTListState extends ConsumerState<BTList> {
  late BTSearchResult searchResult;

  @override
  void initState() {
    super.initState();
    searchResult = widget.searchResult;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    ref.read(navigationProvider)?.call(BusTimes());
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 120.sp,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  searchResult.header,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 72.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: searchResult.type == "busService"
                ? BusStopsList(
                    busService: BusService.fromSearchResult(searchResult),
                  )
                : BusServicesList(
                    busStop: BusStop.fromSearchResult(searchResult),
                  ),
          ),
        ],
      ),
    );
  }
}

class BusServicePanel extends StatelessWidget {
  final BTSearchResult searchResult;
  final WidgetRef ref;

  const BusServicePanel({
    super.key,
    required this.searchResult,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Text("Service Results");
  }
}

class BusStopPanel extends StatelessWidget {
  final BTSearchResult searchResult;
  final WidgetRef ref;

  const BusStopPanel({
    super.key,
    required this.searchResult,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Text("Stop Results");
  }
}
