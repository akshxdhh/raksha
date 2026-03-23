import 'package:flutter/material.dart';

class NearbyHospitalsScreen extends StatefulWidget {
  const NearbyHospitalsScreen({super.key});

  @override
  State<NearbyHospitalsScreen> createState() => _NearbyHospitalsScreenState();
}

class _NearbyHospitalsScreenState extends State<NearbyHospitalsScreen> {
  // Mock hospital data
  final List<Map<String, String>> _hospitals = [
    {
      'name': 'City General Hospital',
      'address': '123 Medical Center Drive, City, NY 10001',
      'phone': '+1-212-555-1234',
      'distance': '0.8 km',
      'rating': '4.8',
      'beds': '500',
      'emergencyWing': 'Yes',
      'type': 'Multi-Specialty',
    },
    {
      'name': 'Emergency Care Center',
      'address': '456 Health Plaza, Downtown, NY 10002',
      'phone': '+1-212-555-5678',
      'distance': '1.2 km',
      'rating': '4.5',
      'beds': '250',
      'emergencyWing': 'Yes',
      'type': 'Emergency Specialist',
    },
    {
      'name': 'Metropolitan Hospital',
      'address': '789 Hospital Road, Suburb, NY 10003',
      'phone': '+1-212-555-9012',
      'distance': '2.1 km',
      'rating': '4.3',
      'beds': '350',
      'emergencyWing': 'Yes',
      'type': 'General Hospital',
    },
    {
      'name': 'St. Luke Medical Center',
      'address': '321 Healthcare Avenue, City, NY 10004',
      'phone': '+1-212-555-3456',
      'distance': '2.8 km',
      'rating': '4.6',
      'beds': '400',
      'emergencyWing': 'Yes',
      'type': 'Multi-Specialty',
    },
    {
      'name': 'Riverside Hospital',
      'address': '654 Riverside Drive, City, NY 10005',
      'phone': '+1-212-555-7890',
      'distance': '3.5 km',
      'rating': '4.2',
      'beds': '300',
      'emergencyWing': 'Yes',
      'type': 'General Hospital',
    },
  ];

  void _callHospital(String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling: $phone')),
    );
  }

  void _getDirections(String hospital) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening directions to $hospital')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        elevation: 0,
        title: const Text(
          'Nearby Hospitals',
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
        itemCount: _hospitals.length,
        itemBuilder: (context, index) {
          final hospital = _hospitals[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E88E5).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.local_hospital,
                      color: Color(0xFF1E88E5),
                    ),
                  ),
                  title: Text(
                    hospital['name'] ?? '',
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
                            hospital['distance'] ?? '',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.star,
                              size: 12, color: Color(0xFFFFC107)),
                          const SizedBox(width: 4),
                          Text(
                            hospital['rating'] ?? '',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () => _showHospitalDetails(hospital),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _callHospital(hospital['phone'] ?? ''),
                          icon: const Icon(Icons.call, size: 18),
                          label: const Text('Call'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _getDirections(hospital['name'] ?? ''),
                          icon: const Icon(Icons.directions, size: 18),
                          label: const Text('Directions'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E88E5),
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

  void _showHospitalDetails(Map<String, String> hospital) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(hospital['name'] ?? ''),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Address', hospital['address'] ?? ''),
              _buildDetailRow('Phone', hospital['phone'] ?? ''),
              _buildDetailRow('Distance', hospital['distance'] ?? ''),
              _buildDetailRow('Rating', hospital['rating'] ?? ''),
              _buildDetailRow('Type', hospital['type'] ?? ''),
              _buildDetailRow('Total Beds', hospital['beds'] ?? ''),
              _buildDetailRow('Emergency Wing', hospital['emergencyWing'] ?? ''),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _callHospital(hospital['phone'] ?? '');
            },
            child: const Text('Call Now'),
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
