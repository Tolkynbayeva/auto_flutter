import 'package:flutter/material.dart';
import 'package:auto_flutter/models/car_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:auto_flutter/style/text_style.dart';
import 'package:auto_flutter/screens/widgets/custom_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class EditCarForm extends StatefulWidget {
  final Car car;
  final dynamic carKey;

  const EditCarForm({Key? key, required this.car, required this.carKey})
      : super(key: key);

  @override
  _EditCarFormState createState() => _EditCarFormState();
}

class _EditCarFormState extends State<EditCarForm> {
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _colorController;
  late TextEditingController _purchaseDateController;
  late TextEditingController _mileageController;
  String? _imagePath;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _brandController = TextEditingController(text: widget.car.brand);
    _modelController = TextEditingController(text: widget.car.model);
    _yearController = TextEditingController(text: widget.car.year);
    _colorController = TextEditingController(text: widget.car.color);
    _purchaseDateController = TextEditingController(text: widget.car.purchaseDate);
    _mileageController = TextEditingController(text: widget.car.mileage);
    _imagePath = widget.car.imageFileName;
  }

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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedFile != null) {
      final savedPath = await saveImagePermanently(pickedFile.path);
      setState(() {
        _imagePath = savedPath;
      });
    }
  }

  void _saveCar() {
    if (_formKey.currentState!.validate()) {
      final updatedCar = Car(
        brand: _brandController.text,
        model: _modelController.text,
        year: _yearController.text,
        color: _colorController.text,
        purchaseDate: _purchaseDateController.text,
        mileage: _mileageController.text,
        imageFileName: _imagePath,
      );

      final carBox = Hive.box<Car>('cars');
      carBox.put(widget.carKey, updatedCar);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.file(
                        File(_imagePath!),
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            color: Colors.grey,
                            child: Center(
                              child: Text(
                                'Ошибка загрузки изображения',
                                style: AutoTextStyles.h4,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      height: 200,
                      color: Colors.grey.shade300,
                      child: Center(
                        child: Text(
                          'Нажмите, чтобы добавить изображение',
                          style: AutoTextStyles.h4,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _brandController,
              label: 'Марка',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите марку автомобиля';
                }
                return null;
              },
            ),
            _buildTextField(
              controller: _modelController,
              label: 'Модель',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите модель автомобиля';
                }
                return null;
              },
            ),
            _buildTextField(
              controller: _yearController,
              label: 'Год выпуска',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите год выпуска';
                }
                return null;
              },
            ),
            _buildTextField(
              controller: _colorController,
              label: 'Цвет',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите цвет автомобиля';
                }
                return null;
              },
            ),
            _buildTextField(
              controller: _purchaseDateController,
              label: 'Дата приобретения',
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.tryParse(_purchaseDateController.text) ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  setState(() {
                    _purchaseDateController.text = 
                        "${pickedDate.day.toString().padLeft(2, '0')}.${pickedDate.month.toString().padLeft(2, '0')}.${pickedDate.year}";
                  });
                }
              },
              readOnly: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите дату приобретения';
                }
                return null;
              },
            ),
            _buildTextField(
              controller: _mileageController,
              label: 'Пробег (км)',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Введите пробег';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Сохранить',
              onPressed: _saveCar,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    FormFieldValidator<String>? validator,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          label,
          style: AutoTextStyles.h4,
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          onTap: onTap,
          readOnly: readOnly,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
          ),
        ),
      ],
    );
  }
}