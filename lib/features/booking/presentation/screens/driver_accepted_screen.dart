import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/features/booking/data/models/driver_model.dart';

import '../../../../core/routing/app_router.dart';
import '../cubit/booking_cubit.dart';

class DriverAcceptedScreen extends StatefulWidget {
  final DriverModel driver;
  final int etaSeconds;

  const DriverAcceptedScreen({
    Key? key,
    required this.driver,
    required this.etaSeconds,
  }) : super(key: key);

  @override
  State<DriverAcceptedScreen> createState() => _DriverAcceptedScreenState();
}

class _DriverAcceptedScreenState extends State<DriverAcceptedScreen> {
  late int remainingSeconds;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.etaSeconds;

    // Start countdown
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final etaMinutes = (remainingSeconds / 60).ceil();

    return Scaffold(
      appBar: AppBar(title: const Text("Driver Accepted")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(widget.driver.photo),
            ),
            const SizedBox(height: 16),
            Text(widget.driver.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("${widget.driver.vehicle.make} ${widget.driver.vehicle.model} - ${widget.driver.vehicle.color}"),
            Text("Plate: ${widget.driver.vehicle.plateNumber}"),
            const SizedBox(height: 16),
            Text("ETA: $etaMinutes minutes (${remainingSeconds}s)"),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                context.read<BookingCubit>().cancelRide();
                context.go(AppRoutes.map);
              },
              icon: const Icon(Icons.cancel),
              label: const Text("Cancel Ride", style: TextStyle(fontSize: 16, color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}