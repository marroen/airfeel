import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class Searcher extends StatefulWidget {
  @override

  State<StatefulWidget> createState() {
    return SearcherState();
  }
}

class SearcherState extends State<Searcher> {
  List<String> allPlaces = ["barcelona", "lisbon", "absurofurorgnukkk"];
  List<AutocompletePrediction> predictions = [];
  GooglePlace googlePlace;

  void initState() {
    String apiKey = DotEnv().env['API_KEY'];
    googlePlace = GooglePlace(apiKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(8, 60, 8, 60),
        child: Column(
          children: <Widget> [
            TextField(
              textAlign: TextAlign.center,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Where are you going?',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red[900], width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red[900], width: 0.0),
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  autoCompleteSearch(value);
                } else {
                  if (predictions.length > 0 && mounted) {
                    setState(() {
                      predictions = [];
                    });
                  }
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        Icons.pin_drop,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(predictions[index].description),
                    onTap: () {
                      Navigator.pop(
                        context,
                        predictions[index].description);
                    },
                    /*onTap: () {
                      print(predictions[index].placeId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(
                            placeId: predictions[index].placeId,
                            googlePlace: googlePlace,
                          ),
                        ),
                      );
                    },*/
                  );
                },
              ),
            ),
          ],
        ),

        /*
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEV) {
            if (textEV.text == '') {
              return const Iterable<String>.empty();
            }
            return allPlaces.where((String place) {
              return place.contains(textEV.text.toLowerCase());
            });
          },
          //initialValue: TextEditingValue (text: "Where are you going?"),
          onSelected: (String selection) {
            print("you selected $selection");
            Navigator.pop(context, selection);
          },
          fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              onEditingComplete: onEditingComplete,
              textAlign: TextAlign.center,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Where are you going?',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red[900], width: 0.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red[900], width: 0.0),
                ),
              ),
              //onChanged: (text) {

            );
          },


        ),
        */
        /*
        TextField(
          textAlign: TextAlign.center,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Where are you going?',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[900], width: 0.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[900], width: 0.0),
            ),
          ),
          enableSuggestions: true,
          enableInteractiveSelection: true,
          onChanged: (text) {
            if (text.length > 2) {
              print("hi");
            }
          },
          onSubmitted: (text) {
            Navigator.pop(context, text);
          },
        ),*/
      ),
    );
  }

  /* --- Build helper methods --- */
  
  void autoCompleteSearch(String value) async {
    var result = await googlePlace.queryAutocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions;
      });
    }
  }

  

}
