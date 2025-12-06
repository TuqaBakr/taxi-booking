import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/driver_model.dart';
import '../../data/models/fare_rules_model.dart';
import '../../domain/booking_repository.dart';
import '../../domain/use_cases/calculate_fare_use_case.dart';
import 'booking_state.dart';


class BookingCubit extends Cubit<BookingState> {
  final BookingRepository repository;
  final CalculateFareUseCase calculateFare;

  BookingCubit({required this.repository, required this.calculateFare})
      : super(BookingInitial());

  Future<void> fetchInitialData() async {
    emit(BookingLoading());
    final result = await repository.fetchInitialData();
    result.fold(
          (failure) => emit(BookingError(failure.message)),
          (response) => emit(BookingLoaded(
        drivers: response.drivers,
        fareRules: response.fareRules,
      )),
    );
  }

  void requestRide({
    required double distanceKm,
    required String vehicleType,
    required FareRulesModel fareRules,
    required List<DriverModel> drivers,
    required double estimatedFare,
  }) async{
    final fare = calculateFare(
      distanceKm: distanceKm,
      vehicleType: vehicleType,
      fareRules: fareRules,
    );
    emit(RideRequested(fare));
    // Simulate 2-second delay
   await Future.delayed(Duration(seconds:3));
    final driver = drivers.first;
    await acceptDriver(driver, 300);
  }

  Future<void> acceptDriver(DriverModel driver, int etaSeconds) async {
    debugPrint('11111111111111111111Driver accepted!');
    emit(DriverAccepted(driver: driver, etaSeconds: etaSeconds)); // e.g., 5 min ETA
  }

  void cancelRide() {
    emit(RideCancelled());
  }
}