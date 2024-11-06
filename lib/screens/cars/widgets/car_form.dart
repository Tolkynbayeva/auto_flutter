import 'package:flutter/material.dart';
import 'package:auto_flutter/style/text_style.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:auto_flutter/screens/widgets/image_picker_widget.dart';
import 'package:auto_flutter/screens/widgets/custom_button.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

class CarForm extends StatefulWidget {
  final TextEditingController brandController;
  final TextEditingController modelController;
  final TextEditingController yearController;
  final TextEditingController colorController;
  final TextEditingController purchaseDateController;
  final TextEditingController mileageController;
  final String? initialImageFileName; 
  final Function(String? imageFileName) onImageSelected;
  final VoidCallback onSave;
  final String buttonText;

  const CarForm({
    Key? key,
    required this.brandController,
    required this.modelController,
    required this.yearController,
    required this.colorController,
    required this.purchaseDateController,
    required this.mileageController,
    required this.onImageSelected,
    required this.onSave,
    this.initialImageFileName,
    this.buttonText = 'Сохранить',
  }) : super(key: key);

  @override
  _CarFormState createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  String? fullImagePath;

  @override
  void initState() {
    super.initState();
    _initializeImagePath();
  }

  Future<void> _initializeImagePath() async {
    if (widget.initialImageFileName != null) {
      final directory = await getApplicationDocumentsDirectory();
      final possiblePath = path.join(directory.path, widget.initialImageFileName!);
      if (await File(possiblePath).exists()) {
        setState(() {
          fullImagePath = possiblePath;
        });
      } else {
        print('Файл не найден по пути: $possiblePath');
      }
    }
  }

  Future<String> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = path.basename(imagePath);
    final savedPath = path.join(directory.path, fileName);

    final tempImage = File(imagePath);
    if (await tempImage.exists()) {
      final savedImage = await tempImage.copy(savedPath);
      print('Изображение успешно сохранено по пути: $savedPath');
      return savedImage.path;
    } else {
      print('Временное изображение не найдено по пути: $imagePath');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImagePickerWidget(
          onImageSelected: (fileName) async {
            if (fileName != null) {
              final savedPath = await saveImagePermanently(fileName);
              setState(() {
                fullImagePath = savedPath;
              });
              widget.onImageSelected(path.basename(savedPath));
            }
          },
          imagePath: fullImagePath,
        ),
        const SizedBox(height: 16),
        _buildTextField("Марка", widget.brandController, isNumeric: false),
        _buildTextField("Модель", widget.modelController, allowAlphanumeric: true),
        _buildYearDropdown("Год выпуска", widget.yearController),
        _buildTextField("Цвет", widget.colorController, isNumeric: false),
        _buildDateFieldWithMask("Дата приобретения", widget.purchaseDateController),
        _buildTextField("Пробег (км)", widget.mileageController, isNumeric: true),
        const SizedBox(height: 20),
        CustomButton(
          text: widget.buttonText,
          onPressed: widget.onSave,
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumeric = false, bool allowAlphanumeric = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumeric
          ? [FilteringTextInputFormatter.digitsOnly]
          : allowAlphanumeric
              ? [
                  FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9а-яА-Я ]*$'))
                ]
              : [
                  FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Zа-яА-Я ]*$'))
                ],
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Введите текст',
        floatingLabelStyle: AutoTextStyles.h3,
        labelStyle: AutoTextStyles.h4,
        hintStyle: AutoTextStyles.b1,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Это поле обязательно для заполнения';
        }
        if (!_validateInput(value, isNumeric, allowAlphanumeric)) {
          return 'Некорректный ввод';
        }
        return null;
      },
    );
  }

  bool _validateInput(String input, bool isNumeric, bool allowAlphanumeric) {
    if (isNumeric) {
      return RegExp(r'^\d+$').hasMatch(input);
    } else if (allowAlphanumeric) {
      return RegExp(r'^[a-zA-Z0-9а-яА-Я ]+$').hasMatch(input);
    } else {
      return RegExp(r'^[a-zA-Zа-яА-Я ]+$').hasMatch(input);
    }
  }

  Widget _buildYearDropdown(String label, TextEditingController controller) {
    int currentYear = DateTime.now().year;
    List<int> years = List.generate(currentYear - 1990 + 1, (index) => currentYear - index);

    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Выберите год',
        labelStyle: AutoTextStyles.h4,
        floatingLabelStyle: AutoTextStyles.h3,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      ),
      value: controller.text.isNotEmpty ? int.tryParse(controller.text) : null,
      items: years.map((year) => DropdownMenuItem(value: year, child: Text(year.toString()))).toList(),
      onChanged: (int? newValue) {
        if (newValue != null) {
          controller.text = newValue.toString();
        }
      },
      icon: SvgPicture.asset('assets/img/svg/arow_dropdown_bottom.svg'),
      validator: (value) {
        if (value == null) {
          return 'Пожалуйста, выберите год';
        }
        return null;
      },
    );
  }

  Widget _buildDateFieldWithMask(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.datetime,
      inputFormatters: [
        MaskedInputFormatter('##.##.####'),
        FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')),
      ],
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Введите дату',
        labelStyle: AutoTextStyles.h4,
        floatingLabelStyle: AutoTextStyles.h3,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Это поле обязательно для заполнения';
        }
        return null;
      },
    );
  }
}