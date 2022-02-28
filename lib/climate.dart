//import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:geocoding/geocoding.dart';
//import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'place.dart';
import 'helper.dart';
import 'searcher.dart';
import 'loading.dart';
import 'wardrobe.dart';
import 'profile.dart';

class Climate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // Need one more of these
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

  // Forecasting
  Map<int, int> forecastHalfDay;
  List<int> hours;

  // New climate
  List<int> newHours;
  String rawText;
  String newLocation;
  String fineText;
  int newCelsius;
  Map<int, int> newForecast;
  var newOutfit;

  // New location
  String currPlace;
  String placeText;

  // Bar navigation
  PageIdx _currentPage = PageIdx.feel;
  List<Widget> _pages = <Widget>[];


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
      //backgroundColor: Colors.red[900],
      appBar: AppBar(
        title: Text("Airfeel", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[900],
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
      body: _getBody(),              
      persistentFooterButtons: [
        //if (this.celsius != null && _currentPage == PageIdx.feel)
        if (_currentPage == PageIdx.feel)
          TextField(
            textAlign: TextAlign.center,
            onTap: () {
              _getText();
            },
            readOnly: true,
            cursorColor: Colors.red[900],
            style: TextStyle(
              color: Colors.red[900],
              decorationColor: Colors.red[900],
            ),
            decoration: InputDecoration(
              hintText: "Where are you going?",
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red[900], width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red[900], width: 0.0),
              ),
            ),
          ),
      ],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          _onItemTapped(idx);
        },
        items: [
          BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person)),
          BottomNavigationBarItem(label: 'Feel', icon: Icon(Icons.air)),
          BottomNavigationBarItem(label: 'Wardrobe', icon: Icon(Icons.table_rows))
        ],
        currentIndex: _currentPage.index,
        fixedColor: Colors.red[900],
      ),
    );
  }

  _getBody() {
    if (this.celsius == null)
      return Loading();
    else {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // if the current location is available
            if (this.celsius != null && _currentPage == PageIdx.feel)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Place(
                    celsius: this.celsius,
                    name: this.place,
                    outfit: this.outfit,
                    forecast: this.forecastHalfDay,
                    hours: this.hours,
                  ),
                  // comparison location is available
                  if (this.newLocation != null)
                    Place(
                        celsius: this.newCelsius,
                        name: this.fineText,
                        outfit: this.newOutfit,
                        forecast: this.newForecast,
                        hours: this.newHours
                    )
                ],
              ),

            if (this.celsius == null && _currentPage == PageIdx.feel)
              Loading(),

            if (_currentPage == PageIdx.wardrobe)
                Wardrobe(),
            if (_currentPage == PageIdx.profile)
                Profile(),
          ],
        ),
      );
    }
  }


  _onItemTapped(idx) {
    setState(() {
      _currentPage = PageIdx.values[idx];
    });
  }

  _getText() async {
    placeText = await Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Searcher()
                      ));
    _findNewLocation(placeText);
    //_getWeatherAdvice();
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
      position = await determinePosition();
      latitude = position.latitude;
      longitude = position.longitude;
      cw = await wf.currentWeatherByLocation(latitude, longitude);
      fc = await wf.fiveDayForecastByLocation(latitude, longitude);
      final coordinates = new Coordinates(latitude, longitude);
      List<Placemark> addresses =
          await placemarkFromCoordinates(latitude, longitude);
      var first = addresses.first;
      this.place = first.administrativeArea;
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
}

