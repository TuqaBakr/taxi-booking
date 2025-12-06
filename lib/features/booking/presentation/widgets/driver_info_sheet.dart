import 'package:flutter/material.dart';
import '../../data/models/driver_model.dart';

class DriverInfoSheet extends StatelessWidget {
  final DriverModel driver;
  const DriverInfoSheet({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Driver photo + name
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: driver.photo.startsWith('http')
                    ? NetworkImage(driver.photo)
                    : const AssetImage('assets/images/placeholder.jpg'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  driver.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Rating as stars
          Row(
            children: [
              _buildStarRating(driver.rating),
              const SizedBox(width: 8),
              Text(driver.rating.toStringAsFixed(1)),
            ],
          ),
          const SizedBox(height: 12),

          // Car details
          Row(
            children: [
              const Icon(Icons.directions_car, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "${driver.vehicle.type} • ${driver.vehicle.make} ${driver.vehicle.model} (${driver.vehicle.year})",
                  style: const TextStyle(fontSize: 14),
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
          const SizedBox(height: 16),

          // Action button
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // Could trigger ride request with this driver
            },
            icon: const Icon(Icons.local_taxi),
            label: const Text("Request Ride with this Driver"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;

    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.amber, size: 20);
        } else if (index == fullStars && halfStar) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 20);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 20);
        }
      }),
    );
  }
}