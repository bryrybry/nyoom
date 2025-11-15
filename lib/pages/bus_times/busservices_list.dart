import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/app_state.dart';
import 'package:nyoom/classes/colors.dart';
import 'package:nyoom/classes/data_models/bus_service.dart';
import 'package:nyoom/classes/data_models/bus_stop.dart';
import 'package:nyoom/classes/static_data.dart';

class BusServicesList extends ConsumerStatefulWidget {
  final BusStop busStop;

  const BusServicesList({super.key, required this.busStop});

  @override
  ConsumerState<BusServicesList> createState() => _BusServicesListState();
}

class _BusServicesListState extends ConsumerState<BusServicesList> {
  late BusStop busStop;
  final List<BusServiceAT> services = [];

  @override
  void initState() {
    super.initState();
    busStop = widget.busStop;
    generateList();
  }

  void generateList() {
    StaticData.busServicesAtStop().then((data) {
      List<BusServiceAT> tempServices = [];
      for (var stop in data.entries) {
        if (stop.key == busStop.busStopCode) {
          for (String service in stop.value) {
            tempServices.add(
              BusServiceAT(busService: service, arrivalTimes: [" ", " ", " "]),
            );
          }
          break;
        }
      }
      setState(() {
        services.clear();
        services.addAll(tempServices);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20.h,
        crossAxisSpacing: 20.w,
        childAspectRatio: 1,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return BusServicePanel(busServiceAT: services[index]);
      },
    );
  }
}

class BusServicePanel extends ConsumerStatefulWidget {
  final BusServiceAT busServiceAT;

  const BusServicePanel({super.key, required this.busServiceAT});

  @override
  ConsumerState<BusServicePanel> createState() => _BusServicePanelState();
}

class _BusServicePanelState extends ConsumerState<BusServicePanel> {
  late BusServiceAT busServiceAT;
  @override
  void initState() {
    super.initState();
    busServiceAT = widget.busServiceAT;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(80.r),
        ),
        backgroundColor: AppColors.buttonPanel(ref),
        elevation: 3,
        padding: EdgeInsets.zero,
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              "Bus",
              style: TextStyle(
                fontSize: 52.sp,
                color: AppColors.hintGray(ref),
                fontWeight: FontWeight.w400,
                height: 1.8,
              ),
            ),
            Text(
              busServiceAT.busService,
              style: TextStyle(
                fontSize: 192.sp,
                color: ref.watch(isDarkModeProvider)
                    ? AppColors.nyoomYellow(ref)
                    : AppColors.primary(ref),
                fontWeight: FontWeight.w800,
                height: 1.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
              child: SizedBox(
                height: 5.h,
                width: double.infinity,
                child: Container(color: AppColors.darkGray(ref)),
              ),
            ),
            Text(
              "Arriving in:",
              style: TextStyle(
                fontSize: 42.sp,
                color: AppColors.hintGray(ref),
                fontWeight: FontWeight.w600,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
