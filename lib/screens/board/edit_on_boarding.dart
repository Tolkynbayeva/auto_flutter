import 'package:flutter/material.dart';
import 'package:auto_flutter/screens/widgets/app_bar_subtitle.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_flutter/style/text_style.dart';
import 'package:auto_flutter/screens/widgets/custom_button.dart';
import 'package:auto_flutter/screens/board/on_board_screen.dart';

class EditOnBoardingPage extends StatefulWidget {
  final String? car;
  final String? mileage;
  final String? category;
  final String? cost;
  final String? note;
  final String? comment;

  const EditOnBoardingPage({
    Key? key,
    required this.car,
    required this.mileage,
    required this.category,
    required this.cost,
    required this.note,
    required this.comment,
  }) : super(key: key);

  @override
  State<EditOnBoardingPage> createState() => _EditOnBoardingPageState();
}

class _EditOnBoardingPageState extends State<EditOnBoardingPage> {
  late TextEditingController _mileageController;
  late TextEditingController _costController;
  late TextEditingController _noteController;
  late TextEditingController _commentController;

  String? _selectedCar;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();

    _mileageController = TextEditingController(text: widget.mileage);
    _costController = TextEditingController(text: widget.cost);
    _noteController = TextEditingController(text: widget.note);
    _commentController = TextEditingController(text: widget.comment);

    _selectedCar = widget.car;
    _selectedCategory = widget.category;
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
        title: 'Редактирование',
        subtitle: 'Бортовой компьютер',
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
                    _buildDropdownField(
                      context,
                      label: 'Автомобиль',
                      value: _selectedCar,
                      items: [
                        'Nissan qashqai',
                      ],
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
              onPressed: () {
                final updatedCar = _selectedCar;
                final updatedMileage = _mileageController.text;
                final updatedCategory = _selectedCategory;
                final updatedCost = _costController.text;
                final updatedNote = _noteController.text;
                final updatedComment = _commentController.text;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => OnBoardPage()),
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

  Widget _buildDropdownField(
    BuildContext context, {
    required String label,
    required String? value,
    required List<String> items,
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
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            isDense: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
          ),
          dropdownColor: Colors.white,
          icon: SvgPicture.asset('assets/img/svg/arow_dropdown_bottom.svg'),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
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