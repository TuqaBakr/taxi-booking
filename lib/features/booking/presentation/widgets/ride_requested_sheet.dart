import 'package:flutter/material.dart';

class RideRequestedSheet extends StatelessWidget {
  final double estimatedFare;
  const RideRequestedSheet({super.key, required this.estimatedFare});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.local_taxi, color: Colors.blue, size: 28),
              SizedBox(width: 8),
              Text(
                "Searching for a driver...",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Fare info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.attach_money, color: Colors.green),
              const SizedBox(width: 6),
              Text(
                "Estimated Fare: $estimatedFare SAR",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),


          Column(
            children: const [
              CircularProgressIndicator(color: Colors.blue),
              SizedBox(height: 12),
              Text(
                "Hang tight! We're finding the best driver for you...",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}