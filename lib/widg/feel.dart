import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' as fp;
import 'package:weather/weather.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:localstorage/localstorage.dart';

//import '../func/climate.dart';
import '../func/climate2.dart';
import '../func/structure.dart';
import '../help/helper.dart';
import 'place.dart';
import 'searcher.dart';
import 'loading.dart';
import 'wardrobe.dart';
import 'profile.dart';

// Main page of the app
class Feel extends StatefulWidget {
  //final LocalStorage storage = new LocalStorage('key');

  @override
  State<StatefulWidget> createState() => FeelState();
}

class FeelState extends State<Feel> {

  // Session
  var session = SessionManager();

  // Profile
  Profile profile = Profile.standard;

  // WeatherFactory
  WeatherFactory wf = WeatherFactory("30c0c86d9b62ce5e1086a153201296a8");

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

  final LocalStorage baseStorage = LocalStorage('base');
  final LocalStorage newStorage = LocalStorage('new');

  // Stream logic
  StreamController<String> baseCtrl;
  StreamController<String> newCtrl;
 
  // Ensure climate is loaded before displaying to feel-page.
  void initState() {
    super.initState();
    baseCtrl = StreamController.broadcast();
    newCtrl = StreamController.broadcast();
    baseStorage.dispose();
    newStorage.dispose();
    if (this.mounted) setState(() {
      place = Place(rawText: fp.none(), profile: profile, stream: baseCtrl.stream,
                    storage: baseStorage);
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
              place = Place(rawText: place.rawText, profile: profile, storage: baseStorage);
              if (createdNewPlace) {
                newPlace = Place(rawText: newPlace.rawText, profile: profile,
                                 storage: newStorage);
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
      place = Place(rawText: place.rawText, profile: profile, storage: baseStorage);
      if (createdNewPlace) {
        newPlace = Place(rawText: newPlace.rawText, profile: profile, storage: newStorage);
      }
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

    print("placeText after searcher: $placeText");
    if (places.length < maxPlaces) {
      await newStorage.setItem('climate', await Climate2.create(wf, fp.some(placeText)));
      newPlace = Place(rawText: fp.some(placeText), profile: profile, stream: newCtrl.stream,
                       storage: newStorage);
      places.add(newPlace);
    } else { newCtrl.sink.add(placeText); }
    setState(() {
      createdNewPlace = true;
    });
  } 
}
