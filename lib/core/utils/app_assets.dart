import 'package:flutter/material.dart';

class AppAssets {
  AppAssets._();

  static const String _basePath = 'assets/images/';

  // Resolution-aware example
  static String getProfileImage(String filename) =>
      '$_basePath$_resolutionPrefix/$filename';

  static String get _resolutionPrefix {
    final ratio = WidgetsBinding.instance.window.devicePixelRatio;
    return ratio >= 3 ? '3.0x' : ratio >= 2 ? '2.0x' : '1.0x';
  }
}
