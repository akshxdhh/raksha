# Backend Integration with Flutter Frontend

Complete guide to integrate the Raksha backend with your Flutter frontend.

## Prerequisites

- Backend running on `http://10.0.2.2:5000` (Android) or `http://localhost:5000` (iOS)
- API service file: `lib/services/api_service.dart` (already created)
- HTTP package in pubspec.yaml (already added)
- GetX for state management (already setup)

## 1. Initialize API Service

### In `lib/main.dart`:

```dart
import 'package:get/get.dart';
import 'services/api_service.dart';

void main() {
  // Initialize API Service before running app
  Get.put(ApiService());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Raksha',
      theme: ThemeData(primaryColor: const Color(0xFF1E88E5)),
      home: const ModeSelectionScreen(),
    );
  }
}
```

## 2. User Registration Integration

### In `lib/screens/user/register_screen.dart`:

```dart
import 'package:get/get.dart';
import '../../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final apiService = Get.find<ApiService>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;

  Future<void> _register() async {
    setState(() => _isLoading = true);

    try {
      final result = await apiService.registerUser(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        phone: _phoneController.text,
      );

      if (!result['error']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Registration failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
```

## 3. Ambulance Registration Integration

### In `lib/screens/ambulance_driver/ambulance_verification_screen_new.dart`:

```dart
import 'package:get/get.dart';
import '../../services/api_service.dart';

// In the state class, add:
final apiService = Get.find<ApiService>();

// Update the submission method:
void _submitVerification() {
  if (_formKey.currentState!.validate()) {
    if (_idCardImagePath == null ||
        _licenseImagePath == null ||
        _ambulancePhotoPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload all required documents'),
        ),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Dialog(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SizedBox(
            height: 50,
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );

    // Send to backend
    _submitToBackend();
  }
}

Future<void> _submitToBackend() async {
  try {
    final result = await apiService.registerAmbulance(
      driverName: _nameController.text,
      licenseNumber: _licenseNoController.text,
      licenseExpiryDate: '',
      ambulanceRegistration: _regNoController.text,
      ambulanceId: _ambulanceIdController.text,
      ambulanceLicensePath: _licenseImagePath,
      ambulanceIdCardPath: _idCardImagePath,
      ambulancePhotoPath: _ambulancePhotoPath,
      phoneNumber: '',
      emergencyContact: '',
    );

    if (mounted) {
      Navigator.pop(context); // Close loading dialog

      if (!result['error']) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Verification Submitted'),
            content: const Text(
              'Your ambulance verification has been submitted successfully. '
              'Our admin team will review your documents and get back to you '
              'within 24 hours.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Submission failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  } catch (e) {
    if (mounted) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
```

## 4. Emergency Request Integration

### In `lib/screens/user/user_dashboard_screen.dart`:

```dart
import '../../services/api_service.dart';

// Update the SOS emergency creation:
Future<void> _handleSOSConfirmed() async {
  final apiService = Get.find<ApiService>();
  
  final result = await apiService.createEmergency(
    latitude: _currentLatitude ?? 0.0,
    longitude: _currentLongitude ?? 0.0,
    address: _currentAddress,
    contactPhone: '+1234567890', // Get from user profile
  );

  if (!result['error']) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Emergency request sent! Ambulance on the way.'),
        backgroundColor: Colors.green,
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message'] ?? 'Failed to send emergency request'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

## 5. Ambulance Location Tracking

### In `lib/screens/ambulance_driver/ambulance_dashboard_screen.dart`:

```dart
import '../../services/api_service.dart';

void _startLocationUpdates() {
  final apiService = Get.find<ApiService>();
  
  Future.doWhile(() async {
    await Future.delayed(const Duration(seconds: 5));
    if (mounted && _isAlertActive) {
      // Get current location
      final position = await Geolocator.getCurrentPosition();
      
      // Update location in backend
      await apiService.updateAmbulanceLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        address: _currentLocation,
      );

      setState(() {
        _currentLocation = "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
      });
    }
    return mounted;
  });
}

void _handleButtonTap() {
  final apiService = Get.find<ApiService>();
  final now = DateTime.now();
  final isDoubleTap = now.difference(_lastTapTime).inMilliseconds < 500;

  if (isDoubleTap && _isAlertActive) {
    // Double tap to close
    setState(() => _isAlertActive = false);
    
    // Update status in backend
    apiService.updateAmbulanceStatus(
      isOnline: false,
      status: 'inactive',
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alert Stopped')),
    );
  } else if (!isDoubleTap && !_isAlertActive) {
    // Single tap to start
    setState(() => _isAlertActive = true);
    
    // Update status in backend
    apiService.updateAmbulanceStatus(
      isOnline: true,
      status: 'active',
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alert Started - Broadcasting Location')),
    );
  }
  
  _lastTapTime = now;
}
```

## 6. Nearby Ambulances Display

### In `lib/screens/user/nearby_ambulances_screen.dart`:

```dart
import '../../services/api_service.dart';

class NearbyAmbulancesScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const NearbyAmbulancesScreen({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<NearbyAmbulancesScreen> createState() =>
      _NearbyAmbulancesScreenState();
}

class _NearbyAmbulancesScreenState extends State<NearbyAmbulancesScreen> {
  final apiService = Get.find<ApiService>();
  late Future<Map<String, dynamic>> _ambulancesFuture;

  @override
  void initState() {
    super.initState();
    _loadNearbyAmbulances();
  }

  void _loadNearbyAmbulances() {
    _ambulancesFuture = apiService.getNearbyAmbulances(
      latitude: widget.latitude,
      longitude: widget.longitude,
      radiusKm: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Ambulances'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _ambulancesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!['error'] == true) {
            return Center(
              child: Text(
                snapshot.data?['message'] ?? 'No ambulances found',
              ),
            );
          }

          final ambulances = snapshot.data!['data'] as List;

          if (ambulances.isEmpty) {
            return const Center(child: Text('No nearby ambulances available'));
          }

          return ListView.builder(
            itemCount: ambulances.length,
            itemBuilder: (context, index) {
              final ambulance = ambulances[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(ambulance['driverName'] ?? 'N/A'),
                  subtitle: Text(
                    'Distance: ${ambulance['distance'] ?? 'N/A'} km',
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => _requestAmbulance(ambulance),
                    child: const Text('Request'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _requestAmbulance(Map<String, dynamic> ambulance) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Request sent to ${ambulance['driverName'] ?? "Ambulance"}',
        ),
      ),
    );
  }
}
```

## 7. Admin Dashboard Integration

### In `lib/screens/admin/admin_requests_screen.dart`:

```dart
import '../../services/api_service.dart';

class AdminRequestsScreen extends StatefulWidget {
  const AdminRequestsScreen({super.key});

  @override
  State<AdminRequestsScreen> createState() => _AdminRequestsScreenState();
}

class _AdminRequestsScreenState extends State<AdminRequestsScreen> {
  final apiService = Get.find<ApiService>();
  late Future<Map<String, dynamic>> _emergenciesFuture;

  @override
  void initState() {
    super.initState();
    _loadEmergencies();
  }

  void _loadEmergencies() {
    _emergenciesFuture = apiService.getPendingEmergencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _emergenciesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!['error'] == true) {
          return Center(
            child: Text(
              snapshot.data?['message'] ?? 'Failed to load emergencies',
            ),
          );
        }

        final emergencies = snapshot.data!['data'] as List;

        if (emergencies.isEmpty) {
          return const Center(child: Text('No pending emergencies'));
        }

        return ListView.builder(
          itemCount: emergencies.length,
          itemBuilder: (context, index) {
            final emergency = emergencies[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(
                  '${emergency['emergencyType'] ?? "Emergency"} - ${emergency['contactPhone']}'
                ),
                subtitle: Text(emergency['address'] ?? 'No address provided'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          _acceptEmergency(emergency['id']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Accept'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () =>
                          _rejectEmergency(emergency['id']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Reject'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _acceptEmergency(String emergencyId) async {
    final result = await apiService.updateEmergencyStatus(
      emergencyId: emergencyId,
      status: 'accepted',
    );

    if (!result['error']) {
      setState(() => _loadEmergencies());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Emergency accepted')),
      );
    }
  }

  Future<void> _rejectEmergency(String emergencyId) async {
    final result = await apiService.updateEmergencyStatus(
      emergencyId: emergencyId,
      status: 'cancelled',
    );

    if (!result['error']) {
      setState(() => _loadEmergencies());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Emergency rejected')),
      );
    }
  }
}
```

## Error Handling Best Practices

```dart
// Wrap API calls in try-catch
try {
  final result = await apiService.createEmergency(
    latitude: lat,
    longitude: lon,
    contactPhone: phone,
  );

  if (result['error'] ?? false) {
    // Handle API error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message'] ?? 'Unknown error'),
        backgroundColor: Colors.red,
      ),
    );
  } else {
    // Handle success
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Success!'),
        backgroundColor: Colors.green,
      ),
    );
  }
} catch (e) {
  // Handle network/parsing errors
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Error: ${e.toString()}'),
      backgroundColor: Colors.red,
    ),
  );
}
```

## Testing the Integration

1. Start backend: `npm run dev`
2. Update API service BASE_URL for your environment
3. Run Flutter: `flutter run`
4. Register a user and test features
5. Monitor backend logs for errors

## Next Steps

- [ ] Test user registration
- [ ] Test ambulance verification
- [ ] Test emergency creation
- [ ] Test ambulance location updates
- [ ] Deploy backend to production
- [ ] Update API service BASE_URL to production URL
- [ ] Build and deploy Flutter app

---

For backend API documentation, see [Backend README](./README.md)
