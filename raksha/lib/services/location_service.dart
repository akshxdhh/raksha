import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class LocationService extends GetxController {
  static final LocationService _instance = LocationService._internal();

  factory LocationService() {
    return _instance;
  }

  LocationService._internal();

  static LocationService get instance => _instance;

  final Rx<Position?> _currentPosition = Rx<Position?>(null);
  final Rx<String> _currentAddress = 'Fetching location...'.obs;
  final Rx<bool> _locationPermissionGranted = false.obs;
  StreamSubscription<Position>? _positionStreamSubscription;

  Position? get currentPosition => _currentPosition.value;
  String get currentAddress => _currentAddress.value;
  bool get locationPermissionGranted => _locationPermissionGranted.value;

  Future<bool> requestLocationPermission() async {
    try {
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        _locationPermissionGranted.value = false;
        _currentAddress.value = 'Location services are disabled';
        return false;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      _locationPermissionGranted.value =
          permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;

      if (permission == LocationPermission.deniedForever) {
        _currentAddress.value = 'Location permission permanently denied';
      }

      return _locationPermissionGranted.value;
    } catch (e) {
      debugPrint('Error requesting location permission: $e');
      return false;
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentPosition.value = position;
      await getAddressFromCoordinates(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('Error getting current location: $e');
      _currentAddress.value = 'Unable to get location';
    }
  }

  Future<void> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country,
        ].whereType<String>().where((part) => part.trim().isNotEmpty).toList();

        _currentAddress.value = parts.isNotEmpty
            ? parts.join(', ')
            : '$latitude, $longitude';
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
      _currentAddress.value = '$latitude, $longitude';
    }
  }

  Future<void> startLocationUpdates() async {
    try {
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        return;
      }

      await _positionStreamSubscription?.cancel();
      _positionStreamSubscription =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 10,
            ),
          ).listen(
            (Position position) async {
              _currentPosition.value = position;
              await getAddressFromCoordinates(
                position.latitude,
                position.longitude,
              );
            },
            onError: (Object error) {
              debugPrint('Error in location stream: $error');
            },
          );
    } catch (e) {
      debugPrint('Error starting location updates: $e');
    }
  }

  @override
  void onClose() {
    _positionStreamSubscription?.cancel();
    super.onClose();
  }
}
