import 'package:flutter/material.dart';

class HelpAndFeedbackScreen extends StatefulWidget {
  const HelpAndFeedbackScreen({super.key});

  @override
  State<HelpAndFeedbackScreen> createState() => _HelpAndFeedbackScreenState();
}

class _HelpAndFeedbackScreenState extends State<HelpAndFeedbackScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _selectedCategory = 'Bug Report';
  double _ratingValue = 3;

  final List<String> _categories = [
    'Bug Report',
    'Feature Request',
    'General Feedback',
    'Performance Issue',
    'Other'
  ];

  final List<Map<String, String>> _faqItems = [
    {
      'question': 'How do I report an emergency?',
      'answer':
          'Tap the Emergency SOS button on your dashboard and confirm. The system will alert nearby ambulances and hospitals immediately.',
    },
    {
      'question': 'How do I update my location?',
      'answer':
          'Your location is automatically updated every 30 seconds when your app location services are enabled. You can manually refresh by tapping the refresh button.',
    },
    {
      'question': 'How can I find nearby hospitals?',
      'answer':
          'Go to the User Dashboard and tap on "Nearby Hospitals". The app will show hospitals within a 5km radius of your location.',
    },
    {
      'question': 'What if I accidentally triggered SOS?',
      'answer':
          'You can cancel the alert within 30 seconds of triggering it. After 30 seconds, you need to contact the ambulance service directly.',
    },
    {
      'question': 'How do ambulance drivers turn off alerts?',
      'answer':
          'Ambulance drivers can double-tap the control button on their dashboard to stop broadcasting their location.',
    },
  ];

  void _submitFeedback() {
    if (_subjectController.text.isEmpty || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thank You'),
        content: const Text('Your feedback has been submitted successfully.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _subjectController.clear();
              _messageController.clear();
              setState(() {
                _selectedCategory = 'Bug Report';
                _ratingValue = 3;
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E88E5),
          elevation: 0,
          title: const Text(
            'Help & Feedback',
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
          bottom: const TabBar(
            tabs: [
              Tab(text: 'FAQ'),
              Tab(text: 'Report Issue'),
              Tab(text: 'Rate App'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // FAQ Tab
            _buildFAQTab(),
            // Report Issue Tab
            _buildReportIssueTab(),
            // Rate App Tab
            _buildRateAppTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: _faqItems
          .map((faq) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  title: Text(
                    faq['question'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        faq['answer'] ?? '',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildReportIssueTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Report an Issue',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Category',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            items: _categories
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value ?? 'Bug Report';
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Subject',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _subjectController,
            decoration: InputDecoration(
              hintText: 'Brief description of the issue',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Description',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Detailed description (steps to reproduce, etc.)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _submitFeedback,
              icon: const Icon(Icons.send),
              label: const Text('Submit Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateAppTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          const Text(
            'Rate Our App',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'How would you rate your experience?',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => GestureDetector(
                onTap: () {
                  setState(() {
                    _ratingValue = (index + 1).toDouble();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    index < _ratingValue.toInt()
                        ? Icons.star
                        : Icons.star_border,
                    size: 50,
                    color: const Color(0xFFFFC107),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _ratingValue == 1
                ? 'Poor'
                : _ratingValue == 2
                    ? 'Fair'
                    : _ratingValue == 3
                        ? 'Good'
                        : _ratingValue == 4
                            ? 'Very Good'
                            : 'Excellent',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFC107),
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Thank You!'),
                    content: Text(
                        'Thank you for rating us $_ratingValue stars! Your feedback helps us improve.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.thumb_up),
              label: const Text('Submit Rating'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}
