import 'package:flutter/material.dart';
import 'admin_requests_screen.dart';
import 'admin_ambulance_list_screen.dart';
import 'admin_users_screen.dart';
import 'admin_ambulance_verification_screen.dart';

class AdminModeSelectionScreen extends StatelessWidget {
  const AdminModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        elevation: 0,
        title: const Text(
          'Admin Panel',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildAdminCard(
                icon: Icons.assignment,
                title: 'Manage Requests',
                description: 'View and manage emergency requests',
                color: const Color(0xFF1E88E5),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminRequestsScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildAdminCard(
                icon: Icons.local_hospital,
                title: 'Ambulance List',
                description: 'View and manage ambulance services',
                color: const Color(0xFF43A047),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminAmbulanceListScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildAdminCard(
                icon: Icons.verified_user,
                title: 'Verify Ambulances',
                description: 'Manually verify ambulance documents',
                color: const Color(0xFFFF6F00),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AdminAmbulanceVerificationScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildAdminCard(
                icon: Icons.people,
                title: 'User Management',
                description: 'View users and remove accounts',
                color: const Color(0xFFD32F2F),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminUsersScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}
