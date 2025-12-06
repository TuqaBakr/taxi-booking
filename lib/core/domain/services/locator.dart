import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import '../../../features/booking/data/booking_repository_impl.dart';
import '../../../features/booking/domain/booking_repository.dart';
import '../../../features/booking/domain/use_cases/calculate_fare_use_case.dart';
import '../../../features/booking/presentation/cubit/booking_cubit.dart';
import 'remote_data_source.dart';
import 'remote_data_source_impl.dart';
import 'location_service.dart';



final getIt = GetIt.instance;

Future<void> locatorSetUp() async {

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://gorest.co.in/public/v2/',
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  getIt.registerLazySingleton<Dio>(() => dio);

  getIt.registerLazySingleton<RemoteDataSource>(
        () => RemoteDataSourceImpl(dio: getIt<Dio>()),
  );

  // ------------------------------------------------------------------
  // Services / Utilities
  // ------------------------------------------------------------------

  // تسجيل Location
  getIt.registerLazySingleton(() => Location());

  getIt.registerLazySingleton<LocationService>(
        () => LocationService(getIt<Location>()),
  );




  // ------------------------------------------------------------------
  // Features - Booking Module
  // ------------------------------------------------------------------
  getIt.registerLazySingleton<BookingRepository>(
        () => BookingRepositoryImpl(remoteDataSource: getIt<RemoteDataSource>()),
  );

  getIt.registerFactory<CalculateFareUseCase>(
        () => CalculateFareUseCase(),
  );

  getIt.registerFactory<BookingCubit>(
        () => BookingCubit(
      repository: getIt<BookingRepository>(),
      calculateFare: getIt<CalculateFareUseCase>(),
    ),
  );

}



