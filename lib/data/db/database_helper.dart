import 'package:firesto/data/model/restaurant.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;
  static const String _tblFavorite = 'favorite';

  factory DatabaseHelper() => _instance ?? DatabaseHelper.internal();

  DatabaseHelper.internal() {
    _instance = this;
  }

  Future<Database?> get database async {
    return _database ??= await _initializeDb();
  }

  Future<Database> _initializeDb() async {
    final String path = await getDatabasesPath();
    final Future<Database> db = openDatabase(
      '$path/firesto.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE $_tblFavorite (id TEXT PRIMARY KEY, name TEXT, description TEXT, pictureId TEXT, city TEXT, rating REAL)');
      },
    );

    return db;
  }

  Future<void> insertFavorite(Restaurants restaurants) async {
    final Database? db = await database;
    await db!.insert(_tblFavorite, restaurants.toJson());
  }

  Future<List<Restaurants>> getFavorite() async {
    final Database? db = await database;
    final List<Map<String, dynamic>> results = await db!.query(_tblFavorite);

    return results
        .map((Map<String, dynamic> res) => Restaurants.fromJson(res))
        .toList();
  }

  Future<Map<String, dynamic>> getFavoriteById(String id) async {
    final Database? db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblFavorite,
      where: 'id = ?',
      whereArgs: <String>[id],
    );

    return results.isNotEmpty ? results.first : <String, dynamic>{};
  }

  Future<void> removeFavorite(String id) async {
    final Database? db = await database;

    await db!.delete(
      _tblFavorite,
      where: 'id = ?',
      whereArgs: <String>[id],
    );
  }
}
