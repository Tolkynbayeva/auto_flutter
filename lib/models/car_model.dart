import 'package:hive/hive.dart';

part 'car_model.g.dart';

@HiveType(typeId: 0)
class Car {
  @HiveField(0)
  final String brand;

  @HiveField(1)
  final String model;

  @HiveField(2)
  final String year;

  @HiveField(3)
  final String color;

  @HiveField(4)
  final String purchaseDate;

  @HiveField(5)
  final String mileage;

  @HiveField(6)
  final String? imageFileName;

  Car({
    required this.brand,
    required this.model,
    required this.year,
    required this.color,
    required this.purchaseDate,
    required this.mileage,
    this.imageFileName,
  });
}