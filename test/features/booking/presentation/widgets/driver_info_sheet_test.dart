import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:taxi_booking/features/booking/presentation/widgets/driver_info_sheet.dart';
import 'package:taxi_booking/features/booking/data/models/driver_model.dart';

void main() {
  testWidgets('DriverInfoSheet displays driver info', (WidgetTester tester) async {
    final driver = DriverModel(
      id: 'd1',
      name: 'Ahmed Hassan',
      phone: '+966501234567',
      photo: 'placeholder.jpg',
      rating: 4.8,
      totalTrips: 1243,
      vehicle: Vehicle(
        type: 'Economy',
        make: 'Toyota',
        model: 'Camry',
        year: 2022,
        color: 'White',
        plateNumber: 'ABC 1234',
      ),
      location: Location(latitude: 24.7136, longitude: 46.6753),
      isAvailable: true,
    );

    await tester.pumpWidget(MaterialApp(home: DriverInfoSheet(driver: driver)));

    expect(find.text('Ahmed Hassan'), findsOneWidget);
    expect(find.textContaining('Economy'), findsOneWidget);
    expect(find.textContaining('ABC 1234'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsWidgets); // rating stars
  });
}