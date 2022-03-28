import 'package:json_annotation/json_annotation.dart';
import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/powerstats.dart';
import 'package:superheroes/model/server_image.dart';

part 'superhero.g.dart';
@JsonSerializable(fieldRename: FieldRename.kebab,  explicitToJson: true)
class Superhero{
  final String name;
  final Biography biography;
  final ServerImage image;
  final Powerstats powerstats;
  final String id;
  Superhero(this.name, this.biography, this.image, this.powerstats, this.id);

  factory Superhero.fromJson(final Map<String, dynamic> json) => _$SuperheroFromJson(json);
  Map<String, dynamic> toJson() => _$SuperheroToJson(this);

}