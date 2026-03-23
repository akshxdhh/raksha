import 'package:flutter/material.dart';

class AdminRequestsScreen extends StatefulWidget {
  const AdminRequestsScreen({super.key});

  @override
  State<AdminRequestsScreen> createState() => _AdminRequestsScreenState();
}

class _AdminRequestsScreenState extends State<AdminRequestsScreen> {
  // Mock data for requests
  final List<Map<String, String>> _mockRequests = [
    {
      'id': 'REQ001',
      'userId': 'User123',
      'name': 'John Doe',
      'location': '123 Main Street, City, NY',
      'phone': '+1-234-567-8900',
      'time': '2:30 PM',
      'status': 'Pending',
    },
    {
      'id': 'REQ002',
      'userId': 'User456',
      'name': 'Jane Smith',
      'location': '456 Oak Avenue, Downtown, NY',
      'phone': '+1-345-678-9001',
      'time': '2:15 PM',
      'status': 'Pending',
    },
    {
      'id': 'REQ003',
      'userId': 'User789',
      'name': 'Robert Johnson',
      'location': '789 Elm Street, City, NY',
      'phone': '+1-456-789-0012',
      'time': '1:45 PM',
      'status': 'Accepted',
    },
  ];

  late List<Map<String, String>> _requests;

  @override
  void initState() {
    super.initState();
    _requests = List.from(_mockRequests);
  }

  void _acceptRequest(int index) {
    setState(() {
      _requests[index]['status'] = 'Accepted';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request accepted')),
    );
  }

  void _rejectRequest(int index) {
    setState(() {
      _requests.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request rejected')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingRequests =
        _requests.where((req) => req['status'] == 'Pending').toList();
    final acceptedRequests =
        _requests.where((req) => req['status'] == 'Accepted').toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E88E5),
          elevation: 0,
          title: const Text(
            'Manage Requests',
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
              Tab(text: 'Pending (${pendingRequests.length})'),
              Tab(text: 'Accepted (${acceptedRequests.length})'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRequestsList(pendingRequests, true),
            _buildRequestsList(acceptedRequests, false),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestsList(List<Map<String, String>> requests, bool isPending) {
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPending ? Icons.inbox : Icons.done_all,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              isPending ? 'No pending requests' : 'No accepted requests',
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
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: Container(
              decoration: BoxDecoration(
                color: isPending
                    ? const Color(0xFFFF9800).withOpacity(0.1)
                    : const Color(0xFF4CAF50).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(
                isPending ? Icons.hourglass_empty : Icons.check_circle,
                color: isPending ? const Color(0xFFFF9800) : const Color(0xFF4CAF50),
              ),
            ),
            title: Text(
              request['name'] ?? 'Unknown',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(request['time'] ?? ''),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Request ID', request['id'] ?? ''),
                    _buildInfoRow('User ID', request['userId'] ?? ''),
                    _buildInfoRow('Phone', request['phone'] ?? ''),
                    _buildInfoRow('Location', request['location'] ?? ''),
                    const SizedBox(height: 16),
                    if (isPending)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _acceptRequest(
                                _requests.indexOf(request),
                              ),
                              icon: const Icon(Icons.check),
                              label: const Text('Accept'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _rejectRequest(
                                _requests.indexOf(request),
                              ),
                              icon: const Icon(Icons.close),
                              label: const Text('Reject'),
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
            width: 80,
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
