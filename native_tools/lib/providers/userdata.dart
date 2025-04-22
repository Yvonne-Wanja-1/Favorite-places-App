// c:\Users\Administrator\Desktop\native_tools\native_tools\lib\providers\userdata.dart
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_tools/models/place.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT,lat REAL, lng REAL, address TEXT)',
      );
    },
    version: 1,
  );
  return db;
}

class Userdata extends StateNotifier<List<Place>> {
  Userdata() : super([]);

  Future<void> loadplaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
            location: Placelocation(
              latitude: row['lat'] as double,
              longitude: row['lng'] as double,
              address: row['address'] as String,
            ),
          ),
        )
        .toList();
    state = places;
  }

  Future<void> addplace(String title, File image, Placelocation location) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final savedImage = await image.copy('${appDir.path}/$fileName');

    final newplace = Place(
      title: title,
      image: savedImage,
      location: location,
    );

    final db = await _getDatabase();
    await db.insert(
      'user_places',
      {
        'id': newplace.id,
        'title': newplace.title,
        'image': newplace.image.path,
        'lat': newplace.location.latitude,
        'lng': newplace.location.longitude,
        'address': newplace.location.address,
      },
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );

    state = [newplace, ...state];
  }
}

final userdataprovider = StateNotifierProvider<Userdata, List<Place>>((ref) {
  return Userdata();
});
