import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/app_state.dart';
import 'package:nyoom/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyoom/themes/colors.dart';

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
        Row(
          children: [
            FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ],
        ),
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
      ],
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
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 820.w,
        height: 180.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(80.r),
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
