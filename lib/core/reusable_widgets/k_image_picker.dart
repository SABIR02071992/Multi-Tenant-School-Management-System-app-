import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class KImagePicker extends StatelessWidget {
  final XFile? imageFile;
  final Function(XFile) onImageSelected;
  final String label;

  const KImagePicker({
    super.key,
    required this.imageFile,
    required this.onImageSelected,
    this.label = "Select Image",
  });

  // Camera ya Gallery select karne ke liye Bottom Sheet dialog
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
                leading: const Icon(Icons.photo_library, color: Color(0xFF1E3A8A)),
                title: const Text('Gallery'),
                onTap: () async {
                  final XFile? pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80, // Image size compress karne ke liye
                  );
                  if (pickedFile != null) onImageSelected(pickedFile);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera, color: Color(0xFF1E3A8A)),
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
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showPickerOptions(context),
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: imageFile != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(imageFile!.path),
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            )
                : const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo, size: 40, color: Color(0xFF1E3A8A)),
                SizedBox(height: 8),
                Text(
                  "Tap to upload image",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
