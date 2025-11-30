import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nyoom/app_state.dart';
import 'package:nyoom/classes/colors.dart';
import 'package:nyoom/main.dart';
import 'package:nyoom/pages/bookmarks/bookmarks.dart';
import 'package:nyoom/widgets/wide_button.dart';

class Auth extends ConsumerStatefulWidget implements PageSettings {
  const Auth({super.key});

  @override
  ConsumerState<Auth> createState() => _AuthState();

  @override
  bool get noNavBar => true;
  @override
  String? get pageTitle => null;
}

class _AuthState extends ConsumerState<Auth> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/slide1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 2000.h),
            Center(
              child: WideButton(
                color: AppColors.onPrimary(ref).withAlpha(255),
                textColor: AppColors.white,
                text: "Sign In",
                onPressed: () {
                  // handle tap
                },
              ),
            ),
            Center(
              child: WideButton(
                textColor: AppColors.onPrimary(ref),
                text: "Continue as Guest",
                onPressed: () {
                  ref.read(settingsProvider.notifier).setGuestMode(true);
                  ref.read(navigationProvider)?.call(Bookmarks());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
