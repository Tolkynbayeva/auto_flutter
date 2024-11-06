import 'package:flutter/material.dart';
import 'package:auto_flutter/screens/widgets/app_bar_subtitle.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_flutter/style/text_style.dart';
import 'package:auto_flutter/screens/widgets/custom_button.dart';
import 'package:hive/hive.dart';
import 'package:auto_flutter/models/car_model.dart';
import 'package:auto_flutter/models/trunk_item_model.dart';
import 'package:auto_flutter/screens/trunk/trunk_screen.dart';

class EditTrunkScreen extends StatefulWidget {
  final Car car;
  final String name;
  final String comment;
  final int trunkItemKey;

  const EditTrunkScreen({
    super.key,
    required this.car,
    required this.name,
    required this.comment,
    required this.trunkItemKey,
  });

  @override
  State<EditTrunkScreen> createState() => _EditTrunkScreenState();
}

class _EditTrunkScreenState extends State<EditTrunkScreen> {
  List<Car> _carList = [];
  Car? _selectedCar;
  late TextEditingController _nameController;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _selectedCar = widget.car;
    _nameController = TextEditingController(text: widget.name);
    _commentController = TextEditingController(text: widget.comment);
    _loadCarsFromDatabase();
  }

  Future<void> _loadCarsFromDatabase() async {
    final carBox = Hive.box<Car>('cars');
    setState(() {
      _carList = carBox.values.toList();
      if (_carList.isEmpty) {
        _selectedCar = null;
      } else if (!_carList.contains(_selectedCar)) {
        _carList.insert(0, _selectedCar!);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWithSubtitle(
        title: 'Редактирование',
        subtitle: 'Багажник',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCarDropdownField(
                      context,
                      label: 'Автомобиль',
                      value: _selectedCar,
                      items: _carList,
                      onChanged: (car) {
                        setState(() {
                          _selectedCar = car;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _nameController,
                      label: 'Название',
                      placeholder: 'Введите текст',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _commentController,
                      label: 'Комментарий',
                      placeholder: 'Введите текст',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            CustomButton(
              text: 'Готово',
              onPressed: () async {
                final trunkBox = Hive.box<TrunkItem>('trunkItems');

                final updatedTrunkItem = TrunkItem(
                  car: _selectedCar != null
                      ? '${_selectedCar!.brand} ${_selectedCar!.model}'
                      : '—',
                  name: _nameController.text,
                  comment: _commentController.text,
                );

                await trunkBox.put(widget.trunkItemKey, updatedTrunkItem);

                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AutoTextStyles.h4),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: AutoTextStyles.b1,
            border: const UnderlineInputBorder(),
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
          ),
          keyboardType: keyboardType,
        ),
      ],
    );
  }

  Widget _buildCarDropdownField(
    BuildContext context, {
    required String label,
    required Car? value,
    required List<Car> items,
    required ValueChanged<Car?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AutoTextStyles.h4),
        DropdownButtonFormField<Car>(
          value: value,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            isDense: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
          ),
          dropdownColor: Colors.white,
          icon: SvgPicture.asset('assets/img/svg/arow_dropdown_bottom.svg'),
          items: items.map((car) {
            return DropdownMenuItem<Car>(
              value: car,
              child: Text(
                '${car.brand} ${car.model}',
                style: AutoTextStyles.b1,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
