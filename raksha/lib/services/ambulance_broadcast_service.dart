// Simple service to track ambulance broadcast state
class AmbulanceBroadcastService {
  static final AmbulanceBroadcastService _instance =
      AmbulanceBroadcastService._internal();

  factory AmbulanceBroadcastService() {
    return _instance;
  }

  AmbulanceBroadcastService._internal();

  bool _isAmbulanceLive = false;
  String _ambulanceDistance = "500m";

  bool get isAmbulanceLive => _isAmbulanceLive;
  String get ambulanceDistance => _ambulanceDistance;

  void startBroadcast() {
    _isAmbulanceLive = true;
    _ambulanceDistance = "500m";
  }

  void stopBroadcast() {
    _isAmbulanceLive = false;
  }
}
