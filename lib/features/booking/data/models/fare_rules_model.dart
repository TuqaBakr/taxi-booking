import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'fare_rules_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FareRulesModel extends Equatable {
  @JsonKey(name: 'base_fare')
  final double baseFare;

  @JsonKey(name: 'per_km_rate')
  final Map<String, double> perKmRate;

  @JsonKey(name: 'per_minute_rate')
  final Map<String, double> perMinuteRate;

  @JsonKey(name: 'minimum_fare')
  final Map<String, double> minimumFare;

  final String currency;

  const FareRulesModel({
    required this.baseFare,
    required this.perKmRate,
    required this.perMinuteRate,
    required this.minimumFare,
    required this.currency,
  });

  factory FareRulesModel.fromJson(Map<String, dynamic> json) =>
      _$FareRulesModelFromJson(json);

  Map<String, dynamic> toJson() => _$FareRulesModelToJson(this);

  @override
  List<Object?> get props =>
      [baseFare, perKmRate, perMinuteRate, minimumFare, currency];
}