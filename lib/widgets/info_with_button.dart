import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/action_button.dart';

class InfoWithButton extends StatelessWidget {
  String title;
  String subtitle;
  String buttonText;
  String assetImage;
  double imageHeight;
  double imageWidth;
  double imageTopPadding;
  InfoWithButton({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.assetImage,
    required this.imageHeight,
    required this.imageWidth,
    required this.imageTopPadding

  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        //Center Column contents vertically,

        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [

              Container(
                width: 108,
                height: 108,
                decoration: BoxDecoration(
                    color: SuperheroesColors.blue, shape: BoxShape.circle),
              ),
              Padding(
                padding: EdgeInsets.only(top: imageTopPadding),
                child: Image.asset(assetImage,
                    width: imageWidth, height: imageHeight, fit: BoxFit.cover),
              )
            ],
          ),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
                color: SuperheroesColors.white,
                fontSize: 32,
                fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 20),
          Text(subtitle.toUpperCase(),
              style: TextStyle(
                  color: SuperheroesColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          SizedBox(height: 30),
          ActionButton(
            text: buttonText,
            onTap: () {},
          )
        ],
      ),
    );
  }
}
