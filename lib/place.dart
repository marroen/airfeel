import 'dart:collection';

//import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:geocoding/geocoding.dart';

import 'climate.dart';
import 'profile.dart';
import 'loading.dart';
import 'helper.dart';

class Replace extends Notification {
  final String location;
  const Replace({this.location});
}

class Place extends StatefulWidget {
  final String rawText;
  final Profile profile;
  final Stream stream;

  const Place({Key key, this.rawText, this.profile, this.stream}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PlaceState();
  }
}



class PlaceState extends State<Place> {

  // Profile
  Profile profile;//Profile.standard;

  // Base climate - should be in Place
  Climate climate;
  bool createdClimate = false;

  // Ensure climate is loaded before displaying to feel-page.
  void initState() {
    super.initState();
    profile = widget.profile;
    widget.stream.listen(updateClimate);
    () async {
      // Base climate
      if (widget.rawText == "") {
        climate = Climate();
        await climate.getWeatherAdvice(widget.rawText, profile);
      // New climate
      } else {
        climate = Climate.newLocation(trimName(widget.rawText));
        await climate.getWeatherAdvice(widget.rawText, profile);
      }
      if (this.mounted) setState(() {
        createdClimate = true;
      });
    } ();
  }

  // Method called on every sink
  updateClimate(location) {
    print(location);

    () async {
      Climate newClimate = Climate.newLocation(trimName(location));
      await newClimate.getWeatherAdvice(location, profile);
      if (this.mounted) setState(() {
        climate = newClimate;
      });
    } ();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _getPlace(),
    );
  }

  /* --- Build helper methods --- */

  _getPlace() {
    if (createdClimate == false)
      return [Loading()];
    else {
      return [FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          _getCelsius(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 100),
        ),
      ),
      Column(
        children: presentForecast(),
      ),
      Text("${climate.fineText}",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
      if (climate.outfit != null)
        Column(
          children: presentOutfit(),
        ),
      ];
    }
  }

  _getCelsius() {
    if (climate.celsius < 10 && climate.celsius > 0)
      return "${climate.celsius}°";
    else
      return "${climate.celsius}°";
  }


  List<TextButton> presentForecast() {
    List<TextButton> texts = [];
    for (var hourDegree in climate.forecastHalfDay.entries) {;
      TextButton text = TextButton(
        child: Text("${hourDegree.key}: ${hourDegree.value}°"),
        style: TextButton.styleFrom(
          primary: Colors.black,
          textStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          /*
          setState(() {
          });*/
        },
      );
      
      texts.add(text);
    }
    return texts;
  }

  List<Image> presentOutfit() {
    List<Image> images = [];
    for (var piece in climate.outfit) {
      images.add(Image.asset('images/${piece.toLowerCase()}.png', width: 50, height: 50));
    }
    //Image.asset('images/scarf.png', width: 50, height: 50);
    return images;
  }

}
