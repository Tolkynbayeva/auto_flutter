import 'package:flutter/material.dart';
import 'package:auto_flutter/screens/cars/widgets/add_car_form.dart';
import 'package:auto_flutter/screens/widgets/custom_app_bar.dart';
import 'package:flutter_svg/svg.dart';

class AddCarScreen extends StatelessWidget {
  const AddCarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Мои автомобили',
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/img/svg/lightbulb.fill.svg',
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/img/svg/gearshape.fill.svg', 
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: const AddCarForm(),
    );
  }
}
