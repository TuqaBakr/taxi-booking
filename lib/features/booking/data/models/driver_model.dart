import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'driver_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DriverModel extends Equatable {
  final String id;
  final String name;
  final String phone;
  final String photo;
  final double rating;

  @JsonKey(name: 'total_trips')
  final int totalTrips;

  final Vehicle vehicle;
  final Location location;

  @JsonKey(name: 'is_available')
  final bool isAvailable;

  const DriverModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.photo,
    required this.rating,
    required this.totalTrips,
    required this.vehicle,
    required this.location,
    required this.isAvailable,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) =>
      _$DriverModelFromJson(json);

  Map<String, dynamic> toJson() => _$DriverModelToJson(this);

  @override
  List<Object?> get props =>
      [id, name, phone, photo, rating, totalTrips, vehicle, location, isAvailable];
}

@JsonSerializable()
class Vehicle extends Equatable {
  final String type;
  final String make;
  final String model;
  final int year;
  final String color;

  @JsonKey(name: 'plate_number')
  final String plateNumber;

  const Vehicle({
    required this.type,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.plateNumber,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) =>
      _$VehicleFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleToJson(this);

  @override
  List<Object?> get props => [type, make, model, year, color, plateNumber];
}

@JsonSerializable()
class Location extends Equatable {
  final double latitude;
  final double longitude;

  const Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  @override
  List<Object?> get props => [latitude, longitude];
}