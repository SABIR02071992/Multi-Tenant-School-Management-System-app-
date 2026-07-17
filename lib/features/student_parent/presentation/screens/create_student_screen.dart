import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vidya_setu/core/reusable_widgets/k_custom_loader.dart';
import 'package:vidya_setu/core/utils/form_validators.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/reusable_widgets/k_button.dart';
import '../../../../../../core/reusable_widgets/k_dropdown.dart';
import '../../../../core/constants/app_lists.dart';
import '../../../../core/reusable_widgets/k_date_picker.dart';
import '../../../../core/reusable_widgets/k_profile_image_picker.dart';
import '../../../../core/reusable_widgets/k_text_input_field.dart';
import '../../../../core/reusable_widgets/k_toolbar.dart';
import '../../../../core/theme/app_font_sizes.dart';
import '../../domain/entities/student_entity.dart';
import '../providers/classes_provider.dart';
import '../providers/create_student_provider.dart';
import '../widgets/add_class_dialog.dart';

class CreateStudentScreen extends ConsumerStatefulWidget {
  const CreateStudentScreen({super.key});

  @override
  ConsumerState<CreateStudentScreen> createState() =>
      _CreateStudentScreenState();
}

class _CreateStudentScreenState extends ConsumerState<CreateStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final bool _isLoading = false;

  final _admissionNoController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();

  // Parent Controllers
  final _fatherNameController = TextEditingController();
  final _fatherMobileController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _motherMobileController = TextEditingController();
  final _guardianNameController = TextEditingController();
  final _guardianMobileController = TextEditingController();
  final _addressController = TextEditingController();

  final _dobController = TextEditingController();
  final _admissionDateController = TextEditingController();

  String? _selectedGender;
  String? _selectedBloodGroup;
  String? _selectedClass;
  String? _selectedSection;
  String? _selectedSession;

  DateTime? _selectedDob;
  DateTime? _admissionDate;
  XFile? _selectedImage;

  @override
  void dispose() {
    _disposeControllers();
    _dobController.dispose();
    _admissionDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(getClassesProvider.notifier).getClasses();
    });
  }

  void _disposeControllers() {
    _admissionNoController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _fatherNameController.dispose();
    _fatherMobileController.dispose();
    _motherNameController.dispose();
    _motherMobileController.dispose();
    _guardianNameController.dispose();
    _guardianMobileController.dispose();
    _addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final classesState = ref.watch(getClassesProvider);

    return classesState.when(
      loading: () => const Scaffold(
        body: KCustomLoader(
          message: "Loading classes...",
        ),
      ),

      error: (error, stack) => Scaffold(
        appBar: const KAppBar(title: "Create Student"),
        body: Center(
          child: Text(error.toString()),
        ),
      ),

      data: (_) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: const KAppBar(title: "Create Student"),
          body: RefreshIndicator(
            onRefresh: () async {
              await ref.read(getClassesProvider.notifier).refresh();
            },
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: Column(
                  children: [
                    _buildPhotoPicker(),
                    const SizedBox(height: 25),
                    _buildPersonalInformation(),
                    const SizedBox(height: 25),
                    _buildAcademicInformation(),
                    const SizedBox(height: 25),
                    _buildParentInformation(),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomButton(),
        );
      },
    );
  }

  Widget _buildBottomButton() {
    final state = ref.watch(createStudentProvider);

    final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);

    return SafeArea(
      minimum: const EdgeInsets.all(16),
      child: KButton(
        isLoading: isLoading, // Use provider's loading state
        buttonText: "Save Student",
        onPressed: isLoading ? null : _handleSubmit,
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return KProfileImagePicker(
      imageFile: _selectedImage,
      label: "Upload Student Photo",
      avatarRadius: 55,
      iconSize: 50,
      isLoading: _isLoading,
      onImageSelected: (XFile image) {
        setState(() {
          // If image path is empty, it means remove photo
          if (image.path.isEmpty) {
            _selectedImage = null;
          } else {
            _selectedImage = image;
          }
        });

        // Show success message
        if (image.path.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Photo selected successfully!"),
              backgroundColor: AppColors.success,
              duration: Duration(seconds: 1),
            ),
          );
        }
      },
    );
  }

  Widget _buildPersonalInformation() {
    return _buildSection(
      icon: Icons.person,
      title: "Personal Information",
      children: [
        KTextField(
          controller: _admissionNoController,
          labelText: "Admission No",
          hintText: "Enter Admission No",
          prefixIcon: Icons.confirmation_number,
        ),
        const SizedBox(height: 18),
        KTextField(
          controller: _firstNameController,
          labelText: "First Name",
          hintText: "Enter First Name",
          prefixIcon: Icons.person,
        ),
        const SizedBox(height: 18),
        KTextField(
          controller: _lastNameController,
          labelText: "Last Name",
          hintText: "Enter Last Name",
          prefixIcon: Icons.person,
        ),
        const SizedBox(height: 18),
        _buildResponsiveRow(
          children: [_showGenderDialog1(), _buildDateOfBirthField()],
        ),
        _buildResponsiveRow(
          children: [_buildBloodGroupDropdown(), _buildMobileField()],
        ),
        _buildEmailField(),
      ],
    );
  }

  Widget _showGenderDialog1() {
    return KDropdown(
      labelText: "Select Gender",
      hintText: "Select Gender",
      prefixIcon: Icons.person,
      value: _selectedGender,
      items: AppLists.genders,
      onChanged: (value) => setState(() => _selectedGender = value),
      dialogHeightRatio: 0.30,
    );
  }

  Widget _buildDateOfBirthField() {
    return KDatePicker(
      controller: _dobController,
      labelText: "Date of Birth",
      hintText: "Select DOB",
      prefixIcon: Icons.calendar_month,
      isRequired: true,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
      onDateSelected: (date) {
        if (mounted) {
          setState(() {
            _selectedDob = date;
          });
        }
      },
    );
  }

  Widget _buildBloodGroupDropdown() {
    return KDropdown(
      labelText: "Blood Group",
      hintText: "Blood Group",
      prefixIcon: Icons.bloodtype,
      value: _selectedBloodGroup,
      items: AppLists.bloodGroups,
      onChanged: (value) => setState(() => _selectedBloodGroup = value),
      dialogHeightRatio: 0.40,
    );
  }

  Widget _buildMobileField() {
    return KTextField(
      controller: _mobileController,
      labelText: "Mobile Number",
      hintText: "Enter Mobile",
      keyboardType: TextInputType.phone,
      prefixIcon: Icons.phone,
      maxLength: 10,
      validator: KFormValidators.validateMobile,
    );
  }

  Widget _buildEmailField() {
    return KTextField(
      controller: _emailController,
      labelText: "Email",
      hintText: "Enter Email",
      keyboardType: TextInputType.emailAddress,
      prefixIcon: Icons.email,
      validator: KFormValidators.validateEmail,
    );
  }

  Widget _buildAcademicInformation() {
    return _buildSection(
      icon: Icons.school,
      title: "Academic Information",
      children: [
        _buildResponsiveRow(
          children: [
            _buildClassDropdown(),
            _buildSectionDropdown(),
          ],
        ),

        _buildResponsiveRow(
          children: [
            _buildSessionDropdown(),
            _buildAdmissionDateField(),
          ],
        ),
      ],
    );
  }

  Widget _buildClassDropdown() {
    final classesState = ref.watch(getClassesProvider);

    final classOptions = classesState.value
        ?.map((e) => e.className)
        .toList() ??
        [];

    return KDropdown(
      labelText: "Class",
      items: classOptions,
      value: _selectedClass,

      showAddButton: true,

      onAddPressed: () async {
        await _showAddClassDialog();
      },

      onChanged: (value) {
        setState(() {
          _selectedClass = value;
        });
      },
    );
  }

  Future<void> _showAddClassDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const CreateClassDialog(),
    );
  }

  Widget _buildSectionDropdown() {
    return KDropdown(
      labelText: "Section",
      hintText: "Select Section",
      prefixIcon: Icons.groups,
      value: _selectedSection,
      items: AppLists.sectionOptions,
      onChanged: (value) => setState(() => _selectedSection = value),
      dialogHeightRatio: 0.40,
    );
  }

  Widget _buildSessionDropdown() {
    return KDropdown(
      labelText: "Session",
      hintText: "Select Session",
      prefixIcon: Icons.calendar_today,
      value: _selectedSession,
      items: AppLists.sessionOptions,
      onChanged: (value) => setState(() => _selectedSession = value),
      dialogHeightRatio: 0.40,
    );
  }

  Widget _buildAdmissionDateField() {
    return KDatePicker(
      controller: _admissionDateController,
      labelText: "Admission Date",
      hintText: "Select Admission Date",
      prefixIcon: Icons.event,
      firstDate: DateTime(2015),
      lastDate: DateTime(2035),
      initialDate: DateTime.now(),
      onDateSelected: (date) {
        if (mounted) {
          setState(() {
            _admissionDate = date;
          });
        }
      },
    );
  }

  Widget _buildParentInformation() {
    return _buildSection(
      icon: Icons.family_restroom,
      title: "Parent Information",
      children: [
        _buildResponsiveRow(
          children: [
            KTextField(
              controller: _fatherNameController,
              labelText: 'Father Name',
              hintText: 'Enter Father Name',
              prefixIcon: Icons.person,
            ),
            KTextField(
              controller: _fatherMobileController,
              labelText: 'Father Mobile',
              hintText: 'Enter Father Mobile',
              prefixIcon: Icons.phone,
              maxLength: 10,
              validator: KFormValidators.validateMobile,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),

        _buildResponsiveRow(
          children: [
            KTextField(
              controller: _motherNameController,
              labelText: 'Mother Name',
              hintText: 'Enter Mother Name',
              prefixIcon: Icons.person,
            ),
            KTextField(
              controller: _motherMobileController,
              labelText: 'Mother Mobile',
              hintText: 'Enter Mother Mobile',
              prefixIcon: Icons.phone,
              maxLength: 10,
              validator: KFormValidators.validateMobile,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),

        _buildResponsiveRow(
          children: [
            KTextField(
              controller: _guardianNameController,
              labelText: 'Guardian Name',
              hintText: 'Enter Guardian Name',
              prefixIcon: Icons.person,
            ),
            KTextField(
              controller: _guardianMobileController,
              labelText: 'Guardian Mobile',
              hintText: 'Enter Guardian Mobile',
              prefixIcon: Icons.groups,
              maxLength: 10,
              validator: KFormValidators.validateMobile,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        KTextField(
          controller: _addressController,
          labelText: "Address",
          hintText: "Enter full address",
          maxLines: 3,
          maxLength: 250,
          showCharacterCount: true,
        ),
      ],
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: AppFontSizes.heading3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          ...children,
        ],
      ),
    );
  }

  Widget _buildResponsiveRow({required List<Widget> children}) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    if (children.isEmpty) return const SizedBox.shrink();
    if (children.length == 1) return children[0];

    if (isMobile) {
      return Column(
        children: children
            .map(
              (child) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: child,
              ),
            )
            .toList(),
      );
    }

    return Row(
      children: children
          .map((child) => Expanded(child: child))
          .toList()
          .asMap()
          .entries
          .map((entry) {
            final index = entry.key;
            final child = entry.value;
            return Row(
              children: [
                child,
                if (index < children.length - 1) const SizedBox(width: 16),
              ],
            );
          })
          .toList(),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      _createStudent();
    }
  }

  Future<void> _createStudent() async {
    try {
      // Create object of student entity
      final student = StudentEntity(
        admissionNo: _admissionNoController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        gender: _selectedGender,
        dob: _selectedDob?.toIso8601String().split('T').first,
        mobile: _mobileController.text.trim(),
        email: _emailController.text.trim(),
        fatherName: _fatherNameController.text.trim(),
        motherName: _motherNameController.text.trim(),
        className: _selectedClass!,
        section: _selectedSection!,
        address: _addressController.text.trim(),
        photo: _selectedImage != null && _selectedImage!.path.isNotEmpty
            ? _selectedImage!.path
            : null,
      );

      // API Call Here - This should trigger the loading state in the provider
      await ref.read(createStudentProvider.notifier).createStudent(student);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Student Created Successfully"),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }
}
