import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'vehicle_model.g.dart';

@JsonSerializable()
class VehicleModel extends Equatable{
  final String type;
  final String make;
  final String model;
  final int year;
  final String color;


  @JsonKey(name: 'plate_number')
  final String plateNumber;

  const VehicleModel({
    required this.type,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.plateNumber,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);
  @override
  List<Object?> get props => [type, make, model, year, color, plateNumber];
}