import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/app_state.dart';
import 'package:nyoom/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyoom/classes/colors.dart';
import 'package:nyoom/test.dart';

class Settings extends ConsumerStatefulWidget implements HasPageTitle {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _BookmarksState();

  @override
  String? get pageTitle => "Settings";
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
              onPressed: () {},
            ),
          ],
        ),
        SizedBox(height: 20.h),
        WideButton(
          color: AppColors.buttonPanel(ref),
          textColor: AppColors.primary(ref),
          text: 'Toggle Theme',
          onPressed: () {
            ref.read(isDarkModeProvider.notifier).toggleTheme();
          },
        ),
        WideButton(
          color: AppColors.errorRed,
          textColor: AppColors.primary(ref),
          text: 'Clear All Data',
          onPressed: () {
            ref.read(isDarkModeProvider.notifier).toggleTheme();
          },
        ),
        WideButton(
          color: AppColors.nyoomBlue,
          textColor: AppColors.primary(ref),
          // ignore: dead_code for now
          text: true ? 'Sign In' : 'Sign Out',
          onPressed: () {
            ref.read(isDarkModeProvider.notifier).toggleTheme();
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

class CircleButton extends StatelessWidget {
  final Color color;
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;
  final WidgetRef ref;

  const CircleButton({
    super.key,
    required this.color,
    required this.text,
    required this.icon,
    this.onPressed,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    return SizedBox(
      width: 320.w,
      height: 320.w,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: isDarkMode ? AppColors.buttonPanel(ref) : color,
          elevation: 3,
          padding: EdgeInsets.zero,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 150.sp,
              color: isDarkMode ? color : AppColors.white,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 45.sp,
                color: isDarkMode ? color : AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WideButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;
  final VoidCallback? onPressed;

  const WideButton({
    super.key,
    required this.color,
    required this.textColor,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 820.w,
      height: 180.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80.r),
          ),
          backgroundColor: color,
          elevation: 3,
          padding: EdgeInsets.zero,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 64.sp,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
