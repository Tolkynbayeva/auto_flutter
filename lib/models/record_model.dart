import 'package:hive/hive.dart';
import 'car_model.dart';

part 'record_model.g.dart';

@HiveType(typeId: 1)
class Record {
  @HiveField(0)
  final Car car;

  @HiveField(1)
  final String mileage;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String cost;

  @HiveField(4)
  final String note;

  @HiveField(5)
  final String comment;

  Record({
    required this.car,
    required this.mileage,
    required this.category,
    required this.cost,
    required this.note,
    required this.comment,
  });
}