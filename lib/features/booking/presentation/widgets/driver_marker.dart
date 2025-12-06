
import 'package:flutter/material.dart';

import '../../data/models/driver_model.dart';
import 'driver_info_sheet.dart';

class DriverMarker extends StatelessWidget {
  final DriverModel driver;
  const DriverMarker({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => DriverInfoSheet(driver: driver),
        );
      },
      child: const Icon(Icons.local_taxi, color: Colors.yellow, size: 30),
    );
  }
}