import 'package:flutter/material.dart';
import 'package:auto_flutter/models/car_model.dart';
import 'package:auto_flutter/screens/widgets/custom_app_bar.dart';
import 'package:auto_flutter/screens/cars/widgets/edit_car_form.dart';
import 'package:flutter_svg/svg.dart';

class EditCarScreen extends StatelessWidget {
  final Car car;
  final dynamic carKey;

  const EditCarScreen({Key? key, required this.car, required this.carKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Редактирование автомобиля',
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
      body: EditCarForm(car: car, carKey: carKey),
    );
  }
}