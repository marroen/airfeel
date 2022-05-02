import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:geocoding/geocoding.dart';

import 'climate.dart';
import 'place.dart';
import 'structure.dart';
import 'helper.dart';
import 'searcher.dart';
import 'loading.dart';
import 'wardrobe.dart';
import 'profile.dart';


class Feel extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => FeelState();
}

class FeelState extends State<Feel> {

  // Profile
  Profile profile = Profile.standard;

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

  // Place logic
  Place place;// = Place();
  bool createdPlace = false;
  
  Place newPlace;
  bool createdNewPlace = false;

  List<Place> places = [];
  final int maxPlaces = 2;

  // Stream logic
  StreamController<String> baseCtrl;
  StreamController<String> newCtrl;
 
  // Ensure climate is loaded before displaying to feel-page.
  void initState() {
    super.initState();
    baseCtrl = StreamController.broadcast();
    newCtrl = StreamController.broadcast();
    if (this.mounted) setState(() {
      place = Place(rawText: "", profile: profile, stream: baseCtrl.stream);
      places.add(place);
      createdPlace = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Airfeel", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(primary: Colors.white),
            child: Text("Profile"),
            onPressed: () {
              _getProfile();
            },
          ),

          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              print("Reloading...");
              print("Weather feels like: ");
              place = Place(rawText: place.rawText, profile: profile);
              if (createdNewPlace) {
                newPlace = Place(rawText: newPlace.rawText, profile: profile);
              }
            },
          )
        ],
      ),
      body: _getBody(),
      persistentFooterButtons: [
        if (_currentPage == PageIdx.feel)
          TextField(
            textAlign: TextAlign.center,
            onTap: () {
              _getNewLocation();
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
          BottomNavigationBarItem(label: 'X', icon: Icon(Icons.person)),
          BottomNavigationBarItem(label: 'Feel', icon: Icon(Icons.air)),
          BottomNavigationBarItem(label: 'Wardrobe', icon: Icon(Icons.table_rows))
        ],
        currentIndex: _currentPage.index,
        fixedColor: Colors.red[900],
      ),
    );
  }

  /* --- Build helper methods --- */

  // TODO: Check if works
  _getProfile() async {
    Profile oldProfile = profile;
    profile = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => ProfilePage()
    ));
    if (oldProfile != profile) {
      place = Place(rawText: place.rawText, profile: profile);
      if (createdNewPlace) { newPlace = Place(rawText: newPlace.rawText, profile: profile); }
    }
  }

  _getBody() {
    if (_currentPage == PageIdx.feel) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: places,
            ),
          ],
        ),
      );
    } else if (_currentPage == PageIdx.wardrobe) {
      return Wardrobe();
    }
  } 


  _onItemTapped(idx) {
    setState(() {
      _currentPage = PageIdx.values[idx];
    });
  }

  _getNewLocation() async {
    placeText = await Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Searcher()
                      ));

    if (places.length < maxPlaces) {
      newPlace = Place(rawText: placeText, profile: profile, stream: newCtrl.stream);
      places.add(newPlace);
    } else { newCtrl.sink.add(placeText); }
    setState(() {
      createdNewPlace = true;
    });
  } 
}
