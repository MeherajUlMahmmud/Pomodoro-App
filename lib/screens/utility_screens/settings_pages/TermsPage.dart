import 'package:flutter/material.dart';

class TermsPage extends StatefulWidget {
  static const String routeName = '/terms';

  const TermsPage({super.key});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Terms & Conditions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Header
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.description,
                    size: 60,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Terms & Conditions',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last updated: December 2024',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Terms Content
            _buildSection(
              'Acceptance of Terms',
              'By downloading, installing, or using the Pomodoro Timer app, you agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use our app.',
            ),

            const SizedBox(height: 24),

            _buildSection(
              'Description of Service',
              'Pomodoro Timer is a productivity application that helps users manage their time using the Pomodoro Technique. The app provides timer functionality, task management, progress tracking, and related features.',
            ),

            const SizedBox(height: 24),

            _buildSection(
              'User Accounts',
              'To access certain features, you may need to create an account. You are responsible for:\n\n• Maintaining the confidentiality of your account credentials\n• All activities that occur under your account\n• Notifying us immediately of any unauthorized use\n• Ensuring your account information is accurate and up-to-date',
            ),

            const SizedBox(height: 24),

            _buildSection(
              'Acceptable Use',
              'You agree to use our app only for lawful purposes and in accordance with these terms. You agree not to:\n\n• Use the app for any illegal or unauthorized purpose\n• Interfere with or disrupt the app\'s functionality\n• Attempt to gain unauthorized access to our systems\n• Share your account credentials with others\n• Use the app to harm, harass, or intimidate others',
            ),

            const SizedBox(height: 24),

            _buildSection(
              'Intellectual Property',
              'The app and its content, including but not limited to text, graphics, images, logos, and software, are owned by us and protected by copyright, trademark, and other intellectual property laws. You may not reproduce, distribute, or create derivative works without our permission.',
            ),

            const SizedBox(height: 24),

            _buildSection(
              'User Content',
              'You retain ownership of any content you create or upload to the app. By using our services, you grant us a license to use, store, and display your content solely for the purpose of providing our services.',
            ),

            const SizedBox(height: 24),

            _buildSection(
              'Privacy',
              'Your privacy is important to us. Our collection and use of personal information is governed by our Privacy Policy, which is incorporated into these terms by reference.',
            ),

            const SizedBox(height: 24),

            _buildSection(
              'Disclaimers',
              'The app is provided "as is" without warranties of any kind. We do not guarantee that the app will be error-free, secure, or uninterrupted. We are not responsible for any data loss or damage that may occur while using the app.',
            ),

            const SizedBox(height: 24),

            _buildSection(
              'Limitation of Liability',
              'To the maximum extent permitted by law, we shall not be liable for any indirect, incidental, special, consequential, or punitive damages, including but not limited to loss of profits, data, or use, arising out of or relating to your use of the app.',
            ),

            const SizedBox(height: 24),

            _buildSection(
              'Termination',
              'We may terminate or suspend your account and access to the app at any time, with or without cause, with or without notice. Upon termination, your right to use the app will cease immediately.',
            ),

            const SizedBox(height: 24),

            _buildSection(
              'Governing Law',
              'These terms shall be governed by and construed in accordance with the laws of the jurisdiction in which our company is incorporated, without regard to its conflict of law provisions.',
            ),

            const SizedBox(height: 24),

            _buildSection(
              'Changes to Terms',
              'We reserve the right to modify these terms at any time. We will notify users of any material changes by posting the new terms on this page. Your continued use of the app after such changes constitutes acceptance of the new terms.',
            ),

            const SizedBox(height: 24),

            _buildSection(
              'Contact Information',
              'If you have any questions about these terms, please contact us at:\n\nEmail: legal@pomodorotimer.com\nAddress: 123 Productivity Street, Tech City, TC 12345',
            ),

            const SizedBox(height: 32),

            // Footer
            Center(
              child: Text(
                '© 2024 Pomodoro Timer. All rights reserved.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: Colors.grey[700],
              ),
        ),
      ],
    );
  }
}
