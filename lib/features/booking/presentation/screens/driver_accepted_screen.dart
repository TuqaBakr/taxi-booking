import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_router.dart';
import '../../data/models/driver_model.dart';
import '../cubit/booking_cubit.dart';

class DriverAcceptedScreen extends StatefulWidget {
  final DriverModel driver;
  final int etaSeconds;

  const DriverAcceptedScreen({
    super.key,
    required this.driver,
    required this.etaSeconds,
  });

  @override
  State<DriverAcceptedScreen> createState() => _DriverAcceptedScreenState();
}

class _DriverAcceptedScreenState extends State<DriverAcceptedScreen> {
  late int _remainingSeconds;
  late final driver = widget.driver;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.etaSeconds;

    // Countdown timer
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
        return true;
      }
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_remainingSeconds ~/ 60);
    final seconds = (_remainingSeconds % 60);

    return Scaffold(
      appBar: AppBar(title: const Text("Driver Accepted")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Driver photo + name
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(driver.photo),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    driver.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Rating stars
            Row(
              children: [
                _buildStarRating(driver.rating),
                const SizedBox(width: 8),
                Text(driver.rating.toStringAsFixed(1)),
              ],
            ),
            const SizedBox(height: 16),

            // Car details
            Row(
              children: [
                const Icon(Icons.directions_car, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${driver.vehicle.type} • ${driver.vehicle.make} ${driver.vehicle.model} (${driver.vehicle.year})",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Plate number
            Row(
              children: [
                const Icon(Icons.confirmation_number, color: Colors.grey),
                const SizedBox(width: 8),
                Text(driver.vehicle.plateNumber),
              ],
            ),
            const SizedBox(height: 24),

            // ETA countdown
            Text(
              "Estimated Arrival: $minutes:${seconds.toString().padLeft(2, '0')}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
            const Spacer(),

            // Cancel button
            ElevatedButton.icon(
              onPressed: () {
                context.read<BookingCubit>().cancelRide();
                context.go(AppRoutes.map);
              },
              icon: const Icon(Icons.cancel),
              label: const Text("Cancel Ride"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;

    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.amber, size: 22);
        } else if (index == fullStars && halfStar) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 22);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 22);
        }
      }),
    );
  }
}