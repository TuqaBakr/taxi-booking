import 'package:dartz/dartz.dart';
import 'package:taxi_booking/features/booking/domain/booking_repository.dart';

import '../../../../core/domain/error_handler/failures.dart';
import '../../data/models/booking_response_model.dart';

class FetchInitialDataUseCase{
  final BookingRepository repository;

  FetchInitialDataUseCase(this.repository);

  Future<Either<Failure, BookingResponseModel>> call() {
    return repository.fetchInitialData();
  }


}