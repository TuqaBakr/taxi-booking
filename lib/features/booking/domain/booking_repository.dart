import 'package:dartz/dartz.dart';

import '../../../core/domain/error_handler/failures.dart';
import '../data/models/booking_response_model.dart';
import '../data/models/fare_rules_model.dart';

abstract class BookingRepository {
  // Path for fetching initial data from the mock API (Bin ID)
  // This constant is used by both the implementation and the test.
  static const initialDataPath = 'https://api.npoint.io/f852c2acc472148688b1';

  /// Fetches initial data, including available drivers and fare rules.
  ///
  /// Returns [Right] with [Tuple2] of [List<DriverModel>] and [FareRulesModel] on success.
  /// Returns [Left] with a [Failure] on error (Network, Server, or Local).
  Future<Either<Failure, BookingResponseModel>> fetchInitialData();
}