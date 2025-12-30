import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/app_state.dart';
import 'package:nyoom/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyoom/classes/colors.dart';
import 'package:nyoom/pages/misc/auth.dart';
import 'package:nyoom/pages/settings/feedback.dart';
import 'package:nyoom/test.dart';
import 'package:nyoom/widgets/circle_button.dart';
import 'package:nyoom/widgets/wide_button.dart';

class Settings extends ConsumerStatefulWidget implements PageSettings {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _BookmarksState();

  @override
  String? get pageTitle => "Settings";
  @override
  bool get noNavBar => false;
}

class _BookmarksState extends ConsumerState<Settings> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 40.h,
      children: [
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 40.w,
          children: [
            CircleButton(
              color: AppColors.errorRed,
              text: "Alerts",
              icon: Icons.notifications,
              ref: ref,
              onPressed: () async {
              },
            ),
            CircleButton(
              color: AppColors.nyoomGreen,
              text: "MRT Map",
              icon: Icons.train,
              ref: ref,
              onPressed: () {},
            ),
            CircleButton(
              color: AppColors.nyoomYellow(ref),
              text: "Feedback",
              icon: Icons.feedback,
              ref: ref,
              onPressed: () {
                ref.read(navigationProvider)?.call(NyoomFeedback());
              },
            ),
          ],
        ),
        SizedBox(height: 20.h),
        WideButton(
          color: AppColors.buttonPanel(ref),
          textColor: AppColors.primary(ref),
          text: 'Toggle Theme',
          onPressed: () {
            ref.read(settingsProvider.notifier).toggleDarkMode();
          },
        ),
        WideButton(
          color: AppColors.errorRed,
          textColor: AppColors.primary(ref),
          text: 'Clear All Data',
          onPressed: () {
            ref.read(settingsProvider.notifier).toggleDarkMode();
          },
        ),
        WideButton(
          color: AppColors.nyoomBlue,
          textColor: AppColors.primary(ref),
          // ignore: dead_code for now
          text: true ? 'Sign In' : 'Sign Out',
          onPressed: () {
            ref.read(appDataProvider.notifier).setGuestMode(null);
            if (true) {
              ref.read(navigationProvider)?.call(Auth());
            // ignore: dead_code
            } else {
              ref.read(navigationProvider)?.call(Auth());
            }
          },
        ),
            FloatingActionButton(
              onPressed: () async {
                testFunction(ref);
              },
              child: Text("a nice test button"),
            ),
      ],
    );
  }
}

