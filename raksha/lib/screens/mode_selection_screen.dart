import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/location_service.dart';
import '../services/language_service.dart';
import 'ambulance_driver/ambulance_verification_screen.dart';
import 'user/enable_location_screen.dart';
import 'user/user_dashboard_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Get.find<LanguageService>();
    final languages = [
      'English',
      'Spanish',
      'French',
      'German',
      'Hindi',
      'Tamil',
      'Bengali',
      'Marathi',
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.shade50,
              Colors.grey.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.shade50,
                  ),
                  child: const Icon(
                    Icons.local_hospital,
                    size: 60,
                    color: Color(0xFFE53935),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Raksha',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Emergency Ambulance Alert',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 60),
                
                // User Mode Button
                _ModeButton(
                  label: 'User Mode',
                  color: const Color(0xFF1E88E5),
                  icon: Icons.person,
                  onPressed: () async {
                    final locationService = LocationService.instance;
                    final hasPermission = await locationService.hasLocationPermission();

                    if (!context.mounted) {
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => hasPermission
                            ? const UserDashboardScreen()
                            : const EnableLocationScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                
                // Ambulance Mode Button
                _ModeButton(
                  label: 'Ambulance Mode',
                  color: const Color(0xFFE53935),
                  icon: Icons.local_hospital,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AmbulanceVerificationScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 60),
                
                // Language Selection
                Obx(() => GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Select Language'),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: ListView.builder(
                            itemCount: languages.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(languages[index]),
                                trailing: languageService.selectedLanguage ==
                                        languages[index]
                                    ? const Icon(
                                        Icons.check,
                                        color: Color(0xFF1E88E5),
                                      )
                                    : null,
                                onTap: () {
                                  languageService.setLanguage(languages[index]);
                                  Navigator.pop(context);
                                  Get.forceAppUpdate();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Language changed to ${languages[index]}',
                                      ),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.language,
                                size: 20,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                languageService.selectedLanguage,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  const _ModeButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 32,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
