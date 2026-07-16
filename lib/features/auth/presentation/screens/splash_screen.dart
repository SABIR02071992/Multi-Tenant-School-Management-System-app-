import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/internet_service.dart';
import '../../../../core/utils/local_storage.dart';
import '../../../schooladmin/presentation/screens/school_admin_main_screen.dart';
import '../../../select_school/presentation/screen/select_school_college.dart';
import '../../../student_parent/presentation/screens/parent_student_dashboard.dart';
import '../../../superadmin/presentation/screens/super_admin_dashboard.dart';
import '../../../teacher/presentation/screens/teacher_main_screen.dart';
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

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.6, curve: Curves.easeIn)),
    );

    _slideAnimation = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
    _startSessionCheck();
  }

 /* Future<void> _startSessionCheck() async {
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
  }*/
  Future<void> _startSessionCheck() async {
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    // Wail still internet connection is available
    while (mounted && !(await InternetService.instance.hasInternet())) {
      await Future.delayed(const Duration(seconds: 1));
    }

    if (!mounted) return;

    final storage = LocalStorageService();
    final bool isLoggedIn = storage.getLoginStatus() ?? false;
    final String? savedRole = storage.getRole();

    if (isLoggedIn && savedRole != null) {
      _openScreenBasedOnRole(storage);
    } else {
      _navigateTo(const SelectCollegeScreen());
    }
  }

  void _navigateTo(Widget targetScreen) {
    if (!mounted) return;
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
      _navigateTo(const SchoolAdminMainScreen());
    } else if (role == 'Teacher') {
      _navigateTo(const TeacherMainScreen());
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
