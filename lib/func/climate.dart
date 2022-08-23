import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import 'structure.dart';
import '../help/helper.dart';
import '../widg/profile.dart';

class Climate {

  // Profile
  //Profile profile;

  // Data for Place
  //WeatherFactory wf = WeatherFactory("30c0c86d9b62ce5e1086a153201296a8");
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

  // Weather data
  Weather cw;
  List<Weather> fc;
  String fineText;

  //bool createdBase = false;

  // Base climate constructor
  Climate(WeatherFactory wf, String location, Profile profile) {
    this.base = true;
    /*(wf, location, profile) async {
      await getWeatherAdvice(wf, location, profile);
    } (wf, location, profile);*/
  }

  // New (search) climate constructor
  Climate.newLocation(WeatherFactory wf, String location, Profile profile, fineText) {
    this.base = false;
    //this.profile = profile;
    //this.position = position;
    this.fineText = fineText;
    this.place = position;
    /*(wf, location, fineText) async {
      await getWeatherAdvice(wf, location, fineText);
    } (wf, location, fineText);*/
  }

  getWeatherAdvice(WeatherFactory wf, String location, Profile profile) async {
    /*Weather cw;
    List<Weather> fc;*/
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

    await forecast(profile);

    //createdBase = true;

    /*
    print(first.addressLine); -> whole adress
    print(first.adminArea); -> Oslo
    print(first.countryName); -> Norway
    print(first.featureName); -> adress number house
    */

    // Calculating clothing
    /*Temperature tempFull = cw.tempFeelsLike;
    double temp = tempFull.celsius;
    double rain = cw.rainLastHour;
    double snow = cw.snowLastHour;
    double humid = cw.humidity;
    if (profile == Profile.lean) { temp = temp + 6; }
    if (profile == Profile.warm) { temp = temp - 6; }
    outfit = calculateClothing(temp, rain, snow, humid);

    // Forecasting
    var time = DateTime.now();
    Map<int, int> fiveDayForecast = Map<int, int>();
    fiveDayForecast[time.hour] = temp.round();
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
      if (fiveDayForecast[i] == null) {
        fiveDayForecast[i] = w.tempFeelsLike.celsius.round();
      }
    }

    print(forecast);
    print("Temp: ${temp.round()} celsius");
    print("Ideal outfit: ");
    this.hours = tempHours;
    this.celsius = temp.round();
    forecastHalfDay = fiveDayForecast;*/
  }

  forecast(Profile profile) async {
    /*
    print(first.addressLine); -> whole adress
    print(first.adminArea); -> Oslo
    print(first.countryName); -> Norway
    print(first.featureName); -> address number house
    */

    // Calculating clothing
    Temperature tempFull = cw.tempFeelsLike;
    double temp = tempFull.celsius;
    double rain = cw.rainLastHour;
    double snow = cw.snowLastHour;
    double humid = cw.humidity;
    if (profile == Profile.lean) { temp = temp + 6; }
    if (profile == Profile.warm) { temp = temp - 6; }
    outfit = calculateClothing(temp, rain, snow, humid);

    // Forecasting
    var time = DateTime.now();
    Map<int, int> fiveDayForecast = Map<int, int>();
    fiveDayForecast[time.hour] = temp.round();
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
      if (fiveDayForecast[i] == null) {
        fiveDayForecast[i] = w.tempFeelsLike.celsius.round();
      }
    }

    print(fiveDayForecast);
    print("Temp: ${temp.round()} celsius");
    print("Ideal outfit: ");
    this.hours = tempHours;
    this.celsius = temp.round();
    forecastHalfDay = fiveDayForecast;
  }

  Set<String> modifyOutfit(newCelsius) {
    return calculateClothing(newCelsius, 0.0, 0.0, 0.0);
  }


  Set<String> calculateClothing(
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
  /*WeatherFactory wf = WeatherFactory("30c0c86d9b62ce5e1086a153201296a8");
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

  String fineText;*/

  // Might need to also call getWeatherAdvice here
  Climate.fromJson(Map<String, dynamic> json) {
    print(jsonDecode(json['latitude']));
    latitude = jsonDecode(json['latitude']);
    longitude = jsonDecode(json['longitude']);
    celsius = jsonDecode(json['celsius']);
    place = jsonDecode(json['place']);
    outfit = jsonDecode(json['outfit']);
    position = jsonDecode(json['position']);
    forecastHalfDay = jsonDecode(json['forecastHalfDay']);
    hours = jsonDecode(json['hours']);
    base = jsonDecode(json['base']);
    cw = jsonDecode(json['cw']);
    fc = jsonDecode(json['fc']);
    fineText = jsonDecode(json['fineText']);
  }

  /*Map toJson() => {
    'latitude': latitude.toString(),
    'longitude': longitude.toString(),
    'celsius': celsius.toString(),
    'place': place.toString(),
    'outfit': outfit.toString(),
    'position': position.toString(),
    'forecastHalfDay': forecastHalfDay.toString(),
    'hours': hours.toString(),
    'base': base.toString(),
    'fineText': fineText.toString(),
  };*/

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> climate = Map<String, dynamic>();
    print("${this.latitude}");
    print("${this.longitude}");
    print("${this.celsius}");
    print("${this.place}");
    print("${this.outfit}");
    print("${this.position}");
    print("${this.forecastHalfDay}");
    print("${this.hours}");
    print("${this.base}");
    print("${this.cw}");
    print("${jsonEncode(this.fc)}");
    print("${this.fineText}");
    climate["latitude"] = jsonEncode(this.latitude);
    climate["longitude"] = jsonEncode(this.longitude);
    climate["celsius"] = jsonEncode(this.celsius);
    climate["place"] = jsonEncode(this.place);
    climate["outfit"] = jsonEncode(this.outfit);
    climate["position"] = jsonEncode(this.position);
    climate["forecastHalfDay"] = jsonEncode(this.forecastHalfDay);
    climate["hours"] = jsonEncode(this.hours);
    climate["base"] = jsonEncode(this.base);
    climate["cw"] = jsonEncode(this.cw);
    climate["fc"] = jsonEncode(this.fc);
    climate["fineText"] = jsonEncode(this.fineText);
    return climate;
  }


}
