import 'package:auto_flutter/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/app_bar_subtitle.dart';
import 'package:auto_flutter/screens/widgets/custom_button.dart';
import 'add_trunk_screen.dart';

class TrunkPage extends StatelessWidget {
  const TrunkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWithSubtitle(
        title: 'Багажник',
        subtitle: 'Мои автомобили',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Здесь хранятся записи о предметах в багажнике автомобиля',
              style: AutoTextStyles.b1,
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: SvgPicture.asset(
                'assets/img/svg/icon3.svg',
              ),
            ),
            CustomButton(
              text: 'Добавить предмет',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTrunkPage(),
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
}
