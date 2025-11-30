import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyoom/main.dart';
import 'package:nyoom/pages/bookmarks/bookmarks.dart';
import 'package:nyoom/pages/misc/auth.dart';
import 'package:nyoom/providers/navigation_provider.dart';

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
    print("test1");
    init();
  }

  void init() {
    print("test2");
    ref.read(navigationProvider)?.call(Bookmarks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/nyoom_effect.gif',
            fit: BoxFit.cover, // fills the screen
          ),
          Column(children: [const Text("hi")]),
        ],
      ),
    );
  }
}
