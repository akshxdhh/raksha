import 'package:flutter/material.dart';
import '../../services/ambulance_broadcast_service.dart';

class AmbulanceDashboardScreen extends StatefulWidget {
  final bool isVerified;

  const AmbulanceDashboardScreen({
    super.key,
    this.isVerified = true,
  });

  @override
  State<AmbulanceDashboardScreen> createState() =>
      _AmbulanceDashboardScreenState();
}

class _AmbulanceDashboardScreenState extends State<AmbulanceDashboardScreen> {
  bool _isAlertActive = false;
  String _currentLocation = "123 Main Street, City, NY";
  DateTime _lastTapTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      if (mounted && _isAlertActive) {
        // Simulate location updates
        final locations = [
          "123 Main Street, City, NY",
          "5th Avenue, Downtown, NY",
          "Central Park Avenue, City, NY",
          "Broadway Street, City, NY",
        ];
        
        setState(() {
          _currentLocation = locations[(DateTime.now().millisecond / 250).toInt() % locations.length];
        });
      }
      return mounted;
    });
  }

  void _handleButtonTap() {
    final now = DateTime.now();
    final isDoubleTap = now.difference(_lastTapTime).inMilliseconds < 500;

    if (isDoubleTap && _isAlertActive) {
      // Double tap to close
      setState(() {
        _isAlertActive = false;
      });
      AmbulanceBroadcastService().stopBroadcast();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alert Stopped'),
          duration: Duration(seconds: 2),
        ),
      );
    } else if (!isDoubleTap && !_isAlertActive) {
      // Single tap to start
      setState(() {
        _isAlertActive = true;
      });
      AmbulanceBroadcastService().startBroadcast();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alert Started - Broadcasting Location'),
          duration: Duration(seconds: 2),
        ),
      );
    }
    
    _lastTapTime = now;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text(
          'Ambulance Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Colors.grey.shade50,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Current Location Card
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Color(0xFFE53935),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Current Location',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _currentLocation,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // TAP/DOUBLE TAP Button
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: _handleButtonTap,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFE53935),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE53935).withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _isAlertActive ? Icons.close : Icons.touch_app,
                              color: Colors.white,
                              size: 40,
                            ),
                            const SizedBox(height: 12),
                            if (!_isAlertActive)
                              const Text(
                                'TAP TO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            Text(
                              _isAlertActive ? 'DOUBLE TAP\nTO CLOSE' : 'START',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Status Indicator
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _isAlertActive
                      ? Colors.red.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isAlertActive
                        ? Colors.red.shade300
                        : Colors.green.shade300,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isAlertActive
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: _isAlertActive ? Colors.red : Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isAlertActive
                          ? 'Alert Active - Broadcasting Location'
                          : 'Ready - Tap to Start Alert',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _isAlertActive ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
