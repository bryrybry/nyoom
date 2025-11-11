import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _BookmarksState();
}

class _BookmarksState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Settings',
      ),
    );
  }
}
