import 'package:flutter/material.dart';
import 'package:auto_flutter/style/custom_app_bar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:auto_flutter/screens/cars/widget/add_car_form.dart';
import 'package:auto_flutter/screens/cars/widget/car_list.dart';
import 'package:auto_flutter/models/car_model.dart';

class AddCarsPage extends StatelessWidget {
  final Box<Car> carBox = Hive.box<Car>('cars');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Мои автомобили'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AddCarForm(carBox: carBox),
            const SizedBox(height: 20),
            CarList(carBox: carBox),
          ],
        ),
      ),
    );
  }
}
