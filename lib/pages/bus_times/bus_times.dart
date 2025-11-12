import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusTimes extends ConsumerStatefulWidget {
  const BusTimes({super.key});

  @override
  ConsumerState<BusTimes> createState() => _BookmarksState();
}

class _BookmarksState extends ConsumerState<BusTimes> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'BusTimes',
      ),
    );
  }
}
