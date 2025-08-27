import 'package:hive/hive.dart';
import '../../data/model/character_response.dart';

part 'character_hive.g.dart';

@HiveType(typeId: 1)
class CharacterHive extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final String species;

  @HiveField(4)
  final String imageUrl;

  @HiveField(5)
  final String location;

  @HiveField(6, defaultValue: false)
  final bool isFavorite;

  CharacterHive({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.imageUrl,
    required this.location,
    this.isFavorite = false,
  });

  /// Маппинг из REST напрямую в Hive-модель
  factory CharacterHive.fromResponse(CharacterResponse r) => CharacterHive(
        id: r.id,
        name: r.name,
        status: r.status,
        species: r.species,
        imageUrl: r.image,
        location: r.location.name,
      );

  CharacterHive copyWith({
    bool? isFavorite,
  }) =>
      CharacterHive(
        id: id,
        name: name,
        status: status,
        species: species,
        imageUrl: imageUrl,
        location: location,
        isFavorite: isFavorite ?? this.isFavorite,
      );
}
