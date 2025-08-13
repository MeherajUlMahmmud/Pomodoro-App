import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pomodoro/screens/auth_screens/LoginScreen.dart';
import 'package:pomodoro/screens/main_screens/HomeScreen.dart';
import 'package:pomodoro/services/firebase_service.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _pulseController;
  late Animation<double> _logoAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Color?> _colorAnimation;

  final FirebaseService _firebaseService = FirebaseService();
  bool _isCheckingAuth = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkAuthentication();
  }

  void _initializeAnimations() {
    // Logo animation - fade in and scale up
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    ));

    // Pulse animation for the loading indicator
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Color animation for the loading dots
    _colorAnimation = ColorTween(
      begin: const Color(0xFF527E5C).withOpacity(0.3),
      end: const Color(0xFF527E5C),
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _logoController.forward();
    _pulseController.repeat(reverse: true);
  }

  Future<void> _checkAuthentication() async {
    try {
      // Wait a minimum time to show the splash screen
      await Future.delayed(const Duration(milliseconds: 2000));

      // Check if user is authenticated with timeout
      User? currentUser;
      try {
        currentUser = _firebaseService.getCurrentUser();
      } catch (e) {
        debugPrint('Error getting current user: $e');
        currentUser = null;
      }

      if (mounted) {
        setState(() {
          _isCheckingAuth = false;
        });

        // Add a small delay before navigation to show the success state
        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          if (currentUser != null) {
            // User is logged in
            _navigateToHome();
          } else {
            // User is not logged in
            _navigateToLogin();
          }
        }
      }
    } catch (e) {
      debugPrint('Authentication check error: $e');
      // Handle any errors by navigating to login
      if (mounted) {
        setState(() {
          _isCheckingAuth = false;
        });

        // Add a small delay before navigation
        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          _navigateToLogin();
        }
      }
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF527E5C),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF527E5C),
              const Color(0xFF527E5C).withOpacity(0.8),
              const Color(0xFF527E5C).withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo and App Name
              Expanded(
                flex: 2,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _logoAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoAnimation.value,
                        child: Opacity(
                          opacity: _logoAnimation.value,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // App Icon/Logo
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.timer,
                                  size: 60,
                                  color: Color(0xFF527E5C),
                                ),
                              ),
                              const SizedBox(height: 24),
                              // App Name
                              const Text(
                                "Pomodoro",
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Focus • Achieve • Repeat",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Loading Section
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isCheckingAuth) ...[
                      // Loading text
                      const Text(
                        "Checking authentication...",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Animated loading dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: _colorAnimation.value,
                                  shape: BoxShape.circle,
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ] else ...[
                      // Success/Ready indicator
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 32,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Ready!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Bottom spacing
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
