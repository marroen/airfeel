import 'package:flutter/material.dart';
import 'structure.dart';
import 'helper.dart';

enum Profile {
  lean,
  standard,
  warm,
}

// Page for selecting ideal profile of the user
class ProfilePage extends StatefulWidget {

  State<StatefulWidget> createState () {
    return ProfileState();
  }
}

class ProfileState extends State<ProfilePage> {
  int _selectedIndex = 0;

  @override
  /*Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        title: Text('Item $index'),
        selected: index == _selectedIndex,
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200.0,
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: ListTile(
                    title: Text('${Profile.values[index]}'),
                    selected: index == _selectedIndex,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          TextButton(
            child: Text("Done"),
            onPressed: () {
              Navigator.pop(context, Profile.values[_selectedIndex]);
            }
          ),
        ],
      ),
    );
  }
}
