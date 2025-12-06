
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/features/booking/data/models/driver_model.dart';

import '../../features/booking/presentation/screens/driver_accepted_screen.dart';
import '../../features/booking/presentation/screens/map_screen.dart';
import '../domain/services/location_service.dart';
import '../domain/services/locator.dart';
import '../widgets/error_screen.dart';

class AppRoutes{
  static const map = '/';
  static const driverAccepted = '/driver-accepted';
}
final GoRouter appRouter =GoRouter(
  initialLocation: AppRoutes.map,
  routes: [
    GoRoute(
      path: AppRoutes.map,
      builder: (context, state) {
        final locationService = getIt<LocationService>();
        return MapScreen(locationService: locationService);
      },
    ),
    GoRoute(
      path: AppRoutes.driverAccepted,
      builder: (context, state){
        final data = state.extra as Map<String, dynamic>;
        final driver = data['driver'] as DriverModel;
        final etaSeconds = data['eta'] as int;
        return DriverAcceptedScreen(driver: driver, etaSeconds: etaSeconds);
      },

    ),
  ],
  errorBuilder: (context, state) => ErrorScreen(error: state.error.toString()),
);