// lib/core/reusable_widgets/k_profile_image_picker.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../theme/app_colors.dart';

class KProfileImagePicker extends StatefulWidget {
  /// Selected image file
  final XFile? imageFile;

  /// Callback when image is selected
  final Function(XFile) onImageSelected;

  /// Label text below the avatar
  final String label;

  /// Avatar radius
  final double avatarRadius;

  /// Icon size
  final double iconSize;

  /// Background color of avatar
  final Color? backgroundColor;

  /// Icon color
  final Color? iconColor;

  /// Label text style
  final TextStyle? labelStyle;

  /// Whether to show loading indicator
  final bool isLoading;

  const KProfileImagePicker({
    super.key,
    required this.imageFile,
    required this.onImageSelected,
    this.label = "Upload Photo",
    this.avatarRadius = 55,
    this.iconSize = 50,
    this.backgroundColor,
    this.iconColor,
    this.labelStyle,
    this.isLoading = false,
  });

  @override
  State<KProfileImagePicker> createState() => _KProfileImagePickerState();
}

class _KProfileImagePickerState extends State<KProfileImagePicker> {
  final ImagePicker _picker = ImagePicker();

  // ============================================================================
  // PICK IMAGE METHODS
  // ============================================================================
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null && mounted) {
        widget.onImageSelected(pickedFile);
      }
    } catch (e) {
      _showError("Failed to pick image from gallery");
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (pickedFile != null && mounted) {
        widget.onImageSelected(pickedFile);
      }
    } catch (e) {
      _showError("Failed to capture image from camera");
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.danger,
      ),
    );
  }

  // ============================================================================
  // SHOW BOTTOM SHEET
  // ============================================================================
  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: AppColors.primary,
                ),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_camera,
                  color: AppColors.primary,
                ),
                title: const Text('Take Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImageFromCamera();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: AppColors.danger,
                ),
                title: Text(
                  'Remove Photo',
                  style: TextStyle(color: AppColors.danger),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Pass null to clear image
                  widget.onImageSelected(XFile(''));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================================
  // BUILD
  // ============================================================================
  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.backgroundColor ??
        AppColors.primary.withOpacity(0.1);
    final iconColor = widget.iconColor ?? AppColors.primary;

    return GestureDetector(
      onTap: widget.isLoading ? null : _showPickerOptions,
      child: Column(
        children: [
          Stack(
            children: [
              // Avatar
              CircleAvatar(
                radius: widget.avatarRadius,
                backgroundColor: backgroundColor,
                child: widget.isLoading
                    ? const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : widget.imageFile != null && widget.imageFile!.path.isNotEmpty
                    ? ClipOval(
                  child: Image.file(
                    File(widget.imageFile!.path),
                    width: widget.avatarRadius * 2,
                    height: widget.avatarRadius * 2,
                    fit: BoxFit.cover,
                  ),
                )
                    : Icon(
                  Icons.person,
                  size: widget.iconSize,
                  color: iconColor,
                ),
              ),

              // Edit Icon Overlay
              if (!widget.isLoading)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.imageFile != null && widget.imageFile!.path.isNotEmpty
                ? "Change Photo"
                : widget.label,
            style: widget.labelStyle ??
                TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
          ),
          if (widget.imageFile != null && widget.imageFile!.path.isNotEmpty)
            Text(
              "Tap to change",
              style: TextStyle(
                color: AppColors.textHint,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}

// ============================================================================
// SIMPLIFIED VERSION (Stateless)
// ============================================================================
class KProfileImagePickerSimple extends StatelessWidget {
  final XFile? imageFile;
  final Function(XFile) onImageSelected;
  final String label;
  final double avatarRadius;
  final double iconSize;
  final bool isLoading;

  const KProfileImagePickerSimple({
    super.key,
    required this.imageFile,
    required this.onImageSelected,
    this.label = "Upload Photo",
    this.avatarRadius = 55,
    this.iconSize = 50,
    this.isLoading = false,
  });

  void _showPickerOptions(BuildContext context) {
    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: AppColors.primary,
                ),
                title: const Text('Gallery'),
                onTap: () async {
                  final XFile? pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (pickedFile != null) onImageSelected(pickedFile);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_camera,
                  color: AppColors.primary,
                ),
                title: const Text('Camera'),
                onTap: () async {
                  final XFile? pickedFile = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (pickedFile != null) onImageSelected(pickedFile);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              if (imageFile != null)
                ListTile(
                  leading: Icon(
                    Icons.delete_outline,
                    color: AppColors.danger,
                  ),
                  title: Text(
                    'Remove Photo',
                    style: TextStyle(color: AppColors.danger),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onImageSelected(XFile(''));
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : () => _showPickerOptions(context),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: avatarRadius,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: isLoading
                    ? const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : imageFile != null && imageFile!.path.isNotEmpty
                    ? ClipOval(
                  child: Image.file(
                    File(imageFile!.path),
                    width: avatarRadius * 2,
                    height: avatarRadius * 2,
                    fit: BoxFit.cover,
                  ),
                )
                    : Icon(
                  Icons.person,
                  size: iconSize,
                  color: AppColors.primary,
                ),
              ),
              if (!isLoading)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            imageFile != null && imageFile!.path.isNotEmpty
                ? "Change Photo"
                : label,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}