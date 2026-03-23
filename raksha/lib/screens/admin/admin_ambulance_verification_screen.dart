import 'package:flutter/material.dart';

class AdminAmbulanceVerificationScreen extends StatefulWidget {
  const AdminAmbulanceVerificationScreen({super.key});

  @override
  State<AdminAmbulanceVerificationScreen> createState() =>
      _AdminAmbulanceVerificationScreenState();
}

class _AdminAmbulanceVerificationScreenState
    extends State<AdminAmbulanceVerificationScreen> {
  // Mock pending verification data
  final List<Map<String, dynamic>> _pendingVerifications = [
    {
      'id': 'PEND001',
      'name': 'Rapid Response Ambulance',
      'licenseNo': 'LIC345678',
      'regNo': 'REG901234',
      'phone': '+1-333-444-5555',
      'location': '789 Hospital Road, City',
      'submittedDate': '2024-03-20',
      'documents': ['ID Card', 'License', 'Registration', 'Photo'],
      'status': 'Pending',
    },
    {
      'id': 'PEND002',
      'name': 'Swift Medical Transport',
      'licenseNo': 'LIC456789',
      'regNo': 'REG012345',
      'phone': '+1-444-555-6666',
      'location': '321 Health Center, Downtown',
      'submittedDate': '2024-03-21',
      'documents': ['ID Card', 'License', 'Registration', 'Photo'],
      'status': 'Pending',
    },
  ];

  late List<Map<String, dynamic>> _verifications;

  @override
  void initState() {
    super.initState();
    _verifications = List.from(_pendingVerifications);
  }

  void _approveAmbulance(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Ambulance'),
        content: Text(
            'Are you sure you want to approve ${_verifications[index]['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _verifications[index]['status'] = 'Approved';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ambulance approved')),
              );
            },
            child: const Text('Approve',
                style: TextStyle(color: Color(0xFF4CAF50))),
          ),
        ],
      ),
    );
  }

  void _rejectAmbulance(int index) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Ambulance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'Are you sure you want to reject ${_verifications[index]['name']}?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                hintText: 'Reason for rejection',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              reasonController.dispose();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final reason = reasonController.text;
              reasonController.dispose();
              Navigator.pop(context);
              setState(() {
                _verifications.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Ambulance rejected${reason.isNotEmpty ? ': $reason' : ''}'),
                ),
              );
            },
            child: const Text('Reject',
                style: TextStyle(color: Color(0xFFD32F2F))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6F00),
        elevation: 0,
        title: const Text(
          'Verify Ambulances',
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
      body: _verifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.verified,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No pending verifications',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _verifications.length,
              itemBuilder: (context, index) {
                final verification = _verifications[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6F00).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.assignment_turned_in,
                        color: Color(0xFFFF6F00),
                      ),
                    ),
                    title: Text(
                      verification['name'] ?? 'Unknown',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Submitted: ${verification['submittedDate']}',
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                                'Ambulance ID', verification['id'] ?? ''),
                            _buildInfoRow('License #',
                                verification['licenseNo'] ?? ''),
                            _buildInfoRow(
                                'Registration #', verification['regNo'] ?? ''),
                            _buildInfoRow(
                                'Phone', verification['phone'] ?? ''),
                            _buildInfoRow(
                                'Location', verification['location'] ?? ''),
                            const SizedBox(height: 12),
                            const Text(
                              'Documents Submitted:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: (verification['documents']
                                      as List<String>? ??
                                  [])
                                  .map(
                                (doc) => Chip(
                                  label: Text(doc),
                                  backgroundColor:
                                      const Color(0xFFFF6F00).withOpacity(0.1),
                                  labelStyle: const TextStyle(
                                    color: Color(0xFFFF6F00),
                                  ),
                                ),
                              )
                                  .toList(),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        _approveAmbulance(index),
                                    icon: const Icon(Icons.check),
                                    label: const Text('Approve'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFF4CAF50),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _rejectAmbulance(index),
                                    icon: const Icon(Icons.close),
                                    label: const Text('Reject'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFFD32F2F),
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
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
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
