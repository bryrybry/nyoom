import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/app_state.dart';
import 'package:nyoom/classes/colors.dart';
import 'package:nyoom/pages/settings/settings.dart';
import 'package:nyoom/services/api_service.dart';
import 'package:nyoom/widgets/wide_button.dart';

class NyoomFeedback extends ConsumerStatefulWidget {
  const NyoomFeedback({super.key});

  @override
  ConsumerState<NyoomFeedback> createState() => _NyoomFeedbackState();
}

class _NyoomFeedbackState extends ConsumerState<NyoomFeedback> {
  String feedbackContent = "";
  @override
  void initState() {
    super.initState();
  }

  void onFeedbackContentChanged(String value) {
    feedbackContent = value;
  }

  void onSubmit() {
    String from = "Unknown User";
    if (ref.read(appDataProvider).isGuestMode == false) {
      from = ref.read(appDataProvider).email;
    }
    ApiService.sendTelegramFeedback("From: $from\n\n$feedbackContent");
    ref.read(navigationProvider)?.call(Settings());
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
                    ref.read(navigationProvider)?.call(Settings());
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 120.sp,
                    color: AppColors.white,
                  ),
                ),
                Center(
                  child: Text(
                    "Settings",
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
            child: Column(
              spacing: 24.h,
              children: [
                SizedBox(height: 48.h),
                Icon(
                  Icons.announcement,
                  size: 256.sp,
                  color: AppColors.nyoomYellow(ref),
                ),
                Text(
                  "Feedback",
                  style: TextStyle(
                    color: AppColors.nyoomYellow(ref),
                    fontSize: 72.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  "Any bugs? Any issues?\nLet us know!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.nyoomGreen,
                    fontSize: 72.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 48.h),
                SizedBox(
                  width: 1120.w,
                  child: TextField(
                    onChanged: onFeedbackContentChanged,
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(
                      fontSize: 56.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primary(ref),
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.backgroundPanel(ref),
                      hintText: "Type here...",
                      hintStyle: TextStyle(fontSize: 56.sp),
                      // hintText: '900, 901A, Dover Stn Exit A...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                if (false)
                  Text(
                    "",
                    style: TextStyle(
                      fontSize: 42.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.errorRed,
                    ),
                  ),
                SizedBox(height: 24.h),
                Center(
                  child: WideButton(
                    color: AppColors.nyoomBlue,
                    textColor: AppColors.white,
                    text: "Submit",
                    onPressed: onSubmit,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
