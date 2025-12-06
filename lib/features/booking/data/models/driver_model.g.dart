// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverModel _$DriverModelFromJson(Map<String, dynamic> json) => DriverModel(
  id: json['id'] as String,
  name: json['name'] as String,
  phone: json['phone'] as String,
  photo: json['photo'] as String,
  rating: (json['rating'] as num).toDouble(),
  totalTrips: (json['total_trips'] as num).toInt(),
  vehicle: Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>),
  location: Location.fromJson(json['location'] as Map<String, dynamic>),
  isAvailable: json['is_available'] as bool,
);

Map<String, dynamic> _$DriverModelToJson(DriverModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'photo': instance.photo,
      'rating': instance.rating,
      'total_trips': instance.totalTrips,
      'vehicle': instance.vehicle.toJson(),
      'location': instance.location.toJson(),
      'is_available': instance.isAvailable,
    };

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle(
  type: json['type'] as String,
  make: json['make'] as String,
  model: json['model'] as String,
  year: (json['year'] as num).toInt(),
  color: json['color'] as String,
  plateNumber: json['plate_number'] as String,
);

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
  'type': instance.type,
  'make': instance.make,
  'model': instance.model,
  'year': instance.year,
  'color': instance.color,
  'plate_number': instance.plateNumber,
};

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
);

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};
