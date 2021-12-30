import '../models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

// create a few constants for the names of the columns
// considered good practice as it helpS avoid typing errors when dealing with
// fields in a database.
class SqlHelper {
  final String colId = 'id';
  final String colName = 'name';
  final String colDate = 'date';
  final String colNotes = 'notes';
  final String colPosition = 'position';
  final String tableNotes = 'notes';

//static private variable for the database
  static Database? _db;
//integer value for the version of the database.
//use this when creating a new database,
//useful when you need to update the database to a new version.
  final int version = 1;
  static final SqlHelper _singleton = SqlHelper._internal();

  SqlHelper._internal();
  
  factory SqlHelper() {
    return _singleton;
  }

// using sqflite, all methods are asynchronous
  Future<Database> init() async {
//create a directory that contains the current application documents directory
//We will get this by calling the getApplicationDocumentsDirectory method
//from the path_provider library
    Directory dir = await getApplicationDocumentsDirectory();
//full path for database, a String that joins the directory we have
//retrieved with the name of the database that we can call notes.db.
    String dbPath = join(dir.path, 'notes.db');
//set a database object calling it dbNotes
//This will call the sqflite openDatabase method, passing the path,
//the version, and the onCreate callback.
//That's called when the database does not exist yet
    Database dbNotes =
        await openDatabase(dbPath, version: version, onCreate: _createDb);
    return dbNotes;
  }

  Future _createDb(Database db, int version) async {
    String query =
        'CREATE TABLE $tableNotes ($colId INTEGER PRIMARY KEY, $colName TEXT, $colDate TEXT, $colNotes TEXT, $colPosition INTEGER)';
    await db.execute(query);
  }

  Future<int> insertNote(Note note) async {
    note.position = await findPosition();
    int result = await _db!.insert(tableNotes, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    int result = await _db!.update(tableNotes, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(Note note) async {
    int result = await _db!
        .delete(tableNotes, where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<List<Note>> getNotes() async {
    if (_db == null) _db = await init();
    List<Map<String, dynamic>> notesList =
        await _db!.query(tableNotes, orderBy: colPosition);
    List<Note> notes = [];
    notesList.forEach((element) {
      notes.add(Note.fromMap(element));
    });
    return notes;
  }

  Future<int> findPosition() async {
    final String sql = 'select max($colPosition) from $tableNotes';
    List<Map> queryResult = await _db!.rawQuery(sql);
    int? position = queryResult.first.values.first;
    position = (position == null) ? 0 : position++;
    return position;
  }

  Future updatePositions(bool increment, int start, int end) async {
    String sql;
    if (increment) {
      sql =
          'update $tableNotes set $colPosition = $colPosition + 1  where $colPosition >= $start and $colPosition <= $end';
    } else {
      sql =
          'update $tableNotes set $colPosition = $colPosition - 1  where $colPosition >= $start and $colPosition <= $end';
    }
    await _db?.rawUpdate(sql);
  }
}
