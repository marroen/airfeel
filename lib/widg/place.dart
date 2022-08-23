import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:fpdart/fpdart.dart' as fp;

//import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:geocoding/geocoding.dart';
import 'package:localstorage/localstorage.dart';

//import '../func/climate.dart';
import '../func/climate2.dart';
import '../help/helper.dart';
import 'profile.dart';
import 'loading.dart';

class Replace extends Notification {
  final String location;
  const Replace({this.location});
}

class Place extends StatefulWidget {
  // WeatherFactory
  //final WeatherFactory wf;
  final fp.Option<String> rawText;
  final Profile profile;
  final Stream stream;
  final LocalStorage storage;

  const Place({Key key, this.rawText, this.profile, this.stream, this.storage}) : 
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PlaceState();
  }
}



class PlaceState extends State<Place> {

  // Profile
  Profile profile;//Profile.standard;

  // WeatherFactory
  WeatherFactory wf = WeatherFactory("30c0c86d9b62ce5e1086a153201296a8");

  // Base climate - should be in Place
  Climate2 climate;
  Set<String> outfit;
  bool createdClimate = false;
  List<ButtonStyle> bStyles = [];
  bool selected = false;
  int selectedIdx = -1;
  //bool pressed = false;
  //Forecast forecast = Forecast();

  // Ensure climate is loaded before displaying to feel-page.
  void initState() {
    super.initState();
    profile = widget.profile;
    widget.stream.listen(updateClimate);
    () async {
      if (await widget.storage.getItem('climate') != null) {
        print(widget.storage.hashCode);
        var json = await widget.storage.getItem('climate');
        print(json.toString());
        climate = Climate2.fromJson(json);
        outfit = climate.calculateClothing(climate.currWeather.tempFeelsLike.celsius);
      } else {
        climate = await Climate2.create(wf, widget.rawText);
        outfit = climate.calculateClothing(climate.currWeather.tempFeelsLike.celsius);
        await widget.storage.setItem('climate', climate);
      }

      // Launching place after creating climate
      if (this.mounted) setState(() {
        createdClimate = true;
      });
    } ();
  }

  // Method called on every sink
  updateClimate(location) async {
    print(location);

    () async {
      Climate2 newClimate = await Climate2.create(wf, fp.some(location));
      outfit = newClimate.calculateClothing(newClimate.currWeather.tempFeelsLike.celsius);
      await widget.storage.setItem('climate', newClimate);
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
      Text("${climate.currWeather.areaName}",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
      //if (outfit != null)
        Column(
          children: presentOutfit(outfit),
        ),
      ];
    }
  }

  _getCelsius() {
    int celsius = climate.currWeather.tempFeelsLike.celsius.round();
    if (celsius < 10 && celsius > 0)
      return "$celsius°";
    else
      return "$celsius°";
  }


  List<TextButton> presentForecast() {
    List<TextButton> texts = [];
    int counter = 0;
    Map<int,int> forecastHalfDay = climate.forecast(widget.profile);
    for (var hourDegree in forecastHalfDay.entries) {
      ForecastItem item = ForecastItem(counter);
      counter++;
      ButtonStyle bStyle = TextButton.styleFrom(
        primary: Colors.black,
        textStyle: TextStyle(fontWeight: FontWeight.bold)
      );
      bStyles.add(bStyle);
      item.insert(bStyle);
      TextButton textButton = TextButton(
        child: Text("${hourDegree.key}: ${hourDegree.value}°"),
        style: bStyles[item.idx],
        onPressed: () {
          //print("selectedIdx: ${selectedIdx}");
          if (selected && item.idx == selectedIdx) {
            setState(() {
              bStyles[item.idx] = TextButton.styleFrom(
                primary: Colors.black,
                textStyle: TextStyle(fontWeight: FontWeight.bold)
              );
              outfit = climate.calculateClothing(climate.currWeather.tempFeelsLike.celsius);
              selected = false;
              selectedIdx = -1;
            });
          } else if (!selected) {
            setState(() {
              bStyles[item.idx] = TextButton.styleFrom(
                primary: Colors.red,
                textStyle: TextStyle(fontWeight: FontWeight.bold)
              );
              //outfit = climate.modifyOutfit(hourDegree.value.toDouble());
              outfit = climate.calculateClothing(hourDegree.value.toDouble());
              //print(outfit);
              //print(climate.outfit);
              selected = true;
              selectedIdx = item.idx;
            });
          }
        },
      );

      texts.add(textButton);
      //forecast.add(item); // ?
    }

    /*ctrl.stream.listen(
      (ForecastItem item) {
        print(item.idx);
      }
    );*/

    return texts;
  }

  List<Image> presentOutfit(outfit) {
    List<Image> images = [];
    for (var piece in outfit) {
      images.add(Image.asset('images/${piece.toLowerCase()}.png', width: 50, height: 50));
    }
    return images;
  }

}

class Forecast {
  List<ForecastItem> items = [];
  Forecast();
  add(item) { items.add(item); }
}

class ForecastItem {
  int idx;
  ButtonStyle bStyle;
  ForecastItem(this.idx);
  insert(bStyle) { this.bStyle = bStyle; }
  select() {
    print(idx); 
  }
}

