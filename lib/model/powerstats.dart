import 'package:json_annotation/json_annotation.dart';

part 'powerstats.g.dart';

@JsonSerializable()
class Powerstats {
  final String intelligence;
  final String strength;
  final String speed;
  final String durability;
  final String power;
  final String combat;

  Powerstats(
      {required this.intelligence,
      required this.strength,
      required this.speed,
      required this.durability,
      required this.power,
      required this.combat});

  bool isNotNull() =>
      intelligence != 'null' &&
      strength != 'null' &&
      speed != 'null' &&
      durability != 'null' &&
      power != 'null' &&
      combat != 'null';

  double get intelligencePercent => convertStringtoPercent(intelligence);
  double get strengthPercent => convertStringtoPercent(strength);
  double get speedPercent => convertStringtoPercent(speed);
  double get durabilityPercent => convertStringtoPercent(durability);
  double get powerPercent => convertStringtoPercent(power);
  double get combatPercent => convertStringtoPercent(combat);



  double convertStringtoPercent(final String value){
    final intValue = int.tryParse(value);
    if(intValue == null){return 0;
    }
    return intValue / 100;
  }

  factory Powerstats.fromJson(final Map<String, dynamic> json) =>
      _$PowerstatsFromJson(json);

  Map<String, dynamic> toJson() => _$PowerstatsToJson(this);
}
