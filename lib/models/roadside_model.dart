import 'package:hive/hive.dart';

part 'roadside_model.g.dart';

@HiveType(typeId: 1)
class RoadsideSolution {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String imageUrl;

  @HiveField(2)
  final String content;

  RoadsideSolution({
    required this.title,
    required this.imageUrl,
    required this.content,
  });

  factory RoadsideSolution.fromJson(Map<String, dynamic> json) {
    return RoadsideSolution(
      title: json['title'] ?? 'Нет заголовка',
      imageUrl: json['imageUrl'] ?? 'assets/img/default.png',
      content: json['content'] ?? '',
    );
  }
}