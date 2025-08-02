import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  static const String routeName = '/about-us';
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // App Logo/Icon Section
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.timer,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // App Name and Version
            Center(
              child: Column(
                children: [
                  Text(
                    'Pomodoro Timer',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 1.0.0',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // About Section
            _buildSection(
              'About Our App',
              'Pomodoro Timer is a productivity app designed to help you manage your time effectively using the Pomodoro Technique. Our app combines the power of focused work sessions with intelligent task management to boost your productivity and help you achieve your goals.',
            ),
            
            const SizedBox(height: 24),
            
            // Features Section
            _buildSection(
              'Key Features',
              '• Customizable Pomodoro sessions\n• Task management and organization\n• Progress tracking and statistics\n• Break reminders and notifications\n• Clean and intuitive interface\n• Cross-platform synchronization',
            ),
            
            const SizedBox(height: 24),
            
            // Mission Section
            _buildSection(
              'Our Mission',
              'We believe that everyone deserves to work efficiently and maintain a healthy work-life balance. Our mission is to provide you with the tools you need to stay focused, organized, and productive while taking care of your well-being.',
            ),
            
            const SizedBox(height: 24),
            
            // Team Section
            _buildSection(
              'Our Team',
              'We are a dedicated team of developers and designers passionate about creating tools that make a difference in people\'s lives. We continuously work to improve our app based on user feedback and the latest productivity research.',
            ),
            
            const SizedBox(height: 24),
            
            // Contact Section
            _buildSection(
              'Get in Touch',
              'We value your feedback and suggestions. If you have any questions, feature requests, or just want to say hello, please don\'t hesitate to contact us through our Contact Us page.',
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