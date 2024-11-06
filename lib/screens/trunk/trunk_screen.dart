import 'package:auto_flutter/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/app_bar_subtitle.dart';
import 'package:auto_flutter/screens/widgets/custom_button.dart';
import 'package:auto_flutter/screens/trunk/add_trunk_screen.dart';
import 'package:auto_flutter/screens/trunk/preview_trunk_screen.dart';
import 'package:auto_flutter/models/trunk_item_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TrunkPage extends StatefulWidget {
  const TrunkPage({super.key});

  @override
  State<TrunkPage> createState() => _TrunkPageState();
}

class _TrunkPageState extends State<TrunkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWithSubtitle(
        title: 'Багажник',
        subtitle: 'Мои автомобили',
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<TrunkItem>('trunkItems').listenable(),
              builder: (context, Box<TrunkItem> box, _) {
                if (box.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Здесь хранятся записи о предметах в багажнике автомобиля',
                          style: AutoTextStyles.b1,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20.0),
                        SvgPicture.asset(
                          'assets/img/svg/icon3.svg',
                          height: 100.0,
                        ),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final itemKey = box.keyAt(index);
                      final item = box.get(itemKey)!;
    
                      return ListTile(
                        title: Text(item.name, style: AutoTextStyles.h4),
                        subtitle: Text(item.comment, style: AutoTextStyles.b1),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PreviewTrunkPage(
                                car: item.car,
                                name: item.name,
                                comment: item.comment,
                                trunkItemKey: itemKey,
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
              text: 'Добавить предмет',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddTrunkPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}