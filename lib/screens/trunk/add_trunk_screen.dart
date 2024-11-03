import 'package:auto_flutter/screens/trunk/preview_trunk_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/app_bar_subtitle.dart';
import 'package:auto_flutter/screens/widgets/custom_button.dart';
import 'package:auto_flutter/style/text_style.dart';

class AddTrunkPage extends StatelessWidget {
  const AddTrunkPage({super.key});

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
                    _buildDropdownField(
                      context,
                      label: 'Автомобиль',
                      value: 'Nissan qashqai',
                      items: [
                        'Nissan qashqai',
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Название',
                      placeholder: 'Введите текст',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => PreviewTrunkPage()),
                  (Route<dynamic> route) => false,
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
    required String value,
    required List<String> items,
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
          onChanged: (value) {},
        ),
      ],
    );
  }
}
