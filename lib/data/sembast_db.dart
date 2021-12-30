import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shared_preferences_kool/data/sembast_codec.dart';
import '../models/password.dart';

class SembastDb {
  //deklareerime DatabaseFactory - Io on sambast librari´st
  DatabaseFactory dbFactory = databaseFactoryIo;
  //deklareerime Database
  Database? _db;
  //store on koht db sees, kuhu data salvestatakse
  final store = intMapStoreFactory.store('passwords');
  var codec = getEncryptSembastCodec(password: 'Password');
// factory constructor pattern,
  static SembastDb _singleton = SembastDb._internal();
//private named constructor
  SembastDb._internal();
//public factory constructor
  factory SembastDb() {
    return _singleton;
  }
//meetod, mis tagab, et kasutatakse sama instance
  Future<Database?> init() async {
    if (_db == null) {
      _db = await _openDb();
    }
    return _db;
  }

//meetod mis avab db
  Future _openDb() async {
//hangime rakenduste dokumentide kataloogi(path_provider library)
    final docsDir = await getApplicationDocumentsDirectory();
//lisame db nime folder path'le
    final dbPath = join(docsDir.path, 'pass.db');
//avame db kutsudes välja openDatabase meetodi (siia läheb path)
    final db = await dbFactory.openDatabase(dbPath, codec: codec);
    return db;
  }

//lisab uue dokumendi store'sse
  Future<int> addPassword(Password password) async {
    int id = await store.add(_db!, password.toMap());
    return id;
  }

//otsib passwordid db'st
  Future getPasswords() async {
//Kuna getPasswords on esimene meetod, mida sellest klassist
//välja kutsutakse, siis veendume, et andmebaas on avatud,
// kutsudes getPasswordsi ülaosas oleva init-meetodi.
    await init();
    //data is sorted with a sortOrders property based on the name of the item
    final finder = Finder(sortOrders: [SortOrder('name')]);
    //final snapshot ootab stores find meetodi välja kutsumist(andes sisendi db ja filter)
    final snapshot = await store.find(_db!, finder: finder);
//tagastab objekti snapshot, mis sisaldab map objektide komplekti
//Lõpuks kutsute hetktõmmistel välja kaardimeetodi,
//et saaksite iga üksuse objektiks muuta, antud juhul parooliobjektiks.
    return snapshot.map((item) {
      final pwd = Password.fromMap(item.value);
      pwd.id = item.key;
      return pwd;
//Seejärel lisate meetodi toList, et muuta tulemus loendiobjektiks,
    }).toList();
  }

//põhimõte sarnane ülemisega
  Future updatePassword(Password pwd) async {
    final finder = Finder(filter: Filter.byKey(pwd.id));
    await store.update(_db!, pwd.toMap(), finder: finder);
  }

//põhimõte sarnane ülemisega
  Future deletePassword(Password pwd) async {
    final finder = Finder(filter: Filter.byKey(pwd.id));
    await store.delete(_db!, finder: finder);
  }

  Future deleteAll() async {
    //finderit ei ole vaja
    await store.delete(_db!);
  }
}
