import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:auto_flutter/models/car_model.dart';
import 'package:auto_flutter/models/record_model.dart';

import 'auto.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(CarAdapter());
  Hive.registerAdapter(RecordAdapter());
  await Hive.openBox<Car>('cars');
  await Hive.openBox<Record>('records');

  runApp(const Auto());
}