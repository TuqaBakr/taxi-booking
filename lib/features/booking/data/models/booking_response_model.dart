import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

import 'driver_model.dart';
import 'fare_rules_model.dart';

part 'booking_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BookingResponseModel extends Equatable {
  final List<DriverModel> drivers;

  @JsonKey(name: 'fare_rules')
  final FareRulesModel fareRules;

  const BookingResponseModel({
    required this.drivers,
    required this.fareRules,
  });

  factory BookingResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BookingResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingResponseModelToJson(this);

  @override
  List<Object?> get props => [drivers, fareRules];
}