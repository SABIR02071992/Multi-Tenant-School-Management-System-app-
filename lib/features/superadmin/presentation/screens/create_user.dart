import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/reusable_widgets/k_button.dart';
import '../../../../core/reusable_widgets/k_dropdown.dart';
import '../../../../core/reusable_widgets/k_text_input_field.dart';
import '../../../../core/reusable_widgets/k_toolbar.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/utils/form_validators.dart';
import '../providers/create_school_college_admin_state_provider.dart';

class CreateNewUser extends ConsumerStatefulWidget {
  final String
  schoolDomain;

  const CreateNewUser({super.key, required this.schoolDomain});

  @override
  ConsumerState<CreateNewUser> createState() =>
      _CreateSchoolCollegeAdminScreenState();
}

class _CreateSchoolCollegeAdminScreenState
    extends ConsumerState<CreateNewUser> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String? selectedRole;

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
      appBar: KAppBar(title: 'Create User',showBackButton: true,),
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

              /// User Full Name Field
              KTextField(
                controller: _nameController,
                labelText: 'User Full Name',
                prefixIcon: Icons.person,
                validator: KFormValidators.validateAdminName,
              ),
              const SizedBox(height: 16),

              /// Email Field
              KTextField(
                controller: _emailController,
                labelText: 'User Email Address',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: KFormValidators.validateEmail,
              ),
              const SizedBox(height: 16),

              /// Mobile Number Field
              KTextField(
                controller: _phoneController,
                labelText: 'User Phone Number',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: KFormValidators.validateMobile,
              ),
              const SizedBox(height: 16),

              /// Role Dropdown
              KDropdown(
                labelText: "Role",
                hintText: "Select Role",
                prefixIcon: Icons.person,
                value: selectedRole,
                items: const [
                  "---Select Role---",
                  "School Admin",
                  "Teacher",
                  "Parent",
                  "Student",
                ],
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              /// Password Field
              KTextField(
                controller: _passwordController,
                labelText: 'Enter New Password',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                textInputAction: TextInputAction.done,
                validator: KFormValidators.validatePassword,
              ),
              const SizedBox(height: 32),

              /// Button
              SizedBox(
                width: double.infinity,
                child: KButton(
                  isLoading: isLoading,
                  buttonText: "Create User & Send Credentials",
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
                            role: selectedRole ?? "",
                          );

                      if (context.mounted && resultMessage != null) {
                        if (resultMessage.startsWith("Error:")) {
                          final String executionError = resultMessage
                              .replaceFirst("Error: ", "");

                          AppSnackBar.showErrorSnackBar(
                            context: context,
                            title: 'Error',
                            message: executionError,
                          );
                        } else {
                          AppSnackBar.showSuccessSnackBar(
                            context: context,
                            title: 'Success',
                            message: resultMessage,
                          );
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
