import 'package:flutter/material.dart';

class AdminAmbulanceListScreen extends StatefulWidget {
  const AdminAmbulanceListScreen({super.key});

  @override
  State<AdminAmbulanceListScreen> createState() =>
      _AdminAmbulanceListScreenState();
}

class _AdminAmbulanceListScreenState extends State<AdminAmbulanceListScreen> {
  // Mock ambulance data
  final List<Map<String, String>> _mockAmbulances = [
    {
      'id': 'AMB001',
      'name': 'City Ambulance Service',
      'licenseNo': 'LIC123456',
      'regNo': 'REG789012',
      'phone': '+1-111-222-3333',
      'location': '123 Medical Center, City',
      'verified': 'true',
      'status': 'Active',
    },
    {
      'id': 'AMB002',
      'name': 'Emergency Response Unit',
      'licenseNo': 'LIC234567',
      'regNo': 'REG890123',
      'phone': '+1-222-333-4444',
      'location': '456 Health Plaza, Downtown',
      'verified': 'true',
      'status': 'Active',
    },
    {
      'id': 'AMB003',
      'name': 'Rapid Response Ambulance',
      'licenseNo': 'LIC345678',
      'regNo': 'REG901234',
      'phone': '+1-333-444-5555',
      'location': '789 Hospital Road, City',
      'verified': 'false',
      'status': 'Pending',
    },
  ];

  late List<Map<String, String>> _ambulances;

  @override
  void initState() {
    super.initState();
    _ambulances = List.from(_mockAmbulances);
  }

  void _toggleAmbulanceStatus(int index) {
    setState(() {
      _ambulances[index]['status'] =
          _ambulances[index]['status'] == 'Active' ? 'Inactive' : 'Active';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Ambulance ${_ambulances[index]['status'] == 'Active' ? 'activated' : 'deactivated'}'),
      ),
    );
  }

  void _deleteAmbulance(int index) {
    final name = _ambulances[index]['name'];
    setState(() {
      _ambulances.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name has been removed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeAmbulances =
        _ambulances.where((amb) => amb['status'] == 'Active').toList();
    final pendingAmbulances =
        _ambulances.where((amb) => amb['status'] == 'Pending').toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF43A047),
          elevation: 0,
          title: const Text(
            'Ambulance List',
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
          bottom: TabBar(
            tabs: [
              Tab(text: 'Active (${activeAmbulances.length})'),
              Tab(text: 'Pending (${pendingAmbulances.length})'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAmbulancesList(activeAmbulances),
            _buildAmbulancesList(pendingAmbulances),
          ],
        ),
      ),
    );
  }

  Widget _buildAmbulancesList(List<Map<String, String>> ambulances) {
    if (ambulances.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_hospital,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No ambulances found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: ambulances.length,
      itemBuilder: (context, index) {
        final ambulance = ambulances[index];
        final isVerified = ambulance['verified'] == 'true';
        final isActive = ambulance['status'] == 'Active';

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: Container(
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF4CAF50).withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(
                isActive ? Icons.local_hospital : Icons.hourglass_empty,
                color: isActive ? const Color(0xFF4CAF50) : Colors.orange,
              ),
            ),
            title: Text(
              ambulance['name'] ?? 'Unknown',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              isVerified ? '✓ Verified' : '⚠ Pending Verification',
              style: TextStyle(
                color: isVerified ? const Color(0xFF4CAF50) : Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Ambulance ID', ambulance['id'] ?? ''),
                    _buildInfoRow('License #', ambulance['licenseNo'] ?? ''),
                    _buildInfoRow(
                        'Registration #', ambulance['regNo'] ?? ''),
                    _buildInfoRow('Phone', ambulance['phone'] ?? ''),
                    _buildInfoRow('Location', ambulance['location'] ?? ''),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                _toggleAmbulanceStatus(_ambulances.indexOf(ambulance)),
                            icon: Icon(
                              isActive ? Icons.pause : Icons.play_arrow,
                            ),
                            label: Text(
                              isActive ? 'Deactivate' : 'Activate',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isActive
                                  ? Colors.orange
                                  : const Color(0xFF4CAF50),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                _deleteAmbulance(_ambulances.indexOf(ambulance)),
                            icon: const Icon(Icons.delete),
                            label: const Text('Remove'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD32F2F),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
