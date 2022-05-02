import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'climate.dart';
import 'feel.dart';

// App launcher
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DotEnv().load('.env');
  runApp(Main());
}

class Main extends StatelessWidget {
  Widget build(BuildContext context) {
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
