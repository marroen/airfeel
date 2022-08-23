import 'package:weather/weather.dart';
//import 'package:geocoding/geocoding.dart';

// Currently not in-use
class Outfit {
  var outfit;

  Outfit(Temperature temp, double rain, double snow, double humid) {
    outfit = calculateClothing(temp, rain, snow, humid);
  }

  Set<String> calculateClothing(Temperature temp, double rain, double snow, double humid) {
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
        if (temp.celsius > 16) {
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

      /*setState(() {
        //this.outfit = outfit;
      });*/

      return outfit;
    }
}
