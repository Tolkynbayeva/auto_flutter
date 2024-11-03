import 'package:auto_flutter/screens/board/preview_on_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/app_bar_subtitle.dart';
import 'package:auto_flutter/screens/widgets/custom_button.dart';
import 'package:auto_flutter/style/text_style.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:auto_flutter/models/car_model.dart';
import 'package:auto_flutter/models/record_model.dart';

class AddOnBoardPage extends StatefulWidget {
  const AddOnBoardPage({Key? key}) : super(key: key);

  @override
  _AddOnBoardPageState createState() => _AddOnBoardPageState();
}

class _AddOnBoardPageState extends State<AddOnBoardPage> {
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  List<Car> _cars = [];
  Car? _selectedCar;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadCars();
    _openRecordBox();
  }

  Future<void> _openRecordBox() async {
    await Hive.openBox<Record>('records');
  }

  void _loadCars() {
    final carBox = Hive.box<Car>('cars');
    setState(() {
      _cars = carBox.values.toList();
      if (_cars.isNotEmpty) {
        _selectedCar = _cars.first;
      }
    });
  }

  @override
  void dispose() {
    _mileageController.dispose();
    _costController.dispose();
    _noteController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWithSubtitle(
        title: 'Добавление записи',
        subtitle: 'Бортовой компьютер',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _cars.isEmpty
            ? Center(
                child: Text(
                  'У вас нет сохраненных автомобилей',
                  style: AutoTextStyles.h4,
                ),
              )
            : Column(
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
                            items: _cars,
                            onChanged: (value) {
                              setState(() {
                                _selectedCar = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _mileageController,
                            label: 'Пробег (км)',
                            placeholder: 'Введите пробег',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          _buildDropdownFieldWithIcons(
                            context,
                            label: 'Категория',
                            placeholder: 'Выберите категорию',
                            items: {
                              'Заправка': 'assets/img/svg/fuelpump.fill.svg',
                              'Ремонт':
                                  'assets/img/svg/wrench.and.screwdriver.fill.svg',
                              'ДТП':
                                  'assets/img/svg/bubble.left.and.exclamationmark.bubble.right.fill.svg',
                              'Мойка': 'assets/img/svg/humidity.fill.svg',
                              'Покупка': 'assets/img/svg/bag.fill.svg',
                              'Продажа': 'assets/img/svg/banknote.fill.svg',
                              'Другое': 'assets/img/svg/menu.svg',
                            },
                            value: _selectedCategory,
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _costController,
                            label: 'Стоимость (₽)',
                            placeholder: 'Введите стоимость',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _noteController,
                            label: 'Примечание',
                            placeholder: 'Введите текст до 100 символов',
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
                      if (_selectedCar == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Пожалуйста, выберите автомобиль'),
                          ),
                        );
                        return;
                      }

                      final mileage = _mileageController.text;
                      final cost = _costController.text;
                      final note = _noteController.text;
                      final comment = _commentController.text;

                      final record = Record(
                        car: _selectedCar!,
                        mileage: mileage,
                        category: _selectedCategory ?? '',
                        cost: cost,
                        note: note,
                        comment: comment,
                      );

                      final recordBox = Hive.box<Record>('records');
                      final recordKey = await recordBox.add(record);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PreviewOnBoard(
                            recordId: recordKey,
                            record: record,
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
        Text(
          label,
          style: AutoTextStyles.h4,
        ),
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
        Text(
          label,
          style: AutoTextStyles.h4,
        ),
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
          items: items
              .map((car) => DropdownMenuItem(
                    value: car,
                    child: Text(
                      '${car.brand} ${car.model}',
                      style: AutoTextStyles.b1,
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDropdownFieldWithIcons(
    BuildContext context, {
    required String label,
    required String placeholder,
    required Map<String, String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AutoTextStyles.h4,
        ),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: AutoTextStyles.b1,
            border: const UnderlineInputBorder(),
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
          ),
          dropdownColor: Colors.white,
          icon: SvgPicture.asset('assets/img/svg/arow_dropdown_bottom.svg'),
          items: items.entries
              .map(
                (entry) => DropdownMenuItem<String>(
                  value: entry.key,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        entry.value,
                        height: 20.0,
                      ),
                      const SizedBox(width: 8),
                      Text(entry.key),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
