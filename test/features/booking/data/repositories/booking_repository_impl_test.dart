import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Core imports
import 'package:taxi_booking/core/data/models/base_response_model.dart';
import 'package:taxi_booking/core/domain/error_handler/failures.dart';

// Feature imports
import 'package:taxi_booking/features/booking/data/booking_repository_impl.dart';
import 'package:taxi_booking/features/booking/data/models/booking_response_model.dart';
import 'package:taxi_booking/features/booking/domain/booking_repository.dart';
import 'package:taxi_booking/features/booking/data/models/driver_model.dart';
import 'package:taxi_booking/features/booking/data/models/fare_rules_model.dart';

// Test Utilities
import '../../../../core/data/sources/mock_remote_data_source.mocks.dart' as M;
import '../../../../fixtures/fixture_reader.dart';

void main() {
  late M.MockRemoteDataSource mockRemoteDataSource;
  late BookingRepositoryImpl repository;

  // Load fixture JSON
  final tInitialDataJson =
  json.decode(fixture('initial_data.json')) as Map<String, dynamic>;
  const tPath = BookingRepository.initialDataPath;

  // Mock BaseResponseModel
  final tBaseResponse =
  BaseResponseModel(body: tInitialDataJson, headers: const {});

  // Expected BookingResponseModel
  final tDriverModels = (tInitialDataJson['drivers'] as List)
      .map((e) => DriverModel.fromJson(e))
      .where((driver) => driver.isAvailable)
      .toList();

  final tFareRulesModel =
  FareRulesModel.fromJson(tInitialDataJson['fare_rules']);

  final BookingResponseModel tSuccessResponse =
  BookingResponseModel(drivers: tDriverModels, fareRules: tFareRulesModel);

  setUp(() {
    mockRemoteDataSource = M.MockRemoteDataSource();
    repository = BookingRepositoryImpl(remoteDataSource: mockRemoteDataSource);
    reset(mockRemoteDataSource);
  });

  group('fetchInitialData', () {
    test(
      'should return BookingResponseModel (Right) and filter out unavailable drivers when successful',
          () async {
        // ARRANGE
        when(mockRemoteDataSource.get(
          tPath,
          queryParams: anyNamed('queryParams'),
          cancelToken: anyNamed('cancelToken'),
        )).thenAnswer((_) async => tBaseResponse);

        // ACT
        final result = await repository.fetchInitialData();

        // ASSERT
        verify(mockRemoteDataSource.get(
          tPath,
          queryParams: anyNamed('queryParams'),
          cancelToken: anyNamed('cancelToken'),
        ));

        result.fold(
              (l) => fail('Expected Right but got Left: $l'),
              (r) {
            // Compare full object equality
            expect(r, equals(tSuccessResponse));

            // Dynamically calculate expected available drivers count from fixture
            final expectedAvailableCount = (tInitialDataJson['drivers'] as List)
                .where((d) => d['is_available'] == true)
                .length;

            expect(r.drivers.length, equals(expectedAvailableCount));

            // Nested field checks for first driver
            final firstDriver = r.drivers.first;
            expect(firstDriver.vehicle.type, equals("Economy"));
            expect(firstDriver.vehicle.make, equals("Toyota"));
            expect(firstDriver.location.latitude, equals(24.7136));
            expect(firstDriver.location.longitude, equals(46.6753));

            // Fare rules checks
            expect(r.fareRules.currency, equals("SAR"));
            expect(r.fareRules.baseFare, equals(5.0));
            expect(r.fareRules.perKmRate["Economy"], equals(2.0));
            expect(r.fareRules.perMinuteRate["Premium"], equals(1.0));
            expect(r.fareRules.minimumFare["Comfort"], equals(15.0));
          },
        );
      },
    );

    test(
      'should return a NetworkFailure (Left) when RemoteDataSource throws a DioException with SocketException (No Internet)',
          () async {
        // ARRANGE
        when(mockRemoteDataSource.get(
          tPath,
          queryParams: anyNamed('queryParams'),
          cancelToken: anyNamed('cancelToken'),
        )).thenThrow(
          DioException(
            error: const SocketException('No Internet'),
            requestOptions: RequestOptions(path: tPath),
            type: DioExceptionType.unknown,
          ),
        );

        // ACT
        final result = await repository.fetchInitialData();

        // ASSERT
        verify(mockRemoteDataSource.get(
          tPath,
          queryParams: anyNamed('queryParams'),
          cancelToken: anyNamed('cancelToken'),
        ));
        expect(result,
            equals(const Left(NetworkFailure(message: 'No Internet Connection'))));
      },
    );

    test(
      'should return BookingResponseModel (Right) with empty drivers list when API returns no drivers',
          () async {
        // ARRANGE: create a fake response with empty drivers
        final emptyResponseJson = {
          "drivers": [],
          "fare_rules": tInitialDataJson['fare_rules'], // reuse fare rules from fixture
        };
        final emptyBaseResponse =
        BaseResponseModel(body: emptyResponseJson, headers: const {});

        when(mockRemoteDataSource.get(
          tPath,
          queryParams: anyNamed('queryParams'),
          cancelToken: anyNamed('cancelToken'),
        )).thenAnswer((_) async => emptyBaseResponse);

        // ACT
        final result = await repository.fetchInitialData();

        // ASSERT
        verify(mockRemoteDataSource.get(
          tPath,
          queryParams: anyNamed('queryParams'),
          cancelToken: anyNamed('cancelToken'),
        ));

        result.fold(
              (l) => fail('Expected Right but got Left: $l'),
              (r) {
            // Drivers list should be empty
            expect(r.drivers.isEmpty, isTrue);

            // Fare rules should still be parsed correctly
            expect(r.fareRules.currency, equals("SAR"));
            expect(r.fareRules.baseFare, equals(5.0));
          },
        );
      },
    );
  });
}