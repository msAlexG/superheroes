import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_images.dart';

class SuperheroCard extends StatelessWidget {
  String name;
  String realName;
  String imageUrl;
  VoidCallback onTap;

  SuperheroCard({
    Key? key,
    required this.name,
    required this.realName,
    required this.imageUrl,
    required this.onTap,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector (
      onTap: onTap,
      child: Container(
        height: 70,
        color: SuperheroesColors.backgroundcard,
        child: Row(
          children: [
            Image.network(imageUrl,width: 70, height: 70, fit: BoxFit.cover),
            SizedBox(width: 12),
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name.toUpperCase(), style: TextStyle(color: SuperheroesColors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                Text(realName, style: TextStyle(color: SuperheroesColors.white, fontSize: 12, fontWeight: FontWeight.w400)),

              ],
            ))
          ],
        ),
      ),
    );
  }
}
