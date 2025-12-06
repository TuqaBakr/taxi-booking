  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/domain/services/locator.dart';
import 'core/logger/bloc_logger.dart';
import 'core/routing/app_router.dart';
import 'features/booking/domain/booking_repository.dart';
import 'features/booking/domain/use_cases/calculate_fare_use_case.dart';
import 'features/booking/presentation/cubit/booking_cubit.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await locatorSetUp();
  Bloc.observer = blocLogger;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(

      providers: [
        BlocProvider<BookingCubit>(
          create: (context) => BookingCubit(
            repository: getIt<BookingRepository>(),
            calculateFare: CalculateFareUseCase(),
          )..fetchInitialData(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Taxi Booking',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routerConfig: appRouter,
      ),
    );


  }
}
