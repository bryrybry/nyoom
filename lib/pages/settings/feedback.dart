import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/app_state.dart';
import 'package:nyoom/classes/colors.dart';
import 'package:nyoom/classes/helper.dart';
import 'package:nyoom/pages/settings/settings.dart';
import 'package:nyoom/services/api_service.dart';
import 'package:nyoom/widgets/wide_button.dart';

class NyoomFeedback extends ConsumerStatefulWidget {
  const NyoomFeedback({super.key});

  @override
  ConsumerState<NyoomFeedback> createState() => _NyoomFeedbackState();
}

class _NyoomFeedbackState extends ConsumerState<NyoomFeedback> {
  String errorMessage = "";
  bool enableSubmit = false;
  bool autofillEmail = false;
  late final TextEditingController emailController;
  late final TextEditingController feedbackController;

  @override
  void initState() {
    super.initState();
    String email = ref.read(appDataProvider).email;
    if (email.isNotEmpty) {
      autofillEmail = true;
    }
    emailController = TextEditingController(text: email);
    feedbackController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    feedbackController.dispose();
    super.dispose();
  }

  void onTextFieldChanged(_) {
    setState(() {
      enableSubmit =
          emailController.text.trim().isNotEmpty &&
          feedbackController.text.trim().isNotEmpty;
    });
  }

  void clearEmail() {
    emailController.clear();
    ref.read(appDataProvider.notifier).setEmail("");
    setState(() {
      autofillEmail = false;
      enableSubmit = false;
    });
  }

  Future<void> onSubmit(context) async {
    final email = emailController.text.trim();
    final feedback = feedbackController.text.trim();

    if (!Helper.isValidEmail(email)) {
      setState(() => errorMessage = "Invalid email address.");
      return;
    }
    APIServiceResult result = await ApiService.sendTelegramFeedback(
      "From: $email\n$feedback",
    );
    setState(() {
      errorMessage = switch (result) {
        APIServiceResult.noInternet => "Please check your internet connection.",
        APIServiceResult.serverError =>
          "Unable to submit. Please try again later.",
        APIServiceResult.success => "",
      };
    });
    if (errorMessage.isEmpty) {
      ref.read(navigationProvider)?.call(Settings());
      ref.read(appDataProvider.notifier).setEmail(email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Thanks for the feedback!',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.nyoomBlue,
        ),
      );
    }
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
                    controller: emailController,
                    onChanged: onTextFieldChanged,
                    maxLines: 1,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(
                      fontSize: 56.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.primary(ref),
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.backgroundPanel(ref),
                      hintText: "Your email...",
                      hintStyle: TextStyle(fontSize: 56.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60.r),
                      ),
                      prefixIcon: Icon(Icons.email),
                      suffixIcon: emailController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close),
                              iconSize: 96.sp,
                              onPressed: clearEmail,
                            )
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: 1120.w,
                  child: TextField(
                    controller: feedbackController,
                    onChanged: onTextFieldChanged,
                    maxLines: 8,
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
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: TextStyle(
                      fontSize: 42.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.errorRed,
                    ),
                  ),
                SizedBox(height: 24.h),
                Center(
                  child: WideButton(
                    color: enableSubmit
                        ? AppColors.nyoomBlue
                        : AppColors.darkGray(ref),
                    textColor: AppColors.white.withAlpha(
                      enableSubmit ? 255 : 63,
                    ),
                    text: "Submit",
                    onPressed: () {
                      if (!enableSubmit) return;
                      onSubmit(context);
                    },
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
