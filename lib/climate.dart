import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:geocoding/geocoding.dart';

import 'structure.dart';
import 'helper.dart';
import 'profile.dart';

class Climate {

  // Profile
  //Profile profile;

  // Data for Place
  WeatherFactory wf = WeatherFactory("30c0c86d9b62ce5e1086a153201296a8");
  double latitude;
  double longitude;
  int celsius;
  String place;
  var outfit;
  var position;

  // Forecasting
  Map<int, int> forecastHalfDay;
  List<int> hours;
  
  // Check if base or new location
  bool base;

  String fineText;

  // Base climate constructor
  Climate() {
    this.base = true;
    //this.profile = profile;
  }

  // New (search) climate constructor
  Climate.newLocation(fineText) {
    this.base = false;
    //this.profile = profile;
    //this.position = position;
    this.fineText = fineText;
    this.place = position;
  }

  getWeatherAdvice(String location, Profile profile) async {//({base = true, position}) async {
    Weather cw;
    List<Weather> fc;
    if (base) {
      position = await determinePosition();
      latitude = position.latitude;
      longitude = position.longitude;
      cw = await wf.currentWeatherByLocation(latitude, longitude);
      fc = await wf.fiveDayForecastByLocation(latitude, longitude);
      List<Placemark> addresses =
          await placemarkFromCoordinates(latitude, longitude);
      var first = addresses.first;
      this.place = first.administrativeArea;
      this.fineText = this.place;
    } else {
      cw = await wf.currentWeatherByCityName(location);
      fc = await wf.fiveDayForecastByCityName(location);
    }

    /*
    print(first.addressLine); -> whole adress
    print(first.adminArea); -> Oslo
    print(first.countryName); -> Norway
    print(first.featureName); -> adress number house
    */

    // Calculating clothing
    Temperature tempFull = cw.tempFeelsLike;
    double temp = tempFull.celsius;
    double rain = cw.rainLastHour;
    double snow = cw.snowLastHour;
    double humid = cw.humidity;
    if (profile == Profile.lean) { temp = temp + 6; }
    if (profile == Profile.warm) { temp = temp - 6; }
    outfit = _calculateClothing(temp, rain, snow, humid);

    // Forecasting
    var time = DateTime.now();
    Map<int, int> forecast = Map<int, int>();
    forecast[time.hour] = temp.round();
    int i = time.hour + 1;
    List<int> tempHours = [];
    tempHours.add(i - 1);

    // Forecast logic
    bool firstSkip = true;
    for (Weather w in fc) {
      if (firstSkip) {
        firstSkip = false;
        continue;
      }
      i += 3;
      if (i >= 24) {
        i = (i - 24);
      }
      tempHours.add(i);
      if (forecast[i] == null) {
        forecast[i] = w.tempFeelsLike.celsius.round();
      }
    }

    print(forecast);
    print("Temp: ${temp.round()} celsius");
    print("Ideal outfit: ");
    this.hours = tempHours;
    this.celsius = temp.round();
    forecastHalfDay = forecast;
  }

  Set<String> _calculateClothing(
      double temp, double rain, double snow, double humid) {
    Set<String> outfit = {};
    outfit.addAll(
        ['T-shirt', 'Pants', 'Hoodie', 'Sneakers', 'Jacket', 'Headphones']);

    // negative temp logic
    if (temp < 0) {
      outfit.add('Gloves');
      if (temp < -4) {
        outfit.remove('T-shirt');
        outfit.add('Underlayers');
        // rain and snow logic
        if (rain > 0.0 || snow > 0.0) {
          outfit.add('Beanie');
        }
      }
      if (temp < -8) {
        outfit.addAll(['Socks', 'Beanie', 'Scarf']);
      }
    // positive temp logic
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

}
