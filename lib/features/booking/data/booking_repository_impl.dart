import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:taxi_booking/core/domain/services/remote_data_source.dart';
import '../../../core/domain/error_handler/failures.dart';
import '../../../core/domain/error_handler/network_exceptions.dart';
import '../../../core/domain/error_handler/repository_handler.dart';

import '../domain/booking_repository.dart';
import 'models/booking_response_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final RemoteDataSource remoteDataSource;

  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, BookingResponseModel>> fetchInitialData() async {
    try {
      // Fetch data from the remote source
      final response =
      await remoteDataSource.get(BookingRepository.initialDataPath);

      final json = response.body;

      if (json == null) {
        return const Left(
          ServerFailure(message: 'Empty response body.', statusCode: 500),
        );
      }

      // Deserialize into BookingResponseModel
      final bookingResponse = BookingResponseModel.fromJson(json);

      // Filter drivers by availability
      final availableDrivers =
      bookingResponse.drivers.where((d) => d.isAvailable).toList();

      // Return a new BookingResponseModel with filtered drivers
      final filteredResponse = BookingResponseModel(
        drivers: availableDrivers,
        fareRules: bookingResponse.fareRules,
      );

      return Right(filteredResponse);
    } on DioException catch (e) {
      final networkException = RepositoryHandler.getDioException(e);

      final failure = networkException.when(
        notImplemented: () =>
        const ServerFailure(message: "Not Implemented", statusCode: 501),
        requestCancelled: () =>
        const NetworkFailure(message: "Request Cancelled"),
        internalServerError: () =>
        const ServerFailure(message: "Internal Server Error", statusCode: 500),
        notFound: () => const ServerFailure(message: "Not Found", statusCode: 404),
        serviceUnavailable: () =>
        const ServerFailure(message: "Service Unavailable", statusCode: 503),
        methodNotAllowed: () =>
        const ServerFailure(message: "Method Not Allowed", statusCode: 405),
        badRequest: (error, errors) =>
            ValidationFailure(message: error, statusCode: 400),
        unauthorizedRequest: (error) =>
            ValidationFailure(message: error, statusCode: 401),
        unprocessableEntity: (error, errors) =>
            ValidationFailure(message: error, statusCode: 422),
        requestTimeout: () =>
        const NetworkFailure(message: "Request Timeout"),
        sendTimeout: () => const NetworkFailure(message: "Send Timeout"),
        noInternetConnection: () =>
        const NetworkFailure(message: "No Internet Connection"),
        defaultError: (error) =>
            ServerFailure(message: error, statusCode: 0),
        unexpectedError: (error) =>
            ServerFailure(message: error, statusCode: 0),
        loggingInRequired: () =>
        const ValidationFailure(message: "Login Required", statusCode: 401),
        conflict: () =>
        const ServerFailure(message: 'Conflict', statusCode: 409),
        formatException: () =>
        const LocalFailure(message: 'Data Format Exception'),
        unableToProcess: () =>
        const LocalFailure(message: 'Unable to Process Data'),
        notAcceptable: () =>
        const ServerFailure(message: 'Not Acceptable', statusCode: 406),
        tooManyRequest: () =>
        const ServerFailure(message: 'Too Many Requests', statusCode: 429),
      );

      return Left(failure);
    } catch (e) {
      return Left(
        LocalFailure(message: 'An unexpected error occurred: ${e.toString()}'),
      );
    }
  }
}