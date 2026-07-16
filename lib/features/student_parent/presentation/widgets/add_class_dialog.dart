import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidya_setu/core/utils/form_validators.dart';

import '../../../../core/reusable_widgets/k_button.dart';
import '../../../../core/reusable_widgets/k_text_input_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../domain/entities/classes_entity.dart';
import '../providers/classes_provider.dart';

class CreateClassDialog extends ConsumerStatefulWidget {
  const CreateClassDialog({super.key});

  @override
  ConsumerState<CreateClassDialog> createState() => _CreateClassDialogState();
}

class _CreateClassDialogState extends ConsumerState<CreateClassDialog> {
  final _formKey = GlobalKey<FormState>();
  final _classNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _classNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🔴 1. Listen for changes to trigger Pop or Snackbars
    ref.listen(createClassesProvider, (previous, next) {
      next.whenOrNull(
        data: (successData) async {
          if (successData != null) {
            Navigator.pop(context);
            // Refresh classes list
            await ref.read(getClassesProvider.notifier).getClasses();
            AppSnackBar.showSuccessSnackBar(
              context: context,
              title: "Success",
              message: "Class created successfully.",
            );

            // Reset create state
            ref.read(createClassesProvider.notifier).reset();
          }
        },
        error: (error, stackTrace) {
          Navigator.pop(context);
          AppSnackBar.showErrorSnackBar(
            context: context,
            title: "Error",
            message: error.toString(),
          );
        },
      );
    });

    // Watch the state for loading button indicator
    final state = ref.watch(createClassesProvider);
    final isLoading = state.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    return Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withOpacity(.08),
                child: const Icon(
                  Icons.class_,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Add New Class",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Create a new class for your school.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              KTextField(
                controller: _classNameController,
                labelText: "Class Name",
                hintText: "e.g. MCA",
                prefixIcon: Icons.class_,
              ),
              const SizedBox(height: 16),
              KTextField(
                controller: _descriptionController,
                labelText: "Description",
                hintText: "Optional",
                prefixIcon: Icons.description,
                maxLines: 1,
                validator: (value){
                  return null;
                },
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: KButton(
                      isLoading: false,
                      buttonText: "Cancel",
                      backgroundColor: AppColors.danger,
                      onPressed: isLoading
                          ? null
                          : () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: KButton(
                      isLoading: isLoading,
                      buttonText: "Save",
                      backgroundColor: AppColors.success,
                      onPressed: isLoading
                          ? null
                          : () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        final entity = ClassEntity(
                          className: _classNameController.text.trim(),
                          description: _descriptionController.text.trim(),
                        );

                        await ref
                            .read(createClassesProvider.notifier)
                            .createClasses(entity);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
