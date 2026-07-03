import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/local_storage.dart';
import '../../../schooladmin/presentation/screens/school_admin_dashboard.dart';
import '../../../select_school/presentation/screen/select_school_college.dart';
import '../../../student_parent/parent_dashboard.dart';
import '../../../superadmin/presentation/screens/super_admin_dashboard.dart';
import '../../../teacher/presentation/teacher_dashboard.dart';
import 'login_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // 🟢 1. Animation Controller Setup (Duration: 2 Seconds)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // 🟢 2. Custom Curves aur Tweens Define Kiye Hain Smoothness Ke Liye
    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.6, curve: Curves.easeIn)),
    );

    _slideAnimation = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    // Animation shuru karein
    _animationController.forward();

    // 🟢 3. Background Session Checking Aur Navigation Routing
    _startSessionCheck();
  }

  Future<void> _startSessionCheck() async {
    // 2.5 seconds ka wait karenge taaki animations poore dikhein aur premium feel aaye
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    final storage = LocalStorageService();
    final bool isLoggedIn = storage.getLoginStatus() ?? false;
    final String? savedRole = storage.getRole();
    final String? savedDomain = storage.getDomain();

    if (isLoggedIn && savedRole != null) {
      _openScreenBasedOnRole(storage);
    } else {
      _navigateTo(const SelectCollegeScreen());
    }
  }

  void _navigateTo(Widget targetScreen) {
    if (!mounted) return;
    // Premium Fade-Transition ke sath agli screen par bhejna bina kisi jhatke ke
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => targetScreen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background banaya hai premium luxury look ke liye
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF0F172A)], // Royal Blue to Dark Navy
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // 🟢 ANIMATED BRAND LOGO ICON
                  Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        size: 90,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 🟢 ANIMATED APP NAME TEXT
                  Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: const Column(
                      children: [
                        Text(
                          'EdConnect',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Manage Multiple Campuses Seamlessly',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white60,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // 🟢 PRETTY BOTTOM PROGRESS INDICATOR & COPYRIGHT NOTICE
                  Column(
                    children: [
                      const SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          color: Colors.white70,
                          strokeWidth: 2.5,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Powered by Multi-Tenant Architecture',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.4),
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _openScreenBasedOnRole(LocalStorageService storage) {
    final role = storage.getRole();//?.toLowerCase().trim();
    if(role == null || role.isEmpty){
      SelectCollegeScreen();
      return ;
    }

   if (role == 'School Admin') {
      _navigateTo(const SchoolAdminDashboard());
    } else if (role == 'Teacher') {
      _navigateTo(const TeacherDashboard());
    } else if (role == 'Student') {
      _navigateTo(const ParentStudentDashboard());
    } else if (role == 'Parent') {
     _navigateTo(const ParentStudentDashboard());
   }
   else {
      _navigateTo(const SuperAdminDashboard());
    }
  }
}
