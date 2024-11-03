import 'package:flutter/material.dart';
import 'package:auto_flutter/style/text_style.dart';
import '../widgets/app_bar_subtitle.dart';
import 'package:auto_flutter/screens/trunk/edit_trunk_screen.dart';

class PreviewTrunkPage extends StatelessWidget {
  const PreviewTrunkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithSubtitle(
        title: 'Предмет 1',
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
            _buildPreviewRow('Автомобиль', 'Nissan qashqai'),
            _buildPreviewRow('Название', ''),
            _buildPreviewRow('Комментарий', ''),
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
          value.isNotEmpty ? value : '—',
          style: AutoTextStyles.b1,
        ),
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
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditTrunkScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
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
            'Вы действительно хотите удалить автомобиль?',
            style: AutoTextStyles.h3,
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Логика удаления автомобиля
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
