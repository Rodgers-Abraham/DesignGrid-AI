import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildHelpItem(
            'Getting Started',
            'Learn how to create your first design using the Creator Studio.',
          ),
          _buildHelpItem(
            'AI Co-pilot',
            'Master the prompt engineering to get the best results from Gemini.',
          ),
          _buildHelpItem(
            'Managing Projects',
            'How to save, export, and delete your design drafts.',
          ),
          _buildHelpItem(
            'Templates & Examples',
            'You can find pre-built design templates in the "assets/templates" folder of the project repository. These can be used to jumpstart your creative process.',
          ),
          _buildHelpItem(
            'Billing & PRO',
            'Information about the premium features and subscription.',
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
