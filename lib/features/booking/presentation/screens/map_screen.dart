import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:taxi_booking/core/domain/services/location_service.dart';
import 'package:taxi_booking/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:taxi_booking/features/booking/presentation/cubit/booking_state.dart';

import '../../../../core/routing/app_router.dart';

class MapScreen extends StatefulWidget {
  final LocationService locationService;

  const MapScreen({super.key, required this.locationService});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickupLatLng;
  LatLng? _destinationLatLng;
  bool _isRequesting = false;

  @override
  void initState() {
    super.initState();
    _initLocation();
    context.read<BookingCubit>().fetchInitialData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<BookingCubit>().fetchInitialData();
  }


  Future<void> _initLocation() async {
    final locationData = await widget.locationService.getCurrentLocation();
    if (locationData != null) {
      setState(() {
        _pickupLatLng = LatLng(locationData.latitude!, locationData.longitude!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BookingCubit>();
    if (cubit.state is BookingInitial || cubit.state is RideCancelled) {
      cubit.fetchInitialData();
    }

    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) async {
        if (state is RideRequested) {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (_) {
              return Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Ride Requested!",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("Estimated Fare: ${state.estimatedFare} SAR"),
                    ],
                  ),
                ),
              );
            },
          );

          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pop(context);
          });
        }


        if (state is DriverAccepted) {
          final driver = state.driver;
          context.go(AppRoutes.driverAccepted, extra: {
            'driver': driver,
            'eta': state.etaSeconds,
          });
        }
      },
      builder: (context, state) {
        final markers = <Marker>[];

        // Pickup marker
        if (_pickupLatLng != null) {
          markers.add(
            Marker(
              point: _pickupLatLng!,
              child: const Icon(Icons.person_pin_circle,
                  color: Colors.blue, size: 30),
            ),
          );
        }

        // Destination marker
        if (_destinationLatLng != null) {
          markers.add(
            Marker(
              point: _destinationLatLng!,
              child: const Icon(Icons.flag, color: Colors.red, size: 30),
            ),
          );
        }

        // Driver markers
        if (state is BookingLoaded) {
          for (final driver in state.drivers) {
            markers.add(
              Marker(
                point: LatLng(driver.location.latitude,
                    driver.location.longitude),
                width: 50,
                height: 50,
                child: Icon(Icons.local_taxi,
                    color: Colors.yellow, size: 30),
              ),
            );
          }
        }

        return Scaffold(
          body: _pickupLatLng == null
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
            options: MapOptions(
              initialCenter: _pickupLatLng!,
              initialZoom: 14,
              onTap: (tapPosition, latLng) {
                setState(() {
                  if (_pickupLatLng == null) {
                    _pickupLatLng = latLng;
                  } else {
                    _destinationLatLng = latLng;
                  }
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.taxi_booking',
              ),
              MarkerLayer(markers: markers),
              PolylineLayer(
                polylines: [
                  if (_pickupLatLng != null &&
                      _destinationLatLng != null)
                    Polyline(
                      points: [_pickupLatLng!, _destinationLatLng!],
                      strokeWidth: 4.0,
                      color: Colors.blueAccent,
                    ),
                ],
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _pickupLatLng != null && _destinationLatLng != null
                ? () async {
              setState(() => _isRequesting = true);

              final cubit = context.read<BookingCubit>();
              if (cubit.state is BookingLoaded) {
                final loaded = cubit.state as BookingLoaded;
                final drivers = loaded.drivers;
                cubit.requestRide(
                  distanceKm: 3.0,
                  vehicleType: "Economy",
                  fareRules:loaded.fareRules,
                  drivers: drivers,
                  estimatedFare: 100.0,
                );
              }

              setState(() => _isRequesting = false);
            }
                : null,
            label: _isRequesting
                ? const Text("Requesting...")
                : const Text("Request Ride"),
            icon: _isRequesting
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2),
            )
                : const Icon(Icons.local_taxi),
          ),
        );
      },
    );
  }
}