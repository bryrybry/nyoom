import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nyoom/main.dart';

class TravelRoutes extends ConsumerStatefulWidget implements HasPageTitle {
  const TravelRoutes({super.key});

  @override
  ConsumerState<TravelRoutes> createState() => _BookmarksState();
  
  @override
  String? get pageTitle => "Find a Route";
}

class _BookmarksState extends ConsumerState<TravelRoutes> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'TravelRoutes',
      ),
    );
  }
}
