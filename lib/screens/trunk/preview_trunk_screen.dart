import 'package:flutter/material.dart';
import 'package:auto_flutter/style/text_style.dart';
import '../widgets/app_bar_subtitle.dart';
import 'package:auto_flutter/screens/trunk/edit_trunk_screen.dart';
import 'package:hive/hive.dart';
import 'package:auto_flutter/models/car_model.dart';
import 'package:auto_flutter/models/trunk_item_model.dart';
import 'package:collection/collection.dart';

class PreviewTrunkPage extends StatelessWidget {
  final String car;
  final String name;
  final String comment;
  final int trunkItemKey;

  const PreviewTrunkPage({
    super.key,
    required this.car,
    required this.name,
    required this.comment,
    required this.trunkItemKey,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithSubtitle(
        title: 'Предмет: $name',
        subtitle: 'Багажник',
        showActionIcon: true,
        actionIconPath: 'assets/img/svg/menu.svg',
        onActionPressed: () {
          _showSettingsDialog(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPreviewRow('Автомобиль', car),
            _buildPreviewRow('Название', name),
            _buildPreviewRow('Комментарий', comment),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AutoTextStyles.h4),
        const SizedBox(height: 4),
        Text(value.isNotEmpty ? value : '—', style: AutoTextStyles.b1),
        const Divider(),
      ],
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          contentPadding: const EdgeInsets.only(top: 20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Редактировать',
                  style: AutoTextStyles.h3,
                  textAlign: TextAlign.center,
                ),
                onTap: () async {
                  Navigator.pop(context);

                  final carBox = Hive.box<Car>('cars');

                  Car? selectedCar = carBox.values.firstWhereOrNull(
                    (carItem) => '${carItem.brand} ${carItem.model}' == car,
                  );

                  if (selectedCar != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTrunkScreen(
                          car: selectedCar,
                          name: name,
                          comment: comment,
                          trunkItemKey: trunkItemKey,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Автомобиль не найден в базе данных'),
                      ),
                    );
                  }
                },
              ),
              Divider(height: 1, color: Colors.grey.shade300),
              ListTile(
                title: Text(
                  'Удалить',
                  style: AutoTextStyles.h3.copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            'Вы действительно хотите удалить предмет?',
            style: AutoTextStyles.h3,
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                final trunkBox = Hive.box<TrunkItem>('trunkItems');

                await trunkBox.delete(trunkItemKey);

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Предмет удален успешно'),
                  ),
                );
              },
              child: Text(
                'Удалить',
                style: AutoTextStyles.h3.copyWith(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Отмена',
                style: AutoTextStyles.h3.copyWith(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
