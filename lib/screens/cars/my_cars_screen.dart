import 'package:auto_flutter/screens/roadside/roadside_screen.dart';
import 'package:auto_flutter/screens/settingsScreen/settings_screen.dart';
import 'package:auto_flutter/screens/statistics/statistics_screen.dart';
import 'package:auto_flutter/screens/trunk/trunk_screen.dart';
import 'package:flutter/material.dart';
import 'package:auto_flutter/models/car_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:auto_flutter/style/text_style.dart';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_flutter/screens/cars/add_car_screen.dart';
import 'package:auto_flutter/screens/cars/edit_car_screen.dart';
import 'package:auto_flutter/screens/widgets/custom_app_bar.dart';
import 'package:auto_flutter/screens/board/on_board_screen.dart';

class MyCarsScreen extends StatefulWidget {
  const MyCarsScreen({Key? key}) : super(key: key);

  @override
  _MyCarsScreenState createState() => _MyCarsScreenState();
}

class _MyCarsScreenState extends State<MyCarsScreen> {
  final ValueNotifier<dynamic> _selectedCarKey = ValueNotifier<dynamic>(null);

  @override
  void initState() {
    super.initState();
    final box = Hive.box<Car>('cars');
    if (box.isNotEmpty) {
      _selectedCarKey.value = box.keys.first;
    }
  }

  @override
  void dispose() {
    _selectedCarKey.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Мои автомобили',
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Car>('cars').listenable(),
        builder: (context, Box<Car> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Text(
                "Нет сохраненных автомобилей",
                style: AutoTextStyles.h4,
              ),
            );
          } else {
            final carKeys = box.keys.toList();
            final carEntries = box.toMap().entries.toList();

            return ValueListenableBuilder<dynamic>(
              valueListenable: _selectedCarKey,
              builder: (context, selectedCarKey, _) {
                if (selectedCarKey == null ||
                    !box.containsKey(selectedCarKey)) {
                  return Center(
                    child: Text(
                      "Автомобиль не выбран",
                      style: AutoTextStyles.h4,
                    ),
                  );
                }

                final selectedCar = box.get(selectedCarKey);

                if (selectedCar == null) {
                  return Center(
                    child: Text(
                      "Данные автомобиля отсутствуют",
                      style: AutoTextStyles.h4,
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: carEntries.length + 1,
                          itemBuilder: (context, index) {
                            if (index < carEntries.length) {
                              final entry = carEntries[index];
                              final key = entry.key;
                              final car = entry.value;
                              final isSelected = key == selectedCarKey;

                              return GestureDetector(
                                onTap: () {
                                  _selectedCarKey.value = key;
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 4.0),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20.0),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: isSelected ? 0 : 1.5,
                                    ),
                                  ),
                                  child: Text(
                                    '${car.brand} ${car.model}',
                                    style: AutoTextStyles.h3.copyWith(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return IconButton(
                                icon: SvgPicture.asset(
                                  'assets/img/svg/plus.svg',
                                ),
                                onPressed: () async {
                                  final newKey = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AddCarScreen(),
                                    ),
                                  );

                                  if (newKey != null) {
                                    setState(() {
                                      _selectedCarKey.value = newKey;
                                    });
                                  }
                                },
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      if (selectedCar.imagePath?.isNotEmpty ?? false)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.file(
                            File(selectedCar.imagePath!),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                color: Colors.grey,
                                child: Center(
                                  child: Text(
                                    'Ошибка загрузки изображения',
                                    style: AutoTextStyles.h4,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      else
                        Container(
                          height: 200,
                          color: Colors.grey.shade300,
                          child: Center(
                            child: Text(
                              'Изображение отсутствует',
                              style: AutoTextStyles.h4,
                            ),
                          ),
                        ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${selectedCar.brand} ${selectedCar.model}',
                              style: AutoTextStyles.h2),
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/img/svg/menu.svg',
                            ),
                            onPressed: () {
                              _showOptionsMenu(
                                  context, selectedCarKey, selectedCar);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildDetailRow(
                              'Год выпуска', selectedCar?.year ?? '—'),
                          Divider(color: Colors.grey.shade300),
                          _buildDetailRow('Цвет', selectedCar?.color ?? '—'),
                          Divider(color: Colors.grey.shade300),
                          _buildDetailRow('Дата приобретения',
                              selectedCar?.purchaseDate ?? '—'),
                          Divider(color: Colors.grey.shade300),
                          _buildDetailRow(
                              'Пробег (км)', selectedCar?.mileage ?? '—'),
                          Divider(color: Colors.grey.shade300),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      _buildSectionButton(context, 'Бортовой компьютер', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OnBoardPage(),
                          ),
                        );
                      }),
                      _buildSectionButton(context, 'Багажник', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrunkPage(),
                          ),
                        );
                      }),
                      _buildSectionButton(context, 'Статистика', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StatisticsScreen(),
                          ),
                        );
                      }),
                      _buildSectionButton(context, 'Решения проблем на дороге',
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoadsideScreen(),
                          ),
                        );
                      }),
                      _buildSectionButton(context, 'Настройки', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showOptionsMenu(BuildContext context, dynamic carKey, Car car) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Center(
                  child: Text('Редактировать', style: AutoTextStyles.h3),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditCarScreen(car: car, carKey: carKey),
                    ),
                  );
                },
              ),
              Divider(height: 1, color: Colors.grey.shade300),
              ListTile(
                title: const Center(
                  child: Text('Удалить',
                      style: TextStyle(
                        color: Colors.red,
                      )),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, carKey);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, dynamic carKey) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Вы действительно хотите удалить автомобиль?',
                style: AutoTextStyles.h3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Отмена',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final carBox = Hive.box<Car>('cars');
                      carBox.delete(carKey);

                      Navigator.pop(context);
                      setState(() {
                        if (_selectedCarKey.value == carKey) {
                          if (carBox.isNotEmpty) {
                            _selectedCarKey.value = carBox.keys.first;
                          } else {
                            _selectedCarKey.value = null;
                          }
                        }
                      });
                    },
                    child: const Text(
                      'Удалить',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AutoTextStyles.h4),
          Text(value, style: AutoTextStyles.b1),
        ],
      ),
    );
  }

  Widget _buildSectionButton(
      BuildContext context, String title, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AutoTextStyles.h2),
          SvgPicture.asset(
            'assets/img/svg/chevron.forward.svg',
          ),
        ],
      ),
    );
  }
}
