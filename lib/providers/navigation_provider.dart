import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationProvider =
    NotifierProvider<NavigationNotifier, void Function(Widget)?>(
      () => NavigationNotifier(),
    );

class NavigationNotifier extends Notifier<void Function(Widget)?> {
  @override
  void Function(Widget)? build() => null;

  void setCallback(void Function(Widget) callback) {
    state = callback;
  }
}
