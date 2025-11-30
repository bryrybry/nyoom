import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/classes/colors.dart';

class WideButton extends StatelessWidget {
  final Color? color;
  final Color textColor;
  final String text;
  final VoidCallback? onPressed;

  const WideButton({
    super.key,
    this.color,
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
          backgroundColor: color ?? AppColors.transparent,
          elevation: color != null ? 3 : 0,
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
