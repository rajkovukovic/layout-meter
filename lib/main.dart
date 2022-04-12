import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'device_info.dart';

void main() {
  runZonedGuarded(() {
    runApp(const LayoutMeter());
  }, (dynamic error, dynamic stack) {
    developer.log("Something went wrong!", error: error, stackTrace: stack);
  });
}

class LayoutMeter extends StatelessWidget {
  const LayoutMeter({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Layout Meter',
      home: DeviceInfo(),
    );
  }
}
