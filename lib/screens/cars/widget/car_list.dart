import 'package:flutter/material.dart';
import 'package:auto_flutter/models/car_model.dart';
import 'package:auto_flutter/style/text_style.dart';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';

class CarList extends StatelessWidget {
  final Box<Car> carBox;

  const CarList({Key? key, required this.carBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: carBox.listenable(),
        builder: (context, Box<Car> box, _) {
          // if (box.values.isEmpty) {
          //   return Text("Нет сохраненных автомобилей", style: AutoTextStyles.h4);
          // } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final car = box.getAt(index);
              return ListTile(
                leading: car?.imagePath != null
                    ? Image.file(
                        File(car!.imagePath!),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.directions_car),
                title: Text('${car?.brand} ${car?.model}',
                    style: AutoTextStyles.h4),
                subtitle: Text('Год: ${car?.year}, Пробег: ${car?.mileage} км'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => box.deleteAt(index),
                ),
              );
            },
          );
        }
        // },
        );
  }
}
