import 'package:auto_flutter/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/app_bar_subtitle.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWithSubtitle(
        title: 'Статистика',
        subtitle: 'Мои автомобили',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  label: 'Количество лет во владении',
                  placeholder: 'Введите текст',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Пробег (км)',
                  placeholder: 'Введите текст',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Потраченная сумма на автомобиль (₽)',
                  placeholder: 'Введите текст',
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            Expanded(
              child: SvgPicture.asset(
                'assets/img/svg/icon1.svg',
              ),
            ),
            const Spacer()
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

}
