/**
 * API Service for Flutter Frontend
 * 
 * Place this file in: lib/services/api_service.dart
 * 
 * This service handles all HTTP requests to the Raksha backend.
 * Update the BASE_URL to match your backend deployment.
 */

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';

class ApiService extends GetxController {
  static const String BASE_URL = 'http://your-backend-url/api';
  
  // For local development:
  // static const String BASE_URL = 'http://10.0.2.2:5000/api'; // Android emulator
  // static const String BASE_URL = 'http://localhost:5000/api'; // iOS simulator

  String? _authToken;

  // Getters
  String? get authToken => _authToken;
  bool get isAuthenticated => _authToken != null;

  // Set auth token
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Clear auth token
  void clearAuthToken() {
    _authToken = null;
  }

  // Headers with auth token
  Map<String, String> _getHeaders({bool auth = false}) {
    final headers = {
      'Content-Type': 'application/json',
    };
    if (auth && _authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  // ========================= AUTH ENDPOINTS =========================

  /// Register new user
  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('\$BASE_URL/users/register'),
        headers: _getHeaders(),
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
          'phone': phone,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data']?['token'] != null) {
          setAuthToken(data['data']['token']);
        }
        return data;
      } else {
        return {
          'error': true,
          'message': jsonDecode(response.body)['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  /// Verify token
  Future<Map<String, dynamic>> verifyToken() async {
    try {
      final response = await http.post(
        Uri.parse('\$BASE_URL/auth/verify-token'),
        headers: _getHeaders(auth: true),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  // ========================= USER ENDPOINTS =========================

  /// Get user profile
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('\$BASE_URL/users/profile'),
        headers: _getHeaders(auth: true),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> updates) async {
    try {
      final response = await http.put(
        Uri.parse('\$BASE_URL/users/profile'),
        headers: _getHeaders(auth: true),
        body: jsonEncode(updates),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  // ========================= AMBULANCE ENDPOINTS =========================

  /// Register ambulance (for drivers)
  Future<Map<String, dynamic>> registerAmbulance({
    required String driverName,
    required String licenseNumber,
    required String licenseExpiryDate,
    required String ambulanceRegistration,
    required String ambulanceId,
    String? ambulanceLicensePath,
    String? ambulanceIdCardPath,
    String? ambulancePhotoPath,
    String? phoneNumber,
    String? emergencyContact,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('\$BASE_URL/ambulances/register'),
        headers: _getHeaders(auth: true),
        body: jsonEncode({
          'driverName': driverName,
          'licenseNumber': licenseNumber,
          'licenseExpiryDate': licenseExpiryDate,
          'ambulanceRegistration': ambulanceRegistration,
          'ambulanceId': ambulanceId,
          'ambulanceLicensePath': ambulanceLicensePath,
          'ambulanceIdCardPath': ambulanceIdCardPath,
          'ambulancePhotoPath': ambulancePhotoPath,
          'phoneNumber': phoneNumber,
          'emergencyContact': emergencyContact,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  /// Get ambulance details
  Future<Map<String, dynamic>> getAmbulanceDetails() async {
    try {
      final response = await http.get(
        Uri.parse('\$BASE_URL/ambulances/details'),
        headers: _getHeaders(auth: true),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  /// Update ambulance location
  Future<Map<String, dynamic>> updateAmbulanceLocation({
    required double latitude,
    required double longitude,
    String? address,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('\$BASE_URL/ambulances/location'),
        headers: _getHeaders(auth: true),
        body: jsonEncode({
          'latitude': latitude,
          'longitude': longitude,
          'address': address,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  /// Update ambulance status (online/offline)
  Future<Map<String, dynamic>> updateAmbulanceStatus({
    required bool isOnline,
    String? status,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('\$BASE_URL/ambulances/status'),
        headers: _getHeaders(auth: true),
        body: jsonEncode({
          'isOnline': isOnline,
          'status': status,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  /// Get nearby ambulances
  Future<Map<String, dynamic>> getNearbyAmbulances({
    required double latitude,
    required double longitude,
    double radiusKm = 5.0,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '\$BASE_URL/ambulances/nearby?latitude=\$latitude&longitude=\$longitude&radiusKm=\$radiusKm',
        ),
        headers: _getHeaders(),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  // ========================= EMERGENCY ENDPOINTS =========================

  /// Create emergency request
  Future<Map<String, dynamic>> createEmergency({
    required double latitude,
    required double longitude,
    String? address,
    String? emergencyType,
    String? description,
    String? contactPerson,
    required String contactPhone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('\$BASE_URL/emergencies/create'),
        headers: _getHeaders(auth: true),
        body: jsonEncode({
          'latitude': latitude,
          'longitude': longitude,
          'address': address,
          'emergencyType': emergencyType,
          'description': description,
          'contactPerson': contactPerson,
          'contactPhone': contactPhone,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  /// Get user's emergencies
  Future<Map<String, dynamic>> getUserEmergencies() async {
    try {
      final response = await http.get(
        Uri.parse('\$BASE_URL/emergencies'),
        headers: _getHeaders(auth: true),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  /// Get emergency details
  Future<Map<String, dynamic>> getEmergency(String emergencyId) async {
    try {
      final response = await http.get(
        Uri.parse('\$BASE_URL/emergencies/\$emergencyId'),
        headers: _getHeaders(auth: true),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  /// Update emergency status
  Future<Map<String, dynamic>> updateEmergencyStatus({
    required String emergencyId,
    String? status,
    String? assignedAmbulance,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('\$BASE_URL/emergencies/\$emergencyId'),
        headers: _getHeaders(auth: true),
        body: jsonEncode({
          'status': status,
          'assignedAmbulance': assignedAmbulance,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  // ========================= ADMIN ENDPOINTS =========================

  /// Get pending ambulances for verification
  Future<Map<String, dynamic>> getPendingAmbulances() async {
    try {
      final response = await http.get(
        Uri.parse('\$BASE_URL/admin/ambulances/pending'),
        headers: _getHeaders(auth: true),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  /// Verify ambulance
  Future<Map<String, dynamic>> verifyAmbulance({
    required String ambulanceId,
    required bool isApproved,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('\$BASE_URL/admin/ambulances/\$ambulanceId/verify'),
        headers: _getHeaders(auth: true),
        body: jsonEncode({
          'isApproved': isApproved,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  /// Get all ambulances (admin)
  Future<Map<String, dynamic>> getAllAmbulances() async {
    try {
      final response = await http.get(
        Uri.parse('\$BASE_URL/admin/ambulances/all'),
        headers: _getHeaders(auth: true),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  /// Get admin statistics
  Future<Map<String, dynamic>> getAdminStats() async {
    try {
      final response = await http.get(
        Uri.parse('\$BASE_URL/admin/stats'),
        headers: _getHeaders(auth: true),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  /// Get all pending emergencies (admin)
  Future<Map<String, dynamic>> getPendingEmergencies() async {
    try {
      final response = await http.get(
        Uri.parse('\$BASE_URL/emergencies/pending/list'),
        headers: _getHeaders(auth: true),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }

  /// Get all emergencies (admin)
  Future<Map<String, dynamic>> getAllEmergencies() async {
    try {
      final response = await http.get(
        Uri.parse('\$BASE_URL/emergencies/all/list'),
        headers: _getHeaders(auth: true),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {'error': true, 'message': e.toString()};
    }
  }
}
