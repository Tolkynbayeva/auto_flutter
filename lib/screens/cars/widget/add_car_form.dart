import 'package:flutter/material.dart';
import 'package:auto_flutter/style/text_style.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:auto_flutter/models/car_model.dart';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'image_picker_widget.dart';
import 'package:auto_flutter/style/custom_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:auto_flutter/screens/cars/my_cars_screen.dart';

class AddCarForm extends StatefulWidget {
  final Box<Car> carBox;

  const AddCarForm({Key? key, required this.carBox}) : super(key: key);

  @override
  _AddCarFormState createState() => _AddCarFormState();
}

class _AddCarFormState extends State<AddCarForm> {
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _purchaseDateController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();

  String? _imagePath;

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    _purchaseDateController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  void _addCar() {
    if (_brandController.text.isEmpty ||
        _modelController.text.isEmpty ||
        _yearController.text.isEmpty ||
        _colorController.text.isEmpty ||
        _purchaseDateController.text.isEmpty ||
        _mileageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, заполните все поля')),
      );
      return;
    }

    final newCar = Car(
      brand: _brandController.text,
      model: _modelController.text,
      year: _yearController.text,
      color: _colorController.text,
      purchaseDate: _purchaseDateController.text,
      mileage: _mileageController.text,
      imagePath: _imagePath,
    );

    widget.carBox.add(newCar);
    _clearFields();
  }

  void _clearFields() {
    _brandController.clear();
    _modelController.clear();
    _yearController.clear();
    _colorController.clear();
    _purchaseDateController.clear();
    _mileageController.clear();
    setState(() => _imagePath = null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Добавьте ваш автомобиль", style: AutoTextStyles.h3),
        const SizedBox(height: 20.0),
        ImagePickerWidget(
          onImageSelected: (path) {
            setState(() => _imagePath = path);
          },
          imagePath: _imagePath,
        ),
        const SizedBox(height: 16),
        _buildTextField("Марка", _brandController),
        _buildTextField("Модель", _modelController),
        _buildYearDropdown("Год выпуска", _yearController),
        _buildTextField("Цвет", _colorController),
        _buildDateFieldWithMask("Дата приобретения", _purchaseDateController),
        _buildTextField("Пробег (км)", _mileageController, isNumeric: true),
        const SizedBox(height: 20),
        AddCarButton(onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyCarsPage()),
            (Route<dynamic> route) => false,
          );
        }),
        const SizedBox(height: 20),
        _buildCarList(),
      ],
    );
  }

  Widget _buildCarList() {
    return ValueListenableBuilder(
        valueListenable: widget.carBox.listenable(),
        builder: (context, Box<Car> box, _) {
          // if (box.values.isEmpty) {
          //   return Text("Нет сохраненных автомобилей", style: AutoTextStyles.h4);
          // } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final car = box.getAt(index);
              return ListTile(
                leading: car?.imagePath != null
                    ? Image.file(
                        File(car!.imagePath!),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.directions_car),
                title: Text('${car?.brand} ${car?.model}',
                    style: AutoTextStyles.h4),
                subtitle: Text('Год: ${car?.year}, Пробег: ${car?.mileage} км'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    box.deleteAt(index);
                  },
                ),
              );
            },
          );
        }
        // },
        );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumeric = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Введите текст',
        floatingLabelStyle: AutoTextStyles.h4,
        labelStyle: AutoTextStyles.h4,
        hintStyle: AutoTextStyles.b1,
        contentPadding: const EdgeInsets.all(10.0),
      ),
    );
  }

  Widget _buildYearDropdown(String label, TextEditingController controller) {
    int currentYear = DateTime.now().year;
    List<int> years = List.generate(50, (index) => currentYear - index);

    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Выберите год',
        labelStyle: AutoTextStyles.h4,
        contentPadding: const EdgeInsets.all(10.0),
      ),
      value: controller.text.isNotEmpty ? int.tryParse(controller.text) : null,
      items: years
          .map((year) => DropdownMenuItem(
                value: year,
                child: Text(year.toString()),
              ))
          .toList(),
      onChanged: (int? newValue) {
        setState(() {
          controller.text = newValue.toString();
        });
      },
      icon: SvgPicture.asset(
        'assets/img/svg/arow_dropdown_bottom.svg',
      ),
    );
  }

  Widget _buildDateFieldWithMask(
      String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.datetime,
      inputFormatters: [
        MaskedInputFormatter('##.##.####'),
      ],
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Введите дату',
        labelStyle: AutoTextStyles.h4,
        // errorText: _validateDate(controller.text) ? null : 'Неверная дата',
        contentPadding: const EdgeInsets.all(10.0),
      ),
      onChanged: (value) {
        setState(() {});
      },
    );
  }

  bool _validateDate(String date) {
    final datePattern = RegExp(r'^\d{2}\.\d{2}\.\d{4}$');
    if (!datePattern.hasMatch(date)) {
      return false;
    }

    try {
      final day = int.parse(date.substring(0, 2));
      final month = int.parse(date.substring(3, 5));
      final year = int.parse(date.substring(6, 10));
      final parsedDate = DateTime(year, month, day);
      return parsedDate.day == day &&
          parsedDate.month == month &&
          parsedDate.year == year;
    } catch (e) {
      return false;
    }
  }
}
