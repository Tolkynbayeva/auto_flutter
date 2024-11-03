import 'package:flutter/material.dart';
import 'package:auto_flutter/models/car_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:auto_flutter/style/text_style.dart';
import 'car_form.dart';

class AddCarForm extends StatefulWidget {
  const AddCarForm({Key? key}) : super(key: key);

  @override
  _AddCarFormState createState() => _AddCarFormState();
}

class _AddCarFormState extends State<AddCarForm> {
  final _formKey = GlobalKey<FormState>();

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
    if (_formKey.currentState!.validate()) {
      final newCar = Car(
        brand: _brandController.text,
        model: _modelController.text,
        year: _yearController.text,
        color: _colorController.text,
        purchaseDate: _purchaseDateController.text,
        mileage: _mileageController.text,
        imagePath: _imagePath,
      );

      final carBox = Hive.box<Car>('cars');
      final newKey = carBox.add(newCar);

      _clearFields();

      Navigator.pop(context, newKey);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Пожалуйста, заполните все обязательные поля'),),
      );
    }
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Добавьте ваш автомобиль", style: AutoTextStyles.h3),
              const SizedBox(height: 20.0),
              CarForm(
                brandController: _brandController,
                modelController: _modelController,
                yearController: _yearController,
                colorController: _colorController,
                purchaseDateController: _purchaseDateController,
                mileageController: _mileageController,
                imagePath: _imagePath,
                onImageSelected: (path) {
                  setState(() => _imagePath = path);
                },
                onSave: _addCar,
                buttonText: 'Добавить автомобиль',
              ),
            ],
          ),
        ),
      ),
    );
  }
}