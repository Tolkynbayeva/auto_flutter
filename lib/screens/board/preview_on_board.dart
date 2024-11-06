import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_flutter/style/text_style.dart';
import '../widgets/app_bar_subtitle.dart';
import 'package:auto_flutter/models/record_model.dart';
import 'package:hive/hive.dart';
import 'package:auto_flutter/screens/board/edit_on_boarding.dart';


class PreviewOnBoard extends StatelessWidget {
  final dynamic recordId;
  final Record record;

  const PreviewOnBoard({
    Key? key,
    required this.recordId,
    required this.record,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithSubtitle(
        title: 'Запись $recordId',
        subtitle: 'Бортовой компьютер',
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
            _buildPreviewRow(
              'Автомобиль',
              '${record.car.brand} ${record.car.model}',
            ),
            _buildPreviewRow('Пробег (км)', record.mileage ?? '—'),
            _buildPreviewRowWithIcon(
              'Категория',
              record.category ?? '',
              _getIconPathForCategory(record.category),
            ),
            _buildPreviewRow('Стоимость (₽)', record.cost ?? ''),
            _buildPreviewRow('Примечание', record.note ?? ''),
            _buildPreviewRow('Комментарий', record.comment ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AutoTextStyles.h4,
        ),
        const SizedBox(height: 4),
        Text(
          value.isNotEmpty ? value : '',
          style: AutoTextStyles.b1,
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildPreviewRowWithIcon(String label, String value, String iconPath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AutoTextStyles.h4,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            SvgPicture.asset(
              iconPath,
              height: 20,
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: AutoTextStyles.b1,
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  String _getIconPathForCategory(String? category) {
    switch (category) {
      case 'Заправка':
        return 'assets/img/svg/fuelpump.fill.svg';
      case 'Ремонт':
        return 'assets/img/svg/wrench.and.screwdriver.fill.svg';
      case 'ДТП':
        return 'assets/img/svg/bubble.left.and.exclamationmark.bubble.right.fill.svg';
      case 'Мойка':
        return 'assets/img/svg/humidity.fill.svg';
      case 'Покупка':
        return 'assets/img/svg/bag.fill.svg';
      case 'Продажа':
        return 'assets/img/svg/banknote.fill.svg';
      case 'Другое':
        return 'assets/img/svg/menu.svg';
      default:
        return 'assets/img/svg/menu.svg';
    }
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
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditOnBoardingPage(
                        recordId: recordId,
                        car: record.car,
                        mileage: record.mileage,
                        category: record.category,
                        cost: record.cost,
                        note: record.note,
                        comment: record.comment,
                      ),
                    ),
                  );
                },
              ),
              Divider(height: 1, color: Colors.grey.shade300),
              ListTile(
                title: Text(
                  'Удалить',
                  style: AutoTextStyles.h3.copyWith(
                    color: Colors.red,
                  ),
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
            'Вы действительно хотите удалить запись?',
            style: AutoTextStyles.h3,
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                final recordBox = Hive.box<Record>('records');
                recordBox.delete(recordId);

                Navigator.pop(context);
                Navigator.pop(context);
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
                style: AutoTextStyles.h3.copyWith(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
