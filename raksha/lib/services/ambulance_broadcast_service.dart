import 'dart:async';

// Service to track ambulance broadcast state with auto turn-off logic
class AmbulanceBroadcastService {
  static final AmbulanceBroadcastService _instance =
      AmbulanceBroadcastService._internal();

  factory AmbulanceBroadcastService() {
    return _instance;
  }

  AmbulanceBroadcastService._internal();

  bool _isAmbulanceLive = false;
  String _ambulanceDistance = "500m";
  Timer? _noMovementTimer;
  String? _lastRecordedLocation;
  Duration _noMovementThreshold = const Duration(minutes: 1);

  bool get isAmbulanceLive => _isAmbulanceLive;
  String get ambulanceDistance => _ambulanceDistance;

  void startBroadcast() {
    _isAmbulanceLive = true;
    _ambulanceDistance = "500m";
    _lastRecordedLocation = null;
    _startNoMovementTimer();
  }

  void stopBroadcast() {
    _isAmbulanceLive = false;
    _noMovementTimer?.cancel();
    _lastRecordedLocation = null;
  }

  /// Call this method whenever the ambulance location updates
  /// If location hasn't changed for 1 minute, broadcast will auto stop
  void updateLocation(String location) {
    if (!_isAmbulanceLive) return;

    // If location is different, reset the timer
    if (location != _lastRecordedLocation) {
      _lastRecordedLocation = location;
      _noMovementTimer?.cancel();
      _startNoMovementTimer();
    }
  }

  void _startNoMovementTimer() {
    _noMovementTimer?.cancel();
    _noMovementTimer = Timer(_noMovementThreshold, () {
      if (_isAmbulanceLive) {
        // Auto stop broadcast if no location change detected
        stopBroadcast();
        // In a real app, you might log this or notify the driver
      }
    });
  }

  @override
  String toString() =>
      'AmbulanceBroadcastService(isLive: $_isAmbulanceLive, distance: $_ambulanceDistance)';
}
