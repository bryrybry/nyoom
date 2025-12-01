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

enum AuthPageState { main, login, register }

class _AuthState extends ConsumerState<Auth> {
  AuthPageState authPageState = AuthPageState.main;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/${authPageState == AuthPageState.main ? "slide1" : "slide1blurdark"}.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Always visible
            Positioned(
              left: 0,
              right: 0,
              bottom: 200.h,
              child: Center(
                child: WideButton(
                  textColor: (authPageState == AuthPageState.main)
                      ? AppColors.black
                      : AppColors.primary(ref),
                  text: "Continue as Guest",
                  onPressed: () {
                    ref.read(appDataProvider.notifier).setGuestMode(true);
                    ref.read(navigationProvider)?.call(Bookmarks());
                  },
                ),
              ),
            ),
            // Main State
            if (authPageState == AuthPageState.main)
              Positioned(
                left: 0,
                right: 0,
                bottom: 400.h,
                child: Center(
                  child: WideButton(
                    color: AppColors.onPrimary(ref).withAlpha(255),
                    textColor: AppColors.white,
                    text: "Sign In",
                    onPressed: () {
                      setState(() {
                        authPageState = AuthPageState.login;
                      });
                    },
                  ),
                ),
              ),
            // Login/Register State
            if (authPageState != AuthPageState.main) ...[
              Positioned(
                left: 0,
                right: 0,
                top: 250.h,
                child: Center(
                  child: SizedBox(
                    width: 800.w,
                    child: Image.asset('assets/images/nyoomtextglow.png'),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 800.h,
                child: Column(
                  spacing: 60.h,
                  children: [
                    if (authPageState == AuthPageState.register)
                      InputField(header: "username"),
                    InputField(header: "email"),
                    InputField(header: "password"),
                    Text(
                      "",
                      style: TextStyle(
                        fontSize: 42.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.errorRed,
                      ),
                    ),
                    Center(
                      child: WideButton(
                        color: AppColors.nyoomBlue,
                        textColor: AppColors.white,
                        text: (authPageState == AuthPageState.register)
                            ? "Login"
                            : "Register",
                        onPressed: () {
                          setState(() {
                            authPageState = AuthPageState.login;
                          });
                        },
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          (authPageState == AuthPageState.register)
                              ? "Already have an account?"
                              : "Don't have an account?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 42.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary(ref),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              authPageState =
                                  (authPageState == AuthPageState.register)
                                  ? AuthPageState.login
                                  : AuthPageState.register;
                            });
                          },
                          child: Text(
                            (authPageState == AuthPageState.register)
                                ? "Sign in"
                                : "Sign up",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 42.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.nyoomYellow(ref),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class InputField extends ConsumerWidget {
  final String header;
  const InputField({super.key, required this.header});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 1050.w,
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
      decoration: BoxDecoration(
        color: AppColors.onPrimary(ref).withAlpha(191),
        borderRadius: BorderRadius.circular(60.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header.toUpperCase(),
            style: TextStyle(
              fontSize: 42.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.hintGray(ref),
            ),
          ),
          SizedBox(height: 20.h),
          TextField(
            style: TextStyle(
              fontSize: 56.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.primary(ref),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
