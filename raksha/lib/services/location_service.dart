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

  Position? get currentPosition => _currentPosition.value;
  String get currentAddress => _currentAddress.value;
  bool get locationPermissionGranted => _locationPermissionGranted.value;

  Future<bool> requestLocationPermission() async {
    try {
      final permission = await Geolocator.requestPermission();
      _locationPermissionGranted.value = permission == LocationPermission.granted ||
          permission == LocationPermission.whileInUse;
      if (_locationPermissionGranted.value) {
        await getCurrentLocation();
      }
      return _locationPermissionGranted.value;
    } catch (e) {
      print('Error requesting location permission: $e');
      return false;
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        await requestLocationPermission();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _currentPosition.value = position;
      await getAddressFromCoordinates(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting current location: $e');
      _currentAddress.value = 'Unable to get location';
    }
  }

  Future<void> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        _currentAddress.value =
            '${place.street}, ${place.locality}, ${place.country}';
      }
    } catch (e) {
      print('Error getting address: $e');
      _currentAddress.value = '$latitude, $longitude';
    }
  }

  Future<void> startLocationUpdates() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((Position position) {
        _currentPosition.value = position;
        getAddressFromCoordinates(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error starting location updates: $e');
    }
  }
}
