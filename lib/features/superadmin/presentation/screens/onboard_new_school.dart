import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vidya_setu/core/reusable_widgets/k_button.dart';
import 'package:vidya_setu/core/reusable_widgets/k_dropdown.dart';
import 'package:vidya_setu/core/reusable_widgets/k_text_input_field.dart';
import '../../../../core/reusable_widgets/k_toolbar.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entity/super_admin_entity.dart';
import '../providers/school_onboard_state_provider.dart';

class OnBoardNewSchoolCollege extends ConsumerStatefulWidget {
  const OnBoardNewSchoolCollege({super.key});

  @override
  ConsumerState<OnBoardNewSchoolCollege> createState() =>
      _SchoolSetupScreenState();
}

class _SchoolSetupScreenState extends ConsumerState<OnBoardNewSchoolCollege> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _domainController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _selectedPlan = 'Basic';
  File? _selectedLogo;

  final List<String> _plans = ['Basic', 'Standard', 'Premium'];

  @override
  void dispose() {
    _nameController.dispose();
    _domainController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedLogo = File(image.path));
    }
  }

  Future<void> _submitSetupData() async {
    if (!_formKey.currentState!.validate() || _selectedLogo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload logo image and fill data arrays'),),
      );
      return;
    }

    await ref
        .read(schoolProvider.notifier)
        .onboardSchool(
          schoolName: _nameController.text.trim(),
          domain: _domainController.text.trim(),
          adminEmail: _emailController.text.trim(),
          planSetup: _selectedPlan,
          logoFilePath: _selectedLogo!.path,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final schoolState = ref.watch(schoolProvider);

    ref.listen<AsyncValue<List<SchoolEntity>>>(schoolProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        data: (school) {
          if (school != null) {
            AppSnackBar.showSuccessSnackBar(
              context: context,
              title: 'Success',
              message: school.first.message ?? 'School added successfully',
            );

            _formKey.currentState?.reset();

            _nameController.clear();
            _domainController.clear();
            _emailController.clear();

            setState(() {
              _selectedLogo = null;
            });

            Navigator.pop(context);
          }
        },

        error: (error, stackTrace) {
          AppSnackBar.showErrorSnackBar(
            context: context,
            title: 'Server Error',
            message: error.toString(),
          );
        },
      );
    });

    // Check the state loading or not
    final isLoading = schoolState.isLoading;

    return Scaffold(
      appBar: KAppBar(title: l10n.newSchoolOnboard, showBackButton: true),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1E3A8A)),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: _pickLogo,
                      child: Container(
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: _selectedLogo != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  _selectedLogo!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 44,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Tap to Upload School Logo',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    /// School Name
                    KTextField(
                      controller: _nameController,
                      labelText: l10n.schoolName,
                      prefixIcon: Icons.school_outlined,
                    ),
                    const SizedBox(height: 16),

                    /// School Domain
                    KTextField(
                      controller: _domainController,
                      labelText: l10n.schoolDomain,
                      prefixIcon: Icons.link_outlined,
                    ),
                    const SizedBox(height: 16),

                    /// Admin Email
                    KTextField(
                      controller: _emailController,
                      labelText: l10n.adminEmail,
                      prefixIcon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 16),

                    KDropdown(
                      labelText: l10n.allocatedPackage,
                      hintText: l10n.allocatedPackage,
                      prefixIcon: Icons.workspace_premium_outlined,
                      value: _selectedPlan,
                      items: _plans,
                      onChanged: (value) {
                        setState(() {
                          _selectedPlan = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    KButton(
                      isLoading: false,
                      onPressed: _submitSetupData,
                      buttonText: l10n.btnAddSchool,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
