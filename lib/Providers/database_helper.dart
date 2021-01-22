import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import '../models/bio.dart';

class DatabaseHelper {
  // -------------------Createing databasse ----------------------
  static const _db_name = 'bio_table';
  static const _db_version = 1;

  //-----------------
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  Database _database;
// db getter------------------
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return database;
  }

  Future<Database> _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _db_name);
    return await openDatabase(dbPath,
        version: _db_version, onCreate: _onCreateDB);
  }

  _onCreateDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $_db_name(
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     weight TEXT,
     systolic TEXT,
     diastolic TEXT,
     pulse TEXT,
     day TEXT
    )
    ''');
  }

  //-----------------------------  Database created ------------------
//delete database
  Future<void> deleteDb() async {
    final Database db = await database;
    await deleteDatabase(db.path);
  }

// insert
  Future<int> insertDB(Bio bio) async {
    final Database db = await database;
    int recordId = await db.insert(_db_name, bio.toMap());
    return recordId;
  }

  //-----------------------
  // retrieve all
  //

  Future<List<Bio>> getBio() async {
    final Database db = await database;
    List<Bio> out = [];
    final List<Map<String, dynamic>> bios = await db.query(_db_name);
    bios.forEach((element) {
      out.add(Bio.fromMap(element));
    });
    return out;
  }

  //---------------------------------
  //   get x number of data
  //
  Future<List<Bio>> getLim(measToGet) async {
    final Database db = await database;
    List<Bio> out = [];
    List<Map<String, dynamic>> bios = await db
        .rawQuery('SELECT * FROM $_db_name ORDER BY ID DESC LIMIT $measToGet');
    bios.forEach((element) {
      out.add(Bio.fromMap(element));
    });
    return out;
  }

  //-------------------------------
  // Update single data
  //

  Future updateDB(Bio bio) async {
    final Database db = await database;
    await db.update(_db_name, bio.toMap(), where: 'id=?', whereArgs: [bio.id]);
  }

//-------------------------------
// Insert Batch
//
  Future<void> insertBatch(List<Bio> myBio) async {
    final Database db = await database;
    Batch batch = db.batch();
    myBio.forEach((element) {
      batch.insert(_db_name, element.toMap());
    });
    await batch.commit();
    // print('done');
  }
  //-----------------------------
  // delete
  //------------------------------

  Future<void> deleteItem(int id) async {
    final Database db = await database;
    await db.delete(_db_name, where: 'id=?', whereArgs: [id]);
  }
}
