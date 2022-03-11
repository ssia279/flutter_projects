import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/place.dart';

class DbHelper {
  final int version = 1;
  Database? db;
  List<Place> places = <Place>[];

  static final DbHelper _dbHelper = DbHelper._interal();
  DbHelper._interal();

  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database?> openDb() async {
    db ??= await openDatabase(join(await getDatabasesPath(), 'mapp.db'),
        onCreate: (database, version) {
          database.execute(
            'CREATE TABLE places(id INTEGER PRIMARY KEY, name TEXT, lat DOUBLE, lon DOUBLE, image TEXT)'
          );
        },
        version: version);

    return db;
  }
  
  Future insertMockData() async {
    db = await openDb();
    await db?.execute('INSERT INTO places VALUES (1, "Costco Warehouse", 37.478468198, -122.216291428, "" )');
    await db?.execute('INSERT INTO places VALUES (2, "24 Hour Fitness", 37.4875948756, -122.211227417, "" )');
    await db?.execute('INSERT INTO places VALUES (3, "Taco Bell", 37.472337714, -122.215518951, "" )');
    List<Map<String, Object?>>? places = await db?.rawQuery('select * from places');
    print(places?[0].toString());
  }

  Future<List<Place>> getPlaces() async {
    final List<Map<String, Object?>>? maps = await db?.query('places');
    places = List.generate(maps!.length, (index) {
      return Place(
        maps[index]['id'] as int,
        maps[index]['name'] as String,
        maps[index]['lat'] as double,
        maps[index]['lon'] as double,
        maps[index]['image'] as String,
      );
    });

    return places;
  }

  Future<int?> insertPlace(Place place) async {
    int? id = await db?.insert('places', place.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  Future<int?> deletePlace(Place place) async {
    int? result = await db?.delete('places', where: "id = ?", whereArgs: [place.id]);

    return result;
  }


}