import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ActionButton({
    Key? key,
    required this.text,
    required this.onTap,
    // required this.bloc,
  }) : super(key: key);

  // final MainBloc bloc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: SuperheroesColors.blue),
        margin: const EdgeInsets.only( bottom: 30),
        padding: const EdgeInsets.symmetric( vertical: 8, horizontal: 20),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(fontSize: 14, color: SuperheroesColors.white, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
