import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../services/location_service.dart';
import 'ambulance_dashboard_screen.dart';

class AmbulanceVerificationScreen extends StatefulWidget {
  const AmbulanceVerificationScreen({super.key});

  @override
  State<AmbulanceVerificationScreen> createState() =>
      _AmbulanceVerificationScreenState();
}

class _AmbulanceVerificationScreenState
    extends State<AmbulanceVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _driverNameController;
  late TextEditingController _licenseNumberController;
  late TextEditingController _ambulanceRegistrationController;
  late TextEditingController _hospitalNameController;

  String? _licenseFileName;
  String? _idProofFileName;
  final LocationService _locationService = LocationService.instance;

  @override
  void initState() {
    super.initState();
    _driverNameController = TextEditingController();
    _licenseNumberController = TextEditingController();
    _ambulanceRegistrationController = TextEditingController();
    _hospitalNameController = TextEditingController();
    _requestLocationPermission();
  }

  void _requestLocationPermission() async {
    await _locationService.requestLocationPermission();
  }

  Future<void> _pickFile(bool isPrimary) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null && result.files.single.name.isNotEmpty) {
        setState(() {
          if (isPrimary) {
            _licenseFileName = result.files.single.name;
          } else {
            _idProofFileName = result.files.single.name;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${isPrimary ? 'License' : 'ID Proof'} uploaded: ${result.files.single.name}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _driverNameController.dispose();
    _licenseNumberController.dispose();
    _ambulanceRegistrationController.dispose();
    _hospitalNameController.dispose();
    super.dispose();
  }

  bool get _canVerify =>
      _driverNameController.text.isNotEmpty &&
      _licenseNumberController.text.isNotEmpty &&
      _ambulanceRegistrationController.text.isNotEmpty &&
      _licenseFileName != null &&
      _idProofFileName != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE53935),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ambulance Driver Verification',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade50,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Icon
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.local_hospital,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Required Fields Label
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Required Fields',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  // Driver Name (Required)
                  const Text(
                    'Driver Name *',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _driverNameController,
                    hintText: 'Enter your full name',
                    icon: Icons.person,
                    onChanged: (value) => setState(() {}),
                  ),
                  const SizedBox(height: 20),

                  // License Number (Required)
                  const Text(
                    'License Number *',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _licenseNumberController,
                    hintText: 'Enter license number',
                    icon: Icons.assignment,
                    onChanged: (value) => setState(() {}),
                  ),
                  const SizedBox(height: 20),

                  // Ambulance Registration (Required)
                  const Text(
                    'Ambulance Registration *',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _ambulanceRegistrationController,
                    hintText: 'Enter ambulance registration number',
                    icon: Icons.local_hospital,
                    onChanged: (value) => setState(() {}),
                  ),
                  const SizedBox(height: 24),

                  // Optional Fields Label
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Optional Fields',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  // Hospital Name (Optional)
                  const Text(
                    'Hospital Name',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _hospitalNameController,
                    hintText: 'Enter hospital name (optional)',
                    icon: Icons.location_city,
                  ),
                  const SizedBox(height: 24),

                  // Document Upload Section
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Document Upload *',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  // Upload License
                  _buildUploadCard(
                    icon: Icons.upload_file,
                    title: 'Upload License',
                    description: 'Upload your driving license',
                    fileName: _licenseFileName,
                    onTap: () => _pickFile(true),
                  ),
                  const SizedBox(height: 12),

                  // Upload ID Proof
                  _buildUploadCard(
                    icon: Icons.upload_file,
                    title: 'Upload ID Proof',
                    description: 'Upload your ID proof document',
                    fileName: _idProofFileName,
                    onTap: () => _pickFile(false),
                  ),
                  const SizedBox(height: 32),

                  // Verify & Continue Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _canVerify
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AmbulanceDashboardScreen(),
                                  ),
                                );
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _canVerify
                            ? const Color(0xFFE53935)
                            : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        'Verify & Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _canVerify
                              ? Colors.white
                              : Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: const Color(0xFFE53935)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildUploadCard({
    required IconData icon,
    required String title,
    required String description,
    required String? fileName,
    required VoidCallback onTap,
  }) {
    final isUploaded = fileName != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUploaded
                ? Colors.green
                : const Color(0xFFE53935).withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isUploaded
                      ? Colors.green.withOpacity(0.1)
                      : const Color(0xFFE53935).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isUploaded ? Icons.check_circle : icon,
                  color: isUploaded ? Colors.green : const Color(0xFFE53935),
                  size: 24,
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
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isUploaded ? 'File: $fileName' : description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isUploaded ? Colors.green : Colors.grey.shade600,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isUploaded ? Colors.green : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
