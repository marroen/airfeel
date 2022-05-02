import 'package:flutter/material.dart';
import 'helper.dart';

// Page for wardrobe func.
class Wardrobe extends StatefulWidget {
  State<StatefulWidget> createState () {
    return WardrobeState();
  }
}

class WardrobeState extends State<Wardrobe> {

  static const clothing = [
    'T-shirt',
    'Pants',
    'Shorts',
    'Hoodie',
    'Underlayer',
    'Thick socks',
    'Sneakers',
    'Boots',
    'Jacket',
    'Beanie',
    'Headphones',
    'Scarf',
    'Gloves'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/beanie.png', width: 50, height: 50),
              Image.asset('images/headphones.png', width: 50, height: 50),
              Image.asset('images/jacket.png', width: 50, height: 50),
              Image.asset('images/hoodie.png', width: 50, height: 50),
              Image.asset('images/t-shirt.png', width: 50, height: 50),
              Image.asset('images/underlayer.png', width: 50, height: 50),
              Image.asset('images/pants.png', width: 50, height: 50),
              Image.asset('images/shorts.png', width: 50, height: 50),
              Image.asset('images/thicksocks.png', width: 50, height: 50),
              Image.asset('images/sneakers.png', width: 50, height: 50),
              Image.asset('images/boots.png', width: 50, height: 50),
              Image.asset('images/gloves.png', width: 50, height: 50),
              Image.asset('images/scarf.png', width: 50, height: 50),
            //shrinkWrap: true,
            ]
          ),
        ),
      ),
    );
  }
}
