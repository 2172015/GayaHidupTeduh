import 'package:flutter/material.dart';
// import 'package:gaya_hidup_teduh/widgets/cards/action_card.dart';
import 'package:gaya_hidup_teduh/widgets/cards/allow_image.dart';
import 'package:gaya_hidup_teduh/widgets/cards/default_card.dart';

class Iseng extends StatefulWidget {
  const new({super.key});

  @override
  State<Iseng> createState() => _IsengState();
}

class _IsengState extends State<Iseng> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 240,
          alignment: Alignment.center,
          child: DefaultCard(
            title: "Hello",
            subtitle: "This is subtitle",
            cardImage: CardImage(
              assetPath: '../assets/images/homepage/counselor1.png',
            ),
          ),
        ),
      ),
    );
  }
}

// void _onTap() {}
