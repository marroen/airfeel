import 'dart:collection';

//import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:geocoder/geocoder.dart';

import 'climate.dart';
import 'main.dart';

class Location extends StatefulWidget {
  final int celsius;
  final String name;
  final Set<String> outfit;
  final Map<int, int> forecast;
  final List<int> hours;

  const Location(
      {Key key,
      this.celsius,
      this.name,
      this.outfit,
      this.forecast,
      this.hours})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LocationState();
  }
}

class LocationState extends State<Location> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
      Text(
        "${widget.celsius}°",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 120),
      ),
      Column(
        children: [
          Text("${widget.hours[1]}: ${widget.forecast[widget.hours[1]]}°"),
          Text("${widget.hours[2]}: ${widget.forecast[widget.hours[2]]}°"),
          Text("${widget.hours[3]}: ${widget.forecast[widget.hours[3]]}°"),
          Text("${widget.hours[4]}: ${widget.forecast[widget.hours[4]]}°"),
          Text("${widget.hours[5]}: ${widget.forecast[widget.hours[5]]}°")
        ],
      ),
      Text("${widget.name}",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
      if (widget.outfit != null)
        Column(
          children: [
            //for (Image piece in this.outfit) piece,
            if (widget.outfit.contains('Beanie'))
              Image.asset('images/beanie.png', width: 50, height: 50),
            //if (widget.outfit.contains('Headphones'))
              //Image.asset('images/headphones.png', width: 50, height: 50), removed until wardrobe is implemented
            if (widget.outfit.contains('Jacket'))
              Image.asset('images/jacket.png', width: 50, height: 50),
            if (widget.outfit.contains('Hoodie'))
              Image.asset('images/hoodie.png', width: 50, height: 50),
            if (widget.outfit.contains('T-shirt'))
              Image.asset('images/t-shirt.png', width: 50, height: 50),
            if (widget.outfit.contains('Underlayer'))
              Image.asset('images/underlayer.png', width: 50, height: 50),
            if (widget.outfit.contains('Pants'))
              Image.asset('images/pants.png', width: 50, height: 50),
            if (widget.outfit.contains('Shorts'))
              Image.asset('images/shorts.png', width: 50, height: 50),
            if (widget.outfit.contains('Thick socks'))
              Image.asset('images/thicksocks.png', width: 50, height: 50),
            if (widget.outfit.contains('Sneakers'))
              Image.asset('images/sneakers.png', width: 50, height: 50),
            if (widget.outfit.contains('Boots'))
              Image.asset('images/boots.png', width: 50, height: 50),
            if (widget.outfit.contains('Gloves'))
              Image.asset('images/gloves.png', width: 50, height: 50),
            if (widget.outfit.contains('Scarf'))
              Image.asset('images/scarf.png', width: 50, height: 50),
          ],
          //shrinkWrap: true,
        ),
    ]);
  }
}
