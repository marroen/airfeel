import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class Filler extends StatefulWidget {
  @override

  State<StatefulWidget> createState() {
    return FillerState();
  }
}

class FillerState extends State<Filler> {

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(8, 60, 8, 60),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget> [
              Center(child: Text("Which clothing do you have?")),
              GestureDetector(
                onTap: () { print("beanie"); },
                child: Image.asset('images/beanie.png', width: 50, height: 50),
              ),
              GestureDetector(
                onTap: () { print("headphones"); },
                child: Image.asset('images/headphones.png', width: 50, height: 50),
              ),
               GestureDetector(
                onTap: () { print("jacket"); },
                child: Image.asset('images/jacket.png', width: 50, height: 50),
              ),
               GestureDetector(
                onTap: () { print("hoodie"); },
                child: Image.asset('images/hoodie.png', width: 50, height: 50),
              ),
               GestureDetector(
                onTap: () { print("t-shirt"); },
                child: Image.asset('images/t-shirt.png', width: 50, height: 50),
              ),
               GestureDetector(
                onTap: () { print("underlayer"); },
                child: Image.asset('images/underlayer.png', width: 50, height: 50),
              ),
               GestureDetector(
                onTap: () { print("pants"); },
                child: Image.asset('images/pants.png', width: 50, height: 50),
              ),
               GestureDetector(
                onTap: () { print("shorts"); },
                child: Image.asset('images/shorts.png', width: 50, height: 50),
              ),
               GestureDetector(
                onTap: () { print("socks"); },
                child: Image.asset('images/socks.png', width: 50, height: 50),
              ),
                GestureDetector(
                onTap: () { print("sneakers"); },             
                child: Image.asset('images/sneakers.png', width: 50, height: 50),
              ),
               GestureDetector(
                onTap: () { print("boots"); },
                child: Image.asset('images/boots.png', width: 50, height: 50),
              ),
               GestureDetector(
                onTap: () { print("gloves"); },
                child: Image.asset('images/gloves.png', width: 50, height: 50),
              ),
               GestureDetector(
                onTap: () { print("scarf"); },
                child: Image.asset('images/scarf.png', width: 50, height: 50),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* --- Build helper methods --- */  

}
