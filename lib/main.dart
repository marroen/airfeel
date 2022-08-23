import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';

//import 'func/climate.dart';
import 'func/climate2.dart';
import 'widg/feel.dart';

// App launcher
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DotEnv().load('.env');
  final LocalStorage baseStorage = LocalStorage('base');
  final LocalStorage newStorage = LocalStorage('new');
  await newStorage.deleteItem('climate');
  newStorage.dispose();
  runApp(Main());
}

class Main extends StatelessWidget {

  Widget build(BuildContext context) {
    return _initialize();
  }

  _initialize() {
    return MaterialApp(
      title: 'Airfeel',
      theme: ThemeData(
        primaryColor: Colors.red[900],
        backgroundColor: Colors.red[900],
        canvasColor: Colors.white,
        dividerColor: Colors.transparent,
      ),
      home: Feel(),
    );
  }
}
