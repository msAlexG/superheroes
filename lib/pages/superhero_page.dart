import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/superhero_bloc.dart';
import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/powerstats.dart';
import 'package:superheroes/model/superhero.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_icons.dart';
import 'package:superheroes/resources/superheroes_images.dart';

class SuperheroPage extends StatefulWidget {
  final http.Client? client;
  final String id;

  SuperheroPage({Key? key, this.client, required this.id}) : super(key: key);

  @override
  _SuperheroPageState createState() => _SuperheroPageState();
}

class _SuperheroPageState extends State<SuperheroPage> {
  late SuperheroBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = SuperheroBloc(client: widget.client, id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: SuperheroesColors.background,
        body: SuperheroContentPage(),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();

    super.dispose();
  }
}

class SuperheroContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SuperheroBloc>(context, listen: false);
    return StreamBuilder<Superhero>(
        stream: bloc.observeSuperhero(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox.shrink();
          }
          final superhero = snapshot.data!;
          return CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SuperheroAppBar(superhero: superhero),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    if (superhero.powerstats.isNotNull())
                      PowerstatsWidget(powerstats: superhero.powerstats),
                    BiographyWidget(biography: superhero.biography),
                    const SizedBox(height: 30),
                  ],
                ),
              )
            ],
          );
        });
  }
}

class SuperheroAppBar extends StatelessWidget {
  const SuperheroAppBar({
    Key? key,
    required this.superhero,
  }) : super(key: key);

  final Superhero superhero;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      stretch: true,
      pinned: true,
      floating: true,
      expandedHeight: 348,
      actions: [FavoriteButton()],
      backgroundColor: SuperheroesColors.background,
      flexibleSpace: FlexibleSpaceBar(
        title: (Text(
          superhero.name,
          style: TextStyle(
              fontWeight: FontWeight.w800, color: Colors.white, fontSize: 22),
        )),
        centerTitle: true,
        background: CachedNetworkImage(
            imageUrl: superhero.image.url,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                ColoredBox(color: SuperheroesColors.indigo),
            errorWidget: (context, url, error) => Container(
                  alignment: Alignment.center,
                  color: SuperheroesColors.indigo,
                  child: Image(
                    image: AssetImage(SuperheroesImages.unknownBig),
                    width: 85,
                    height: 264,
                  ),
                )),
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SuperheroBloc>(context, listen: false);
    return StreamBuilder<bool>(
        stream: bloc.observeIsFavorite(),
        initialData: false,
        builder: (context, snapshot) {
          final favorite =
              !snapshot.hasData || snapshot.data == null || snapshot.data!;
          return GestureDetector(
            onTap: () =>
                favorite ? bloc.removeFromFavorites() : bloc.addToFavorite(),
            child: Container(
              height: 52,
              width: 52,
              alignment: Alignment.center,
              child: Image.asset(
                favorite
                    ? SuperheroesIcons.starFilled
                    : SuperheroesIcons.starEmpty,
                height: 32,
                width: 32,
              ),
            ),
          );
        });
  }
}

class BiographyWidget extends StatelessWidget {
  final Biography biography;

  const BiographyWidget({Key? key, required this.biography}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: SuperheroesColors.indigo,
      ),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Bio'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: SuperheroesColors.white),
                ),
                const SizedBox(
                  height: 8,
                ),
                BiographyField(
                  fieldName: 'Full name',
                  fieldValue: biography.fullName,
                ),
                SizedBox(
                  height: 20,
                ),
                BiographyField(
                    fieldName: 'Aliases',
                    fieldValue: biography.aliases.join(', ')),
                SizedBox(
                  height: 20,
                ),
                BiographyField(
                  fieldName: 'Plase of birth',
                  fieldValue: biography.placeOfBirth,
                )
              ],
            ),
          ),
          RotatedBox(

              quarterTurns: 1,
              child: Container(
                width: 70,
                  height: 24,
                  padding: EdgeInsets.symmetric(vertical: 6),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only( topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                    color: biography.alignmentInfo!.color,
                  ),
                  child: Text(
                    biography.alignmentInfo!.name.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: SuperheroesColors.white,
                        fontSize: 10),
                  )))
        ],
      ),
    );
  }
}

class BiographyField extends StatelessWidget {
  final String fieldName;
  final String fieldValue;

  const BiographyField(
      {Key? key, required this.fieldName, required this.fieldValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          fieldName.toUpperCase(),
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: SuperheroesColors.grey999),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          fieldValue,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: SuperheroesColors.white),
        ),
      ],
    );
  }
}

class PowerstatsWidget extends StatelessWidget {
  final Powerstats powerstats;

  const PowerstatsWidget({Key? key, required this.powerstats})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Powerstats'.toUpperCase(),
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: SuperheroesColors.white),
        ),
        const SizedBox(height: 24),
        Row(children: [
          const SizedBox(width: 16),
          Expanded(
              child: Center(
                  child: PowerstatWidget(
                      name: 'Intelligence',
                      value: powerstats.intelligencePercent))),
          Expanded(
              child: Center(
                  child: PowerstatWidget(
                      name: 'Strength', value: powerstats.strengthPercent))),
          Expanded(
              child: Center(
                  child: PowerstatWidget(
                      name: 'Speed', value: powerstats.speedPercent))),
          const SizedBox(width: 16),
        ]),
        const SizedBox(height: 20),
        Row(children: [
          const SizedBox(width: 16),
          Expanded(
              child: Center(
                  child: PowerstatWidget(
                      name: 'Durability',
                      value: powerstats.durabilityPercent))),
          Expanded(
              child: Center(
                  child: PowerstatWidget(
                      name: 'Power', value: powerstats.powerPercent))),
          Expanded(
              child: Center(
                  child: PowerstatWidget(
                      name: 'Combat', value: powerstats.combatPercent))),
          const SizedBox(width: 16),
        ]),
        const SizedBox(height: 36),
      ],
    );
  }
}

class PowerstatWidget extends StatelessWidget {
  final String name;
  final double value;

  const PowerstatWidget({Key? key, required this.name, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ArcWidget(value: value, color: calculateColorByValue()),
        Padding(
          padding: const EdgeInsets.only(top: 17),
          child: Text(
            '${(value * 100).toInt()}',
            style: TextStyle(
                color: calculateColorByValue(),
                fontWeight: FontWeight.w800,
                fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 44),
          child: Text(
            '${name.toUpperCase()}',
            style: TextStyle(
                color: SuperheroesColors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12),
          ),
        )
      ],
    );
  }

  Color calculateColorByValue() {
    if (value <= 0.5) {
      return Color.lerp(Colors.red, Colors.orangeAccent, value / 0.5)!;
    } else {
      return Color.lerp(
          Colors.orangeAccent, Colors.green, (value - 0.5) / 0.5)!;
    }
  }
}

class ArcWidget extends StatelessWidget {
  final double value;
  final Color color;

  const ArcWidget({Key? key, required this.value, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ArtCustomPainter(value, color),
      size: Size(66, 33),
    );
  }
}

class ArtCustomPainter extends CustomPainter {
  final double value;
  final Color color;

  ArtCustomPainter(this.value, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    final bakgroundpaint = Paint()
      ..color = SuperheroesColors.white24
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;
    canvas.drawArc(rect, pi, pi, false, bakgroundpaint);
    canvas.drawArc(rect, pi, pi * value, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is ArtCustomPainter) {
      return oldDelegate.value != value && oldDelegate.color != color;
    }
    return true;
  }
}
