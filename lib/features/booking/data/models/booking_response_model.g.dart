// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingResponseModel _$BookingResponseModelFromJson(
  Map<String, dynamic> json,
) => BookingResponseModel(
  drivers: (json['drivers'] as List<dynamic>)
      .map((e) => DriverModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  fareRules: FareRulesModel.fromJson(
    json['fare_rules'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$BookingResponseModelToJson(
  BookingResponseModel instance,
) => <String, dynamic>{
  'drivers': instance.drivers.map((e) => e.toJson()).toList(),
  'fare_rules': instance.fareRules.toJson(),
};
