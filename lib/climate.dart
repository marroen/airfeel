import 'dart:collection';

//import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:geocoder/geocoder.dart';

import 'location.dart';

class Climate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // need one more of these
    return ClimateState();
  }
}

class ClimateState extends State<Climate> {
  // base climate
  WeatherFactory wf = WeatherFactory("30c0c86d9b62ce5e1086a153201296a8");
  double latitude;
  double longitude;
  int celsius;
  String place;
  var outfit;

  // forecasting
  Map<int, int> forecastHalfDay;
  List<int> hours;

  // new climate
  List<int> newHours;
  String rawText;
  String newLocation;
  String fineText;
  int newCelsius;
  Map<int, int> newForecast;
  var newOutfit;

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
    //print("Reloading...");
    //print("Weather feels like: ");
    if (outfit == null) {
      _getWeatherAdvice();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Airfeel", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              print("Reloading...");
              print("Weather feels like: ");
              _getWeatherAdvice();
              if (this.rawText != null) {
                _findNewLocation(this.rawText);
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // if the current location is available
            this.celsius != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${this.celsius}°",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 120),
                            ),
                            Column(children: [
                              Text(
                                  "${hours[1]}: ${forecastHalfDay[hours[1]]}°"),
                              Text(
                                  "${hours[2]}: ${forecastHalfDay[hours[2]]}°"),
                              Text(
                                  "${hours[3]}: ${forecastHalfDay[hours[3]]}°"),
                              Text(
                                  "${hours[4]}: ${forecastHalfDay[hours[4]]}°"),
                              Text(
                                  "${hours[5]}: ${forecastHalfDay[hours[5]]}°"),
                            ]),
                            if (this.place != null)
                              Text("${this.place}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32)),
                            if (this.outfit != null &&
                                this.forecastHalfDay != null)
                              Column(
                                children: [
                                  //for (Image piece in this.outfit) piece,
                                  if (this.outfit.contains('Beanie'))
                                    Image.asset('images/beanie.png',
                                        width: 50, height: 50),
                                  //if (this.outfit.contains('Headphones')) removed until wardrobe is implemented
                                    //Image.asset('images/headphones.png',
                                        //width: 50, height: 50),
                                  if (this.outfit.contains('Jacket'))
                                    Image.asset('images/jacket.png',
                                        width: 50, height: 50),
                                  if (this.outfit.contains('Hoodie'))
                                    Image.asset('images/hoodie.png',
                                        width: 50, height: 50),
                                  if (this.outfit.contains('T-shirt'))
                                    Image.asset('images/t-shirt.png',
                                        width: 50, height: 50),
                                  if (this.outfit.contains('Underlayer'))
                                    Image.asset('images/underlayer.png',
                                        width: 50, height: 50),
                                  if (this.outfit.contains('Pants'))
                                    Image.asset('images/pants.png',
                                        width: 50, height: 50),
                                  if (this.outfit.contains('Shorts'))
                                    Image.asset('images/shorts.png',
                                        width: 50, height: 50),
                                  if (this.outfit.contains('Thick socks'))
                                    Image.asset('images/thicksocks.png',
                                        width: 50, height: 50),
                                  if (this.outfit.contains('Sneakers'))
                                    Image.asset('images/sneakers.png',
                                        width: 50, height: 50),
                                  if (this.outfit.contains('Boots'))
                                    Image.asset('images/boots.png',
                                        width: 50, height: 50),
                                  if (this.outfit.contains('Gloves'))
                                    Image.asset('images/gloves.png',
                                        width: 50, height: 50),
                                  if (this.outfit.contains('Scarf'))
                                    Image.asset('images/scarf.png',
                                        width: 50, height: 50),
                                ],
                                //shrinkWrap: true,
                              ),
                          ]),

                      // comparison location is available
                      if (this.newLocation != null)
                        Location(
                            celsius: this.newCelsius,
                            name: this.fineText,
                            outfit: this.newOutfit,
                            forecast: this.newForecast,
                            hours: this.newHours
                        )
                    ],
                  )
                // if not available, display loading screen
                : CircularProgressIndicator(),

            // display comparison textfield if current location is available
            if (this.celsius != null)
              TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: 'Where are you going?'),
                onSubmitted: (text) {
                  _findNewLocation(text);
                  _getWeatherAdvice();
                },
              ),
            //if (this.newLocation != null) Location(celsius: this.newCelsius),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: 'Feel', icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: 'Wardrobe', icon: Icon(Icons.home))
        ],
        currentIndex: 1,
      ),
    );
  }

  _findNewLocation(String location) async {
    // async {
    this.rawText = location;
    location =
        location[0].toUpperCase() + location.substring(1, location.length);

    // spacing magic
    if (location.contains(' ')) {
      for (int i = 0; i < location.length; i++) {
        if (location[i] == ' ') {
          location = location.substring(0, i + 1) +
              location[i + 1].toUpperCase() +
              '.';
              //location.substring(i + 2, location.length);
        }
      }
    }
    this.fineText = location;
    print("location: ${location}");

    await _getWeatherAdvice(base: false, position: this.rawText);
    print(this.newForecast);
    /*
    setState(() {
      this.newLocation = this.rawText;
      if (cw.tempFeelsLike != null) {
        this.newCelsius = cw.tempFeelsLike.celsius.round();
      }
    });
    */
  }

  _getWeatherAdvice({base = true, position}) async {
    Weather cw;
    List<Weather> fc;
    if (position == null) {
      position = await _determinePosition();
      latitude = position.latitude;
      longitude = position.longitude;
      cw = await wf.currentWeatherByLocation(latitude, longitude);
      fc = await wf.fiveDayForecastByLocation(latitude, longitude);
      final coordinates = new Coordinates(latitude, longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      this.place = first.adminArea;
    } else {
      cw = await wf.currentWeatherByCityName(position);
      fc = await wf.fiveDayForecastByCityName(position);
    }

    /*
    print(first.addressLine); -> whole adress
    print(first.adminArea); -> Oslo
    print(first.countryName); -> Norway
    print(first.featureName); -> adress number house
    */

    Temperature temp = cw.tempFeelsLike;
    double rain = cw.rainLastHour;
    double snow = cw.snowLastHour;
    double humid = cw.humidity;
    Set<String> outfit = _calculateClothing(temp, rain, snow, humid);

    var time = DateTime.now();

    Map<int, int> forecast = Map<int, int>();

    forecast[time.hour] = temp.celsius.round();

    int i = time.hour + 1;
    List<int> tempHours = [];
    tempHours.add(i - 1);

    //print(fc);
    bool firstSkip = true;
    int turns = 0;
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
      turns += 1;
      // if (turns == x) {}
    }

    print(forecast);

    print("Temp: ${temp.celsius.round()} celsius");
    print("Ideal outfit: ");
    print(outfit);

    setState(() {
      //hours = tempHours; // possible issue
      if (base) {
        this.hours = tempHours;
        this.celsius = temp.celsius.round();
        forecastHalfDay = forecast;
        this.outfit = outfit;
      } else {
        this.newLocation = position;
        this.newForecast = forecast;
        this.newOutfit = outfit;
        this.newCelsius = temp.celsius.round();
        this.newHours = tempHours;
      }
    });

    //return cw.tempFeelsLike;
  }

  Set<String> _calculateClothing(
      Temperature temp, double rain, double snow, double humid) {
    Set<String> outfit = {};
    outfit.addAll(
        ['T-shirt', 'Pants', 'Hoodie', 'Sneakers', 'Jacket', 'Headphones']);

    // negative temp logic
    if (temp.celsius < 0) {
      outfit.add('Gloves');
      if (temp.celsius < -4) {
        outfit.remove('T-shirt');
        outfit.add('Underlayers');
        // rain and snow logic
        if (rain > 0.0 || snow > 0.0) {
          outfit.add('Beanie');
        }
      }
      if (temp.celsius < -8) {
        outfit.addAll(['Thick socks', 'Beanie', 'Scarf']);
      }
    // positive temp logic
    } else {
      if (rain > 0.0 || snow > 0.0) {
        outfit.addAll(['Jacket', 'Beanie']);
      }
      if (temp.celsius > 4) {
        outfit.remove('Headphones');
        if (rain == 0.0 || snow == 0.0) {
          outfit.remove('Jacket');
        }
      }
      if (temp.celsius > 8) {
        outfit.remove('Jacket');
        if (rain == 0.0 || snow == 0.0) {
          outfit.remove('Beanie');
        }
      }
      if (temp.celsius > 14) {
        outfit.remove('Hoodie');
      }
      if (temp.celsius > 18) {
        outfit.remove('Pants');
        outfit.add('Shorts');
      }
      if (temp.celsius > 22) {
        outfit.remove('Sneakers');
      }
      if (temp.celsius > 32) {
        outfit.remove('T-shirt');
      }
    }

    setState(() {
      //this.outfit = outfit;
    });

    return outfit;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
