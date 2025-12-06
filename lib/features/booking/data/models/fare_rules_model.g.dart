// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fare_rules_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FareRulesModel _$FareRulesModelFromJson(Map<String, dynamic> json) =>
    FareRulesModel(
      baseFare: (json['base_fare'] as num).toDouble(),
      perKmRate: (json['per_km_rate'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      perMinuteRate: (json['per_minute_rate'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      minimumFare: (json['minimum_fare'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      currency: json['currency'] as String,
    );

Map<String, dynamic> _$FareRulesModelToJson(FareRulesModel instance) =>
    <String, dynamic>{
      'base_fare': instance.baseFare,
      'per_km_rate': instance.perKmRate,
      'per_minute_rate': instance.perMinuteRate,
      'minimum_fare': instance.minimumFare,
      'currency': instance.currency,
    };
