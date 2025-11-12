import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyoom/main.dart';

class Bookmarks extends ConsumerStatefulWidget implements HasPageTitle {
  const Bookmarks({super.key});

  @override
  ConsumerState<Bookmarks> createState() => _BookmarksState();
  
  @override
  String? get pageTitle => "Your Bookmarks";
}

class _BookmarksState extends ConsumerState<Bookmarks> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Bookmarks',
      ),
    );
  }
}
