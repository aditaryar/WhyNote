import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  DateTime lastUpdated;

  Note({
    required this.title,
    required this.description,
    required this.lastUpdated,
  });
}