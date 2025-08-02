import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatefulWidget {
  static const String routeName = '/privacy-policy';
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Privacy Policy'),
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
                    Icons.privacy_tip,
                    size: 60,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Privacy Policy',
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

            // Privacy Policy Content
            _buildSection(
              'Information We Collect',
              'We collect information you provide directly to us, such as when you create an account, use our services, or contact us. This may include:\n\n• Account information (name, email, profile picture)\n• Usage data (timer sessions, tasks, statistics)\n• Device information (device type, operating system)\n• Log data (app usage, error reports)',
            ),

            const SizedBox(height: 24),

            _buildSection(
              'How We Use Your Information',
              'We use the information we collect to:\n\n• Provide and maintain our services\n• Personalize your experience\n• Improve our app functionality\n• Send you important updates and notifications\n• Respond to your questions and support requests\n• Analyze usage patterns to enhance user experience',
            ),

            const SizedBox(height: 24),

            _buildSection(
              'Information Sharing',
              'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except in the following circumstances:\n\n• With your explicit permission\n• To comply with legal obligations\n• To protect our rights and safety\n• In connection with a business transfer or merger',
            ),

            const SizedBox(height: 24),

            _buildSection(
              'Data Security',
              'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet is 100% secure, and we cannot guarantee absolute security.',
            ),

            const SizedBox(height: 24),

            _buildSection(
              'Data Retention',
              'We retain your personal information for as long as necessary to provide our services and fulfill the purposes outlined in this privacy policy. You may request deletion of your account and associated data at any time.',
            ),

            const SizedBox(height: 24),

            _buildSection(
              'Your Rights',
              'You have the right to:\n\n• Access your personal information\n• Correct inaccurate data\n• Request deletion of your data\n• Opt-out of certain communications\n• Export your data\n• Withdraw consent at any time',
            ),

            const SizedBox(height: 24),

            _buildSection(
              'Cookies and Tracking',
              'Our app may use cookies and similar technologies to enhance your experience, analyze usage patterns, and provide personalized content. You can control cookie settings through your device preferences.',
            ),

            const SizedBox(height: 24),

            _buildSection(
              'Children\'s Privacy',
              'Our services are not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13. If you believe we have collected such information, please contact us immediately.',
            ),

            const SizedBox(height: 24),

            _buildSection(
              'Changes to This Policy',
              'We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy on this page and updating the "Last updated" date. We encourage you to review this policy periodically.',
            ),

            const SizedBox(height: 24),

            _buildSection(
              'Contact Us',
              'If you have any questions about this privacy policy or our data practices, please contact us at:\n\nEmail: privacy@pomodorotimer.com\nAddress: 123 Productivity Street, Tech City, TC 12345',
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
