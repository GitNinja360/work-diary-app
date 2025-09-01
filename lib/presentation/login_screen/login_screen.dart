import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/institutional_logo_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/register_link_widget.dart';
import './widgets/sso_options_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  // Mock credentials for different user types
  final Map<String, Map<String, String>> _mockCredentials = {
    'student@university.edu': {
      'password': 'student123',
      'role': 'student',
      'route': '/student-dashboard'
    },
    'teacher@university.edu': {
      'password': 'teacher123',
      'role': 'teacher',
      'route': '/teacher-dashboard'
    },
    'admin@university.edu': {
      'password': 'admin123',
      'role': 'admin',
      'route': '/teacher-dashboard'
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                    children: [
                      SizedBox(height: 8.h),

                      // Institutional Logo
                      InstitutionalLogoWidget(),

                      SizedBox(height: 6.h),

                      // Login Form
                      LoginFormWidget(
                        onLogin: _handleLogin,
                        isLoading: _isLoading,
                      ),

                      SizedBox(height: 4.h),

                      // SSO Options
                      SsoOptionsWidget(
                        onSsoLogin: _handleSsoLogin,
                        isLoading: _isLoading,
                      ),

                      Spacer(),

                      // Register Link
                      RegisterLinkWidget(),

                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 1500));

      // Check mock credentials
      if (_mockCredentials.containsKey(email.toLowerCase())) {
        final userCredentials = _mockCredentials[email.toLowerCase()]!;

        if (userCredentials['password'] == password) {
          // Success - trigger haptic feedback
          HapticFeedback.lightImpact();

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: Colors.white,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Text('Welcome back! Redirecting...'),
                ],
              ),
              backgroundColor: AppTheme.lightTheme.colorScheme.primary,
              duration: Duration(seconds: 2),
            ),
          );

          // Navigate to appropriate dashboard
          await Future.delayed(Duration(milliseconds: 500));
          if (mounted) {
            Navigator.pushReplacementNamed(
              context,
              userCredentials['route']!,
            );
          }
        } else {
          _showErrorMessage('Invalid password. Please check your credentials.');
        }
      } else {
        _showErrorMessage(
            'Account not found. Please check your email or contact IT support.');
      }
    } catch (e) {
      _showErrorMessage(
          'Network error. Please check your connection and try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleSsoLogin(String provider) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate SSO authentication
      await Future.delayed(Duration(milliseconds: 2000));

      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: Colors.white,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Text('$provider authentication successful!'),
            ],
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to student dashboard (default for SSO)
      await Future.delayed(Duration(milliseconds: 500));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/student-dashboard');
      }
    } catch (e) {
      _showErrorMessage('$provider authentication failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              CustomIconWidget(
                iconName: 'error',
                color: Colors.white,
                size: 5.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          duration: Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
