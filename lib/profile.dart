import 'package:flutter/material.dart';
import 'helper.dart';

class Profile extends StatefulWidget {
  State<StatefulWidget> createState () {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            Text("hi"),
          ]
        ),
      ),
    );
  }
}
