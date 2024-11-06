import 'package:auto_flutter/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/app_bar_subtitle.dart';
import 'package:auto_flutter/screens/widgets/custom_button.dart';
import 'package:auto_flutter/screens/board/add_on_board_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:auto_flutter/models/record_model.dart';
import 'package:auto_flutter/screens/board/preview_on_board.dart';

class OnBoardPage extends StatefulWidget {
  const OnBoardPage({super.key});

  @override
  State<OnBoardPage> createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWithSubtitle(
        title: 'Бортовой компьютер',
        subtitle: 'Мои автомобили',
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<Record>('records').listenable(),
              builder: (context, Box<Record> box, _) {
                if (box.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Здесь хранятся записи об операциях с автомобилем',
                          style: AutoTextStyles.b1,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20.0),
                        SvgPicture.asset(
                          'assets/img/svg/icon2.svg',
                          height: 100.0,
                        ),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final recordKey = box.keyAt(index);
                      final record = box.get(recordKey)!;

                      return ListTile(
                        title: Text('Запись $recordKey'),
                        subtitle:
                            Text('${record.car.brand} ${record.car.model}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PreviewOnBoard(
                                recordId: recordKey,
                                record: record,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomButton(
              text: 'Добавить запись',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddOnBoardPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
