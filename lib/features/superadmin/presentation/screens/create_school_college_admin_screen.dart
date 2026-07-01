import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/reusable_widgets/k_button.dart';
import '../../../../core/reusable_widgets/k_text_input_field.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/utils/form_validators.dart';
import '../providers/create_school_college_admin_state_provider.dart';

class CreateSchoolCollegeAdminScreen extends ConsumerStatefulWidget {
  final String
  schoolDomain; // Domain ya ID jo aap dashboard / select item se layenge

  const CreateSchoolCollegeAdminScreen({super.key, required this.schoolDomain});

  @override
  ConsumerState<CreateSchoolCollegeAdminScreen> createState() =>
      _CreateSchoolCollegeAdminScreenState();
}

class _CreateSchoolCollegeAdminScreenState
    extends ConsumerState<CreateSchoolCollegeAdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(schoolCollegeAdminProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create School Admin",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0F172A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "School Domain: ${widget.schoolDomain}",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 16),

              // Admin Full Name Field
              KTextField(
                controller: _nameController,
                labelText: 'Admin Full Name',
                prefixIcon: Icons.person,
                validator: KFormValidators.validateAdminName,
              ),

              const SizedBox(height: 16),

              // Admin Email Field
              KTextField(
                controller: _emailController,
                labelText: 'Admin Email Address',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                // 🟢 Set email keyboard
                validator: KFormValidators.validateEmail,
              ),
              const SizedBox(height: 16),

              // Admin Phone Number Field
              KTextField(
                controller: _phoneController,
                labelText: 'Admin Phone Number',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                // 🟢 Set phone keyboard
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                  // Strict 10 digits filter check
                ],
                validator: KFormValidators.validateMobile,
              ),
              const SizedBox(height: 16),

              KTextField(
                controller: _passwordController,
                labelText: 'Enter New Password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                // 🟢 Toggles standard obscure mode & eye visibility icon layout
                textInputAction: TextInputAction.done,
                validator: KFormValidators.validatePassword,
              ),

              const SizedBox(height: 32),

              // Reusable Button Implementation
              // Reusable Button Implementation Section inside your Form Column
              SizedBox(
                width: double.infinity,
                child: KButton(
                  isLoading: isLoading,
                  buttonText: "Generate & Send Credentials",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final String? resultMessage = await ref
                          .read(schoolCollegeAdminProvider.notifier)
                          .createNewUserForSchoolCollegeAdmin(
                            fullName: _nameController.text.trim(),
                            email: _emailController.text.trim(),
                            phone: _phoneController.text.trim(),
                            schoolDomain: widget.schoolDomain,
                            password: _passwordController.text.trim(),
                          );

                      if (context.mounted && resultMessage != null) {
                        if (resultMessage.startsWith("Error:")) {
                          // 🔴 FAILURE WORKFLOW
                          final String executionError = resultMessage
                              .replaceFirst("Error: ", "");

                          AppSnackBar.showErrorSnackBar(
                            context: context, // 🟢 Native context passed
                            title: 'Error',
                            message: executionError,
                          );
                        } else {
                          // 🟢 SUCCESS WORKFLOW
                          AppSnackBar.showSuccessSnackBar(
                            context: context, // 🟢 Native context passed
                            title: 'Success',
                            message:
                                resultMessage, // Backend ka exact message show hoga
                          );

                          // 🟢 IMMEDIATE POP: Bina kisi framework clash ke screen instant pop ho jayegi
                          Navigator.pop(context);
                        }
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
