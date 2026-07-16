import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/core/reusable_widgets/k_button.dart';
import 'package:vidya_setu/core/reusable_widgets/k_text_input_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/utils/form_validators.dart';
import '../../../../core/utils/locale_provider.dart';
import 'package:vidya_setu/l10n/generated/app_localizations.dart';
import '../providers/auth_state_provider.dart';
import '../../../schooladmin/presentation/screens/school_admin_main_screen.dart';
import '../../../student_parent/presentation/screens/parent_student_dashboard.dart';
import '../../../superadmin/presentation/screens/super_admin_dashboard.dart';
import '../../../teacher/presentation/screens/teacher_main_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  // Selected domain to previous screen
  final String? schoolDomain;
  const LoginScreen({super.key, this.schoolDomain});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ref.read(authProvider.notifier).loginUser(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      schoolDomain: widget.schoolDomain,
    );
  }
  void _goTo(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => screen),
          (Route<dynamic> route) => false,
    );
  }

  void _navigateBasedOnRole(BuildContext context, String? userRole) {
    if (userRole == null ||
        userRole.trim().isEmpty ||
        userRole.toLowerCase() == 'super_admin') {
      _goTo(context, const SuperAdminDashboard());
      return;
    }

    final role = userRole.trim();

    if (role == 'School Admin') {
      _goTo(context, const SchoolAdminMainScreen());
    } else if (role == 'Teacher' || role == 'faculty') {
      _goTo(context, const TeacherMainScreen());
    } else if (role == 'Student' || role == 'Parent') {
      _goTo(context, const ParentStudentDashboard());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid Role!: $userRole')),
      );
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
          if (user != null && context.mounted) {
             AppSnackBar.showSuccessSnackBar(context: context, title: l10n.welcome, message: user.name);
            _navigateBasedOnRole(context, user.role);
          }
        },
        error: (error, stackTrace) {
          if (context.mounted) {
            AppSnackBar.showErrorSnackBar(context: context, title: l10n.welcome, message: error.toString());
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
                icon: const Icon(Icons.arrow_back, color: AppColors.primary),
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
                color: AppColors.primary,
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
                      Icon(Icons.translate, size: 20, color: AppColors.grey),
                      SizedBox(width: 8),
                      Text('English'),
                    ],
                  ),
                ),
                const PopupMenuItem<Locale>(
                  value: Locale('hi'),
                  child: Row(
                    children: [
                      Icon(Icons.translate, size: 20, color: AppColors.grey),
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
          child: Form(
            key: _formKey,
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.school, size: 80, color: AppColors.primary),
              const SizedBox(height: 12),
              const Text(
                'EdConnect',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
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
                style: const TextStyle(fontSize: 14, color: AppColors.grey),
              ),
              const SizedBox(height: 40),

              /// Email input
              KTextField(
                controller: _emailController,
                labelText: l10n.enterEmail,
                prefixIcon: Icons.email_outlined,
                textInputAction: TextInputAction.done,
                validator: KFormValidators.validateEmail,
              ),

              const SizedBox(height: 16),

              /// Password input
              KTextField(
                controller: _passwordController,
                labelText: l10n.enterPassword,
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                textInputAction: TextInputAction.done,
                validator: KFormValidators.validatePassword,
              ),
              const SizedBox(height: 24),

              /// Button
              KButton(
                isLoading: isLoading,
                buttonText: l10n.loginButton,
                onPressed: isLoading ? null : _login,
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}
