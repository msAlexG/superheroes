import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_images.dart';

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
    return GestureDetector (
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: SuperheroesColors.indigo75),
        height: 70,
       clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Image.network(superheroInfo.imageUrl,width: 70, height: 70, fit: BoxFit.cover),
            SizedBox(width: 12),
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(superheroInfo.name.toUpperCase(), style: TextStyle(color: SuperheroesColors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                Text(superheroInfo.realName, style: TextStyle(color: SuperheroesColors.white, fontSize: 12, fontWeight: FontWeight.w400)),

              ],
            ))
          ],
        ),
      ),
    );
  }

}
