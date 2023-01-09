import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/model/alignment_info.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_images.dart';

class SuperheroCard extends StatelessWidget {
  final SuperheroInfo superheroeinfo;

  final VoidCallback onTap;

  const SuperheroCard(
      {Key? key, required this.onTap, required this.superheroeinfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            color: SuperheroesColors.indigo,
            borderRadius: BorderRadius.circular(8)),
        height: 70,
        child: Row(children: [
          AvatarWidget(superheroeinfo: superheroeinfo),
          SizedBox(width: 12),
          NameAndRealNameWidget(superheroeinfo: superheroeinfo),
          if (superheroeinfo.alignmentInfo != null)
            AlegnmentWidget(
              alignmentInfo: superheroeinfo.alignmentInfo!,
            )
        ]),
      ),
    );
  }
}


class AlegnmentWidget extends StatelessWidget {
  final AlignmentInfo alignmentInfo;

  const AlegnmentWidget({Key? key, required this.alignmentInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
        quarterTurns: 1,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: alignmentInfo.color,),
            child: Text(
              alignmentInfo.name.toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: SuperheroesColors.white,
                  fontSize: 10),
            )));
  }
}

class NameAndRealNameWidget extends StatelessWidget {
  const NameAndRealNameWidget({
    Key? key,
    required this.superheroeinfo,
  }) : super(key: key);

  final SuperheroInfo superheroeinfo;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              superheroeinfo.name.toUpperCase(),
              style: TextStyle(
                  color: SuperheroesColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            Text(superheroeinfo.realName,
                style: TextStyle(
                    color: SuperheroesColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400))
          ],
        ));
  }
}

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    Key? key,
    required this.superheroeinfo,
  }) : super(key: key);

  final SuperheroInfo superheroeinfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      color: SuperheroesColors.white24,
      child: CachedNetworkImage(
        imageUrl: superheroeinfo.imageUrl,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, progress) => Center(
          widthFactor: 24,
          heightFactor: 24,
          child: CircularProgressIndicator(
            value: progress.progress,
            color: SuperheroesColors.circulColor,
          ),
        ),
        errorWidget: (context, url, error) => Center(
            child: Image.asset(
              SuperheroesImages.unknown,
              height: 62,
              width: 20,
              fit: BoxFit.cover,
            )),
      ),
    );
  }
}
