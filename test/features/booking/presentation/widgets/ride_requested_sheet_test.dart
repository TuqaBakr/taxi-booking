import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:taxi_booking/features/booking/presentation/widgets/ride_requested_sheet.dart';

void main() {
  testWidgets('RideRequestedSheet displays fare and spinner', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: RideRequestedSheet(estimatedFare: 25.0),
    ));

    expect(find.text('Searching for a driver...'), findsOneWidget);
    expect(find.text('Estimated Fare: 25.0 SAR'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.textContaining('Hang tight'), findsOneWidget);
  });
}