
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/app_state.dart';
import 'package:nyoom/classes/colors.dart';

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
    final isDarkMode = ref.watch(settingsProvider).isDarkMode;
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