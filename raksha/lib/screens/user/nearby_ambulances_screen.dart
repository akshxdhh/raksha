import 'package:flutter/material.dart';

class NearbyAmbulancesScreen extends StatefulWidget {
  const NearbyAmbulancesScreen({super.key});

  @override
  State<NearbyAmbulancesScreen> createState() =>
      _NearbyAmbulancesScreenState();
}

class _NearbyAmbulancesScreenState extends State<NearbyAmbulancesScreen> {
  // Mock ambulance service data
  final List<Map<String, String>> _ambulances = [
    {
      'id': 'AMB001',
      'name': 'City Ambulance Service',
      'distance': '0.6 km',
      'responseTime': '2 min',
      'status': 'Available',
      'phone': '+1-333-111-1111',
      'license': 'LIC123456',
      'vehicles': '5',
      'staff': '10',
      'location': '123 Medical Center, City, NY',
    },
    {
      'id': 'AMB002',
      'name': 'Emergency Response Unit',
      'distance': '1.4 km',
      'responseTime': '4 min',
      'status': 'Available',
      'phone': '+1-333-222-2222',
      'license': 'LIC234567',
      'vehicles': '8',
      'staff': '15',
      'location': '456 Health Plaza, Downtown, NY',
    },
    {
      'id': 'AMB003',
      'name': 'Rapid Response Ambulance',
      'distance': '2.3 km',
      'responseTime': '6 min',
      'status': 'Busy',
      'phone': '+1-333-333-3333',
      'license': 'LIC345678',
      'vehicles': '3',
      'staff': '6',
      'location': '789 Hospital Road, City, NY',
    },
    {
      'id': 'AMB004',
      'name': 'Metro Paramedics',
      'distance': '2.8 km',
      'responseTime': '7 min',
      'status': 'Available',
      'phone': '+1-333-444-4444',
      'license': 'LIC456789',
      'vehicles': '6',
      'staff': '12',
      'location': '321 Health Center, Downtown, NY',
    },
  ];

  void _callAmbulance(String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling: $phone')),
    );
  }

  void _requestAmbulance(String ambulanceName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Ambulance'),
        content: Text('Send request to $ambulanceName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Request sent to $ambulanceName')),
              );
            },
            child: const Text('Request'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF43A047),
        elevation: 0,
        title: const Text(
          'Nearby Ambulances',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _ambulances.length,
        itemBuilder: (context, index) {
          final ambulance = _ambulances[index];
          final isAvailable = ambulance['status'] == 'Available';
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      color: isAvailable
                          ? const Color(0xFF4CAF50).withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.local_hospital,
                      color: isAvailable
                          ? const Color(0xFF4CAF50)
                          : Colors.orange,
                    ),
                  ),
                  title: Text(
                    ambulance['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            ambulance['distance'] ?? '',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.timer,
                              size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            ambulance['responseTime'] ?? '',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${ambulance['status']}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isAvailable
                              ? const Color(0xFF4CAF50)
                              : Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  onTap: () => _showAmbulanceDetails(ambulance),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _callAmbulance(ambulance['phone'] ?? ''),
                          icon: const Icon(Icons.call, size: 18),
                          label: const Text('Call'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E88E5),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _requestAmbulance(
                              ambulance['name'] ?? ''),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Request'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAmbulanceDetails(Map<String, String> ambulance) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ambulance['name'] ?? ''),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('ID', ambulance['id'] ?? ''),
              _buildDetailRow('Distance', ambulance['distance'] ?? ''),
              _buildDetailRow(
                  'Response Time', ambulance['responseTime'] ?? ''),
              _buildDetailRow('Status', ambulance['status'] ?? ''),
              _buildDetailRow('Phone', ambulance['phone'] ?? ''),
              _buildDetailRow('License', ambulance['license'] ?? ''),
              _buildDetailRow('Vehicles', ambulance['vehicles'] ?? ''),
              _buildDetailRow('Staff', ambulance['staff'] ?? ''),
              _buildDetailRow('Location', ambulance['location'] ?? ''),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (ambulance['status'] == 'Available')
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _requestAmbulance(ambulance['name'] ?? '');
              },
              child: const Text('Request'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
