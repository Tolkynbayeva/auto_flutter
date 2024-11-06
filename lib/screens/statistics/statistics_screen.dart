import 'package:auto_flutter/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:auto_flutter/models/car_model.dart';
import 'package:auto_flutter/models/record_model.dart';
import 'package:intl/intl.dart';
import '../widgets/app_bar_subtitle.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  int _calculateYearsOwned(String purchaseDate) {
    final purchaseDateParsed = DateFormat('dd.MM.yyyy').parse(purchaseDate);
    final currentDate = DateTime.now();
    return currentDate.year - purchaseDateParsed.year;
  }

  int _calculateTotalMileage(Box<Record> records, Car car) {
    return records.values
        .where((record) => record.car == car)
        .map((record) => int.tryParse(record.mileage) ?? 0)
        .fold(0, (sum, mileage) => sum + mileage);
  }

  double _calculateTotalSpent(Box<Record> records, Car car) {
    return records.values
        .where((record) => record.car == car)
        .map((record) => double.tryParse(record.cost) ?? 0.0)
        .fold(0.0, (sum, cost) => sum + cost);
  }

  @override
  Widget build(BuildContext context) {
    final carBox = Hive.box<Car>('cars');
    final recordBox = Hive.box<Record>('records');

    return Scaffold(
      appBar: const CustomAppBarWithSubtitle(
        title: 'Статистика',
        subtitle: 'Мои автомобили',
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: carBox.length,
                itemBuilder: (context, index) {
                  final car = carBox.getAt(index)!;
                  final yearsOwned = _calculateYearsOwned(car.purchaseDate);
                  final totalMileage = int.tryParse(car.mileage) ?? 0;
                  final totalSpent = _calculateTotalSpent(recordBox, car);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${car.brand} ${car.model}',
                          style: AutoTextStyles.h4.copyWith(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _buildStatisticRow(
                          label: 'Количество лет во владении',
                          value: '$yearsOwned',
                        ),
                        const Divider(),
                        _buildStatisticRow(
                          label: 'Пробег (км)',
                          value: '$totalMileage',
                        ),
                        const Divider(),
                        _buildStatisticRow(
                          label: 'Потраченная сумма на автомобиль (₽)',
                          value: '${totalSpent.toStringAsFixed(2)}',
                        ),
                        const Divider(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
            Center(
              child: SvgPicture.asset(
                'assets/img/svg/icon1.svg',
                height: 100.0,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AutoTextStyles.b1),
          Text(value, style: AutoTextStyles.h4),
        ],
      ),
    );
  }
}
