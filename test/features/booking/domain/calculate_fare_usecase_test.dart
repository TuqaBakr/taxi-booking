import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_booking/features/booking/data/models/fare_rules_model.dart';
import 'package:taxi_booking/features/booking/domain/use_cases/calculate_fare_use_case.dart';

void main() {
  late CalculateFareUseCase useCase;
  late FareRulesModel fareRules;

  setUp(() {
    useCase = CalculateFareUseCase();
    fareRules = FareRulesModel(
      baseFare: 5.0,
      perKmRate: {
        "Economy": 2.0,
        "Comfort": 3.0,
        "Premium": 5.0,
      },
      perMinuteRate: {
        "Economy": 0.5,
        "Comfort": 0.75,
        "Premium": 1.0,
      },
      minimumFare: {
        "Economy": 10.0,
        "Comfort": 15.0,
        "Premium": 25.0,
      },
      currency: "SAR",
    );
  });

  group('CalculateFareUseCase', () {
    test('should calculate fare for Economy correctly', () {
      final fare = useCase(
        distanceKm: 3.0,
        vehicleType: "Economy",
        fareRules: fareRules,
      );
      // baseFare (5) + distance * perKmRate (3 * 2 = 6) = 11
      expect(fare, equals(11.0));
    });

    test('should apply minimum fare for Economy when distance is too short', () {
      final fare = useCase(
        distanceKm: 1.0,
        vehicleType: "Economy",
        fareRules: fareRules,
      );
      // baseFare (5) + distance * perKmRate (1 * 2 = 2) = 7 < minimumFare (10)
      expect(fare, equals(10.0));
    });

    test('should calculate fare for Comfort correctly', () {
      final fare = useCase(
        distanceKm: 4.0,
        vehicleType: "Comfort",
        fareRules: fareRules,
      );
      // baseFare (5) + distance * perKmRate (4 * 3 = 12) = 17
      expect(fare, equals(17.0));
    });

    test('should apply minimum fare for Comfort when distance is too short', () {
      final fare = useCase(
        distanceKm: 2.0,
        vehicleType: "Comfort",
        fareRules: fareRules,
      );
      // baseFare (5) + distance * perKmRate (2 * 3 = 6) = 11 < minimumFare (15)
      expect(fare, equals(15.0));
    });

    test('should calculate fare for Premium correctly', () {
      final fare = useCase(
        distanceKm: 5.0,
        vehicleType: "Premium",
        fareRules: fareRules,
      );
      // baseFare (5) + distance * perKmRate (5 * 5 = 25) = 30
      expect(fare, equals(30.0));
    });

    test('should apply minimum fare for Premium when distance is too short', () {
      final fare = useCase(
        distanceKm: 2.0,
        vehicleType: "Premium",
        fareRules: fareRules,
      );
      // baseFare (5) + distance * perKmRate (2 * 5 = 10) = 15 < minimumFare (25)
      expect(fare, equals(25.0));
    });
  });
}