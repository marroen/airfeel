import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
//import 'package:tuple/tuple.dart';

import 'package:weather/weather.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import 'structure.dart';
import '../help/helper.dart';
import '../widg/profile.dart';

class Climate2 {
  final Weather currWeather;
  final List<Weather> forecastFiveDays;
  Climate2._create(this.currWeather, this.forecastFiveDays);
  Climate2.fromJson(Map<String,dynamic> json) :
    currWeather = json["currWeather"],
    forecastFiveDays = json["forecastFiveDays"];

  static Future<Climate2> create(wf, Option<String> newLocation) async {
    
    Tuple2<Weather, List<Weather>> weather = await ((wf) async { 
      Weather currWeather;
      List<Weather> forecastFiveDays;
      await newLocation.match(
        (a) async {
          currWeather = await wf.currentWeatherByCityName(a);
          forecastFiveDays = await wf.fiveDayForecastByCityName(a);
        },
        () async {
          Position position = await determinePosition();
          double lat = position.latitude;
          double lon = position.longitude;
          currWeather = await wf.currentWeatherByLocation(lat, lon);
          forecastFiveDays = await wf.fiveDayForecastByLocation(lat, lon);
          //String place = (await placemarkFromCoordinates(lat, lon)).first.administrativeArea;
          //String fineText = place; // Ankara
        },
      );
      return Tuple2<Weather, List<Weather>>(currWeather, forecastFiveDays);
    } (wf));

    Climate2 climate = Climate2._create(weather.first, weather.second);
    return climate;
  }

  Map<int,int> forecast(Profile profile) {
    Temperature tempFull = this.currWeather.tempFeelsLike;
    double temp = tempFull.celsius;
    DateTime time = DateTime.now();
    Map<int,int> forecast = Map<int, int>();
    forecast[time.hour] = temp.round();
    int i = time.hour + 1;
    List<int> tempHours = [];
    tempHours.add(i-1);

    bool firstSkip = true;
    for (Weather w in forecastFiveDays) {
      if (firstSkip) {
        firstSkip = false;
        continue;
      }
      i += 3;
      if (i >= 24) {
        i = (i-24);
      }
      tempHours.add(i);
      if (forecast[i] == null) {
        forecast[i] = w.tempFeelsLike.celsius.round();
      }
    }
    return forecast;
  }

  Set<String> calculateClothing(temp) {
    Set<String> outfit = {};
    outfit.addAll(
      ['T-shirt', 'Pants', 'Hoodie', 'Sneakers', 'Jacket', 'Headphones']);

    double rain = this.currWeather.rainLastHour;
    double snow = this.currWeather.snowLastHour;
    //double humid = this.currWeather.humidity;

    // Negative temp logic
    if (temp < 0) {
      outfit.add('Gloves');
      if (temp < -4) {
        outfit.remove('T-shirt');
        outfit.add('Underlayers');
        // Rain and snow logic
        if (rain > 0.0 || snow > 0.0) {
          outfit.add('Beanie');
        }
      }
      if (temp < -8) {
        outfit.addAll(['Socks', 'Beanie', 'Scarf']);
      }

    // Positive temp logic
    } else {
      if (rain > 0.0 || snow > 0.0) {
        outfit.addAll(['Jacket', 'Beanie']);
      }
      if (temp > 4) {
        outfit.remove('Headphones');
        if (rain == 0.0 || snow == 0.0) {
          outfit.remove('Jacket');
        }
      }
      if (temp > 8) {
        outfit.remove('Jacket');
        if (rain == 0.0 || snow == 0.0) {
          outfit.remove('Beanie');
        }
      }
      if (temp > 16) {
        outfit.remove('Hoodie');
      }
      if (temp > 18) {
        outfit.remove('Pants');
        outfit.add('Shorts');
      }
      if (temp > 22) {
        outfit.remove('Sneakers');
      }
      if (temp > 32) {
        outfit.remove('T-shirt');
      }
    }

    return outfit;
  }

  Map<String,dynamic> toJson() {
    final Map<String,dynamic> climate = Map<String,dynamic>();
    climate["currWeather"] = this.currWeather;
    climate["forecastFiveDays"] = this.forecastFiveDays;
    return climate;
  }
}
