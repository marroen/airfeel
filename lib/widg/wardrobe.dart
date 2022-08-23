import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../help/helper.dart';
import 'loading.dart';
import 'filler.dart';

// Page for wardrobe func.
class Wardrobe extends StatefulWidget {
  State<StatefulWidget> createState () {
    return WardrobeState();
  }
}

class WardrobeState extends State<Wardrobe> {
  final LocalStorage storage = new LocalStorage('key');
  static const clothing = [
    'T-shirt',
    'Pants',
    'Shorts',
    'Hoodie',
    'Underlayer',
    'Socks',
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
    return _fillWardrobe();
  }

  _fillWardrobe() {
    return FutureBuilder(
      future: storage.ready,
      builder: (BuildContext context, snapshot) {
        if (snapshot.data == true) {
          //storage.setItem('wardrobeSet', true);
          if (storage.getItem('wardrobeSet')) {
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
                      Image.asset('images/socks.png', width: 50, height: 50),
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
          } else {
            return Filler();
          }
        } else {
          return CircularProgressIndicator();
        }
      }
    );
      }
}
