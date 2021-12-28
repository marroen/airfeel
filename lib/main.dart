import 'dart:collection';

//import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:geocoder/geocoder.dart';

import 'climate.dart';
import 'location.dart';

void main() => runApp(Home());

class Home extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airfeel',
      theme: ThemeData(
        primaryColor: Colors.red,
        backgroundColor: Colors.white,
        canvasColor: Colors.orange,
      ),
      home: Climate(),
    );
  }
}
