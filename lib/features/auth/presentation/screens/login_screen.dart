import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/core/reusable_widgets/k_text_input_field.dart';
import '../../../../core/utils/form_validators.dart';
import '../../../../core/utils/locale_provider.dart';
import 'package:vidya_setu/l10n/generated/app_localizations.dart';
import '../providers/auth_state_provider.dart';
import '../../../schooladmin/presentation/screens/school_admin_dashboard.dart';
import '../../../student_parent/parent_dashboard.dart';
import '../../../superadmin/presentation/screens/super_admin_dashboard.dart';
import '../../../teacher/presentation/teacher_dashboard.dart';

class LoginScreen extends ConsumerStatefulWidget {
  // Select College Screen se chuney gaye college ka domain pass hoga.
  // Agar koi seedhe Super Admin portal daba kar aaya hai toh ye null hoga.
  final String? schoolDomain;

  const LoginScreen({super.key, this.schoolDomain});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Backend se jo role milega, uske according automatic dynamic navigate hoga
  void _navigateBasedOnRole(BuildContext context, String? userRole) {
    if (userRole == null ||
        userRole.trim().isEmpty ||
        userRole.toLowerCase() == 'super_admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SuperAdminDashboard()),
      );
      return;
    }

    String roleClean = userRole.toLowerCase().trim();

    if (roleClean.contains('School Admin')) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SchoolAdminDashboard()),
      );
    } else if (roleClean.contains('Teacher') || roleClean.contains('faculty')) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TeacherDashboard()),
      );
    } else if (roleClean.contains('Student') || roleClean.contains('parent')) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ParentDashboard()),
      );
    } else {
      // Security alert
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid Role!: $userRole')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);

    final isLoading = authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    ref.listen(authProvider, (previous, next) {
      next.maybeWhen(
        data: (user) {
          log("#Role: ${user?.role}");
          if (user != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${l10n.welcome}, ${user.name}!')),
            );
            _navigateBasedOnRole(context, user.role);
          }
        },
        error: (error, stackTrace) {
          log("#Role: ${error.toString()}");
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${l10n.error}: ${error.toString()}')),
            );
          }
        },
        orElse: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.schoolDomain != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1E3A8A)),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 8.0),
            child: PopupMenuButton<Locale>(
              icon: const Icon(
                Icons.language,
                size: 32,
                color: Color(0xFF1E3A8A),
              ),
              tooltip: 'Change Language',
              initialValue: currentLocale,
              onSelected: (Locale newLocale) {
                ref.read(localeProvider.notifier).state = newLocale;
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
                const PopupMenuItem<Locale>(
                  value: Locale('en'),
                  child: Row(
                    children: [
                      Icon(Icons.translate, size: 20, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('English'),
                    ],
                  ),
                ),
                const PopupMenuItem<Locale>(
                  value: Locale('hi'),
                  child: Row(
                    children: [
                      Icon(Icons.translate, size: 20, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('हिंदी (Hindi)'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.school, size: 80, color: Color(0xFF1E3A8A)),
              const SizedBox(height: 12),
              const Text(
                'EdConnect',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                ),
              ),

              // Informative Badge for user context
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  widget.schoolDomain != null
                      ? "Portal: ${widget.schoolDomain!.toUpperCase()}"
                      : "Central System: SUPER ADMIN",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.schoolDomain != null
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Text(
                l10n.appSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              /// Email input
              KTextField(
                controller: _emailController,
                labelText: l10n.enterEmail,
                prefixIcon: Icons.email_outlined,
                textInputAction: TextInputAction.done,
                validator: KFormValidators.validatePassword,
              ),

              const SizedBox(height: 16),

              /// Password input
              KTextField(
                controller: _passwordController,
                labelText: l10n.enterPassword,
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                // 🟢 Toggles standard obscure mode & eye visibility icon layout
                textInputAction: TextInputAction.done,
                validator: KFormValidators.validatePassword,
              ),
              const SizedBox(height: 24),
              /// Login Button

              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        // Final Action call with fixed parameters
                        ref
                            .read(authProvider.notifier)
                            .loginUser(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                              schoolDomain: widget
                                  .schoolDomain,
                            );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        l10n.loginButton,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
