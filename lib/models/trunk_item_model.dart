import 'package:hive/hive.dart';

part 'trunk_item_model.g.dart';

@HiveType(typeId: 2) 
class TrunkItem {
  @HiveField(0)
  final String car;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String comment;

  TrunkItem({
    required this.car,
    required this.name,
    required this.comment,
  });
}