import 'package:equatable/equatable.dart';

import '../../data/models/driver_model.dart';
import '../../data/models/fare_rules_model.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

// Loading state (fetching drivers/fare rules)
class BookingLoading extends BookingState {}

// Loaded state (drivers + fare rules available)
class BookingLoaded extends BookingState {
  final List<DriverModel> drivers;
  final FareRulesModel fareRules;

  const BookingLoaded({required this.drivers, required this.fareRules});

  @override
  List<Object?> get props => [drivers, fareRules];
}


class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}


class RideRequested extends BookingState {
  final double estimatedFare;

  const RideRequested(this.estimatedFare);

  @override
  List<Object?> get props => [estimatedFare];
}


class DriverAccepted extends BookingState {
  final DriverModel driver;
  final int etaSeconds;

  const DriverAccepted({required this.driver, required this.etaSeconds});

  @override
  List<Object?> get props => [driver, etaSeconds];
}


class RideCancelled extends BookingState {}