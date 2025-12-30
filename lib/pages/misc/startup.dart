import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyoom/app_state.dart';
import 'package:nyoom/classes/colors.dart';
import 'package:nyoom/main.dart';
import 'package:nyoom/pages/bookmarks/bookmarks.dart';
import 'package:nyoom/pages/misc/auth.dart';

class Startup extends ConsumerStatefulWidget implements PageSettings {
  const Startup({super.key});

  @override
  ConsumerState<Startup> createState() => _StartupState();

  @override
  bool get noNavBar => true;
  @override
  String? get pageTitle => null;
}

class _StartupState extends ConsumerState<Startup> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await init();
    });
  }

  Future<void> init() async {
    await Future.delayed(const Duration(milliseconds: 500));
    bool? isGuestMode = ref.read(appDataProvider).isGuestMode;
    ref
        .read(navigationProvider)
        ?.call((isGuestMode == null) ? Auth() : Bookmarks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: AppColors.black),
          Image.asset(
            'assets/images/nyoom_effect.gif',
            fit: BoxFit.cover, // fills the screen
          ),
          Center(child: Image.asset('assets/images/nyoom.png')),
        ],
      ),
    );
  }
}
