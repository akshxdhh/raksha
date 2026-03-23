import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AmbulanceVerificationScreen extends StatefulWidget {
  const AmbulanceVerificationScreen({super.key});

  @override
  State<AmbulanceVerificationScreen> createState() =>
      _AmbulanceVerificationScreenState();
}

class _AmbulanceVerificationScreenState
    extends State<AmbulanceVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _licenseNoController = TextEditingController();
  final _regNoController = TextEditingController();
  final _ambulanceIdController = TextEditingController();

  String? _idCardImagePath;
  String? _licenseImagePath;
  String? _ambulancePhotoPath;

  void _pickImage(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Upload $type'),
        content: const Text('Choose image source:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _captureFromCamera(type);
            },
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickFromGallery(type);
            },
            child: const Text('Gallery'),
          ),
        ],
      ),
    );
  }

  Future<void> _captureFromCamera(String type) async {
    // Request camera permission
    final status = await Permission.camera.request();
    
    if (status.isDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera permission is required to capture images'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    } else if (status.isPermanentlyDenied) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Camera Permission Required'),
            content: const Text(
              'Camera permission is permanently denied. Please enable it in app settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.pop(context);
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      }
      return;
    }

    // Simulate camera capture
    _simulateImageCapture(type, 'Camera');
  }

  Future<void> _pickFromGallery(String type) async {
    // Request file access permission (storage)
    final status = await Permission.photos.request();
    
    if (status.isDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gallery access permission is required'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      return;
    } else if (status.isPermanentlyDenied) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Gallery Access Required'),
            content: const Text(
              'Gallery access is permanently denied. Please enable it in app settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.pop(context);
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      }
      return;
    }

    // Simulate gallery pick
    _simulateImageCapture(type, 'Gallery');
  }

  void _simulateImageCapture(String type, String source) {
    setState(() {
      if (type == 'ID Card') {
        _idCardImagePath = 'captured_from_$source.jpg';
      } else if (type == 'License') {
        _licenseImagePath = 'captured_from_$source.jpg';
      } else if (type == 'Ambulance Photo') {
        _ambulancePhotoPath = 'captured_from_$source.jpg';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type successfully captured from $source'),
        backgroundColor: const Color(0xFF4CAF50),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _submitVerification() {
    if (_formKey.currentState!.validate()) {
      if (_idCardImagePath == null ||
          _licenseImagePath == null ||
          _ambulancePhotoPath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload all required documents')),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Verification Submitted'),
          content: const Text(
            'Your ambulance verification has been submitted successfully. Our admin team will review your documents and get back to you within 24 hours.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E88E5),
        elevation: 0,
        title: const Text(
          'Ambulance Verification',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Driver Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              const Text(
                'Ambulance Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _licenseNoController,
                decoration: InputDecoration(
                  hintText: 'License Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter license number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _regNoController,
                decoration: InputDecoration(
                  hintText: 'Ambulance Registration Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter registration number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ambulanceIdController,
                decoration: InputDecoration(
                  hintText: 'Ambulance ID Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter ambulance ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),
              const Text(
                'Documents & Photos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              _buildDocumentUpload(
                'Ambulance ID Card',
                'Tap camera to capture or take from gallery',
                _idCardImagePath,
                () => _pickImage('ID Card'),
              ),
              const SizedBox(height: 12),
              _buildDocumentUpload(
                'Ambulance License',
                'Tap camera to capture or select from gallery',
                _licenseImagePath,
                () => _pickImage('License'),
              ),
              const SizedBox(height: 12),
              _buildDocumentUpload(
                'Ambulance Number Plate Photo',
                'Capture a clear live photo of ambulance number plate',
                _ambulancePhotoPath,
                () => _pickImage('Ambulance Photo'),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitVerification,
                  icon: const Icon(Icons.check),
                  label: const Text('Submit for Verification'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E88E5).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                child: const Text(
                  'Note: All documents will be verified by our admin team. Please ensure all photos are clear and documents are valid.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentUpload(
    String title,
    String description,
    String? imagePath,
    VoidCallback onUpload,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: imagePath != null
              ? const Color(0xFF4CAF50)
              : Colors.grey.shade300,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: imagePath != null
                      ? const Color(0xFF4CAF50).withOpacity(0.1)
                      : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(
                  imagePath != null ? Icons.check_circle : Icons.camera_alt,
                  color: imagePath != null
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFF1E88E5),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      imagePath != null ? 'Uploaded ✓' : description,
                      style: TextStyle(
                        fontSize: 12,
                        color: imagePath != null
                            ? const Color(0xFF4CAF50)
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: onUpload,
                icon: Icon(imagePath != null ? Icons.edit : Icons.photo_camera),
                label: Text(imagePath != null ? 'Change' : 'Capture'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _licenseNoController.dispose();
    _regNoController.dispose();
    _ambulanceIdController.dispose();
    super.dispose();
  }
}
