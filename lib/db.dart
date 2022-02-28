import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';

class DB extends StatelessWidget {

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    final database = openDatabase(
      join(await getDatabasesPath(), '../city_list.data.sql'),
    );
  }

  Future<List<String>> cities(String city) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(city);
    return List.generate(maps.length, (i) {
      return maps[i],
    });
  }

}
