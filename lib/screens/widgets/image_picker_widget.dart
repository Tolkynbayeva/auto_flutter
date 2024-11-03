import 'package:auto_flutter/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerWidget extends StatelessWidget {
  final String? imagePath;
  final ValueChanged<String> onImageSelected;

  const ImagePickerWidget({
    super.key,
    required this.onImageSelected,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final ImagePicker _picker = ImagePicker();
        final XFile? image =
            await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) onImageSelected(image.path);
      },
      child: imagePath == null
          ? Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: const Color(0xFFD9D9D9),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    color: Colors.white,
                    'assets/img/svg/arrow.down.to.line.compact.svg',
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    "Загрузить изображение",
                    style: AutoTextStyles.h3.copyWith(color: Colors.white),
                  ),
                ],
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.file(
                File(imagePath!),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}
