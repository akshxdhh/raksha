// Mock data and constants for the Raksha app
class AppConstants {
  static const String appName = 'Raksha';
  static const String appTagline = 'Emergency Ambulance Alert System';
  
  // Colors
  static const int userModeColorPrimary = 0xFF1E88E5;
  static const int ambulanceModeColorPrimary = 0xFFE53935;
  
  // Text
  static const String userModeName = 'User Mode';
  static const String ambulanceModeName = 'Ambulance Mode';
}

// Mock hospital data
class HospitalData {
  final String name;
  final String distance;
  final String phone;
  
  HospitalData({
    required this.name,
    required this.distance,
    required this.phone,
  });
}

// Mock ambulance service data
class AmbulanceServiceData {
  final String name;
  final String availability;
  final String phone;
  
  AmbulanceServiceData({
    required this.name,
    required this.availability,
    required this.phone,
  });
}

// Mock location data
class LocationData {
  final double latitude;
  final double longitude;
  final String address;
  
  LocationData({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}
