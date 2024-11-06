import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:auto_flutter/models/car_model.dart';
import 'package:auto_flutter/models/trunk_item_model.dart';
import 'preview_trunk_screen.dart';
import 'package:auto_flutter/style/text_style.dart';
import '../widgets/app_bar_subtitle.dart';
import 'package:auto_flutter/screens/widgets/custom_button.dart';
import 'package:flutter_svg/flutter_svg.dart';


class AddTrunkPage extends StatefulWidget {
  const AddTrunkPage({super.key});

  @override
  State<AddTrunkPage> createState() => _AddTrunkPageState();
}

class _AddTrunkPageState extends State<AddTrunkPage> {
  List<Car> _carList = [];
  Car? _selectedCar;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCarsFromDatabase();
  }

  Future<void> _loadCarsFromDatabase() async {
    final carBox = Hive.box<Car>('cars');
    setState(() {
      _carList = carBox.values.toList();
      _selectedCar = _carList.isNotEmpty ? _carList.first : null;
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
        title: 'Добавление предмета',
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
                      label: 'Комментарий *',
                      placeholder: 'Введите текст',
                    ),
                    Text(
                      '*Необязательное поле',
                      style: AutoTextStyles.h4,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            CustomButton(
              text: 'Готово',
              onPressed: () async {
                final trunkBox = await Hive.openBox<TrunkItem>('trunkItems');
                final newItem = TrunkItem(
                  car: _selectedCar != null
                      ? '${_selectedCar!.brand} ${_selectedCar!.model}'
                      : '—',
                  name: _nameController.text,
                  comment: _commentController.text.isNotEmpty
                      ? _commentController.text
                      : '—',
                );
                final int newKey = await trunkBox.add(newItem);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreviewTrunkPage(
                      car: newItem.car,
                      name: newItem.name,
                      comment: newItem.comment,
                      trunkItemKey: newKey,
                    ),
                  ),
                );
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