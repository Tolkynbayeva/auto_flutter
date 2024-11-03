import 'package:flutter/material.dart';
import 'package:auto_flutter/style/text_style.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:auto_flutter/screens/widgets/image_picker_widget.dart';
import 'package:auto_flutter/screens/widgets/custom_button.dart';
import 'package:flutter/services.dart';

class CarForm extends StatelessWidget {
  final TextEditingController brandController;
  final TextEditingController modelController;
  final TextEditingController yearController;
  final TextEditingController colorController;
  final TextEditingController purchaseDateController;
  final TextEditingController mileageController;
  final String? imagePath;
  final Function(String? imagePath) onImageSelected;
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
    this.imagePath,
    this.buttonText = 'Сохранить',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImagePickerWidget(
          onImageSelected: onImageSelected,
          imagePath: imagePath,
        ),
        const SizedBox(height: 16),
        _buildTextField("Марка", brandController, isNumeric: false),
        _buildTextField("Модель", modelController, isNumeric: false),
        _buildYearDropdown("Год выпуска", yearController),
        _buildTextField("Цвет", colorController, isNumeric: false),
        _buildDateFieldWithMask("Дата приобретения", purchaseDateController),
        _buildTextField("Пробег (км)", mileageController, isNumeric: true),
        const SizedBox(height: 20),
        CustomButton(
          text: buttonText,
          onPressed: onSave,
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumeric = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumeric
          ? [FilteringTextInputFormatter.digitsOnly]
          : [FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Zа-яА-Я ]*$'))],
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
        if (!_validateInput(value, isNumeric)) {
          return 'Некорректный ввод';
        }
        return null;
      },
    );
  }

  bool _validateInput(String input, bool isNumeric) {
    if (isNumeric) {
      return RegExp(r'^\d+$').hasMatch(input);
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