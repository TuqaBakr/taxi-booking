import '../../data/models/fare_rules_model.dart';

class CalculateFareUseCase {
  double call({
    required double distanceKm,
    required String vehicleType,
    required FareRulesModel fareRules,
  }) {
    final baseFare = fareRules.baseFare;
    final perKmRate = fareRules.perKmRate[vehicleType] ?? 0.0;
    final minimumFare = fareRules.minimumFare[vehicleType] ?? 0.0;

    final fare = baseFare + (distanceKm * perKmRate);
    return fare < minimumFare ? minimumFare : fare;
  }
}