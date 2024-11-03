import 'package:hive/hive.dart';

part 'roadside_model.g.dart';

@HiveType(typeId: 1)
class RoadsideSolution {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String imageUrl;

  @HiveField(2)
  final String url;

  RoadsideSolution({
    required this.title,
    required this.imageUrl,
    required this.url,
  });

  factory RoadsideSolution.fromJson(Map<String, dynamic> json) {
    return RoadsideSolution(
      title: json['title'],
      imageUrl: json['imageUrl'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'url': url,
    };
  }
}