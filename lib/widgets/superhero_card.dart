import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/resources/superheroes_colors.dart';

import '../resources/superheroes_images.dart';

class SuperheroCard extends StatelessWidget {
  SuperheroInfo superheroInfo;
  VoidCallback onTap;

  SuperheroCard({
    Key? key,
    required this.superheroInfo,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: SuperheroesColors.indigo75),
        height: 70,
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Container(
              width: 70,
                height: 70,
                color: SuperheroesColors.white24,
                child: CachedNetworkImage(
                 // progressIndicatorBuilder: null,
                    imageUrl: superheroInfo.imageUrl,
                    progressIndicatorBuilder: (context, url, progress) => Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: new CircularProgressIndicator( color: SuperheroesColors.blue,  value: progress.progress,),
                      ),
                    ),
                    errorWidget: (context, url, error) =>  Center(child: Image.asset(SuperheroesImages.unknown, width: 20, height: 62,fit:BoxFit.cover ,)),
                    width: 70,
                    height: 70,



                    fit: BoxFit.cover)),
            SizedBox(width: 12),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(superheroInfo.name.toUpperCase(),
                    style: TextStyle(
                        color: SuperheroesColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
                Text(superheroInfo.realName,
                    style: TextStyle(
                        color: SuperheroesColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400)),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
