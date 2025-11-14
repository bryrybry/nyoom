import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      for (var entry in data.entries) {
        if (entry.key == busStop.busStopCode) {
          for (String service in entry.value) {
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
        print("test4");
        print(services);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
      shrinkWrap: true, 
      physics: const NeverScrollableScrollPhysics(), // optional
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20.h,
        crossAxisSpacing: 20.w,
        childAspectRatio: 3,
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
    return SizedBox(
      width: double.infinity,
      height: 140.h,
      child: ElevatedButton(
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
          child: Text(
            widget.busServiceAT.busService, // show the actual service
            style: TextStyle(
              fontSize: 52.sp,
              color: AppColors.primary(ref),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
