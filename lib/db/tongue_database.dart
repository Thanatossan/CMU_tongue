
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:tongue_cmu_bluetooth/model/note.dart';
import 'package:tongue_cmu_bluetooth/model/user.dart';
import 'package:tongue_cmu_bluetooth/model/tongueTest.dart';

class TongueDatabase {
  static final TongueDatabase instance = TongueDatabase._init();

  static Database? _database;

  TongueDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('tongue.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final floatType = 'DOUBLE NOT NULL';

    await db.execute('''
CREATE TABLE $tableUser ( 
  ${UserFields.id} $idType, 
  ${UserFields.name} $textType,
  ${UserFields.surname} $textType,
  ${UserFields.gender} $textType,
  ${UserFields.age} $integerType,
  ${UserFields.createAt} $textType
  )
''');
    // ${TongueTestFields.userId} $integerType,
    await db.execute('''
CREATE TABLE $tableTongueTest ( 
  ${TongueTestFields.id} $idType, 
  ${TongueTestFields.userId} $integerType,
  ${TongueTestFields.time} $textType,
  ${TongueTestFields.type} $textType,
  ${TongueTestFields.newton} $floatType,
  ${TongueTestFields.kiloPascal} $floatType,
  FOREIGN KEY (${TongueTestFields.userId}) REFERENCES tableUser(${UserFields.id})
  )
''');
  }

  Future<TongueTest> addTest(TongueTest tongueTest) async{
    final db = await instance.database;
    final id = await db.insert(tableTongueTest, tongueTest.toJson());
    return tongueTest.copy(id:id);
  }
  // Future<TongueTest> readMaxTest(int userId) async {
  //   final db = await instance.database;
  //
  //   final maps = await db.query(
  //     tableTongueTest,
  //     columns: TongueTestFields.values,
  //     where: '${TongueTestFields.userId} = $userId AND MAX(${TongueTestFields.kiloPascal})' ,
  //   );
  //
  //   if (maps.isNotEmpty) {
  //     return TongueTest.fromJson(maps.first);
  //   } else {
  //     throw Exception('ID $userId not found');
  //   }
  // }
  Future<TongueTest> getMaxTest(int userId) async {
    final db = await instance.database;
    // final result = await db.rawQuery(
    //     "SELECT * FROM tongueTest WHERE userId = '$userId' AND MAX(kiloPascal)");
    // print(result);
    final result = await db.rawQuery(
      "SELECT a.* FROM tongueTest a LEFT OUTER JOIN tongueTest b ON a._id = b._id AND a.kiloPascal < b.kiloPascal WHERE b._id IS NULL AND a.userId = $userId LIMIT 1"
    );
    if (result.isNotEmpty) {
      // print(result);
      return TongueTest.fromJson(result.first);
    } else {
      return TongueTest(userId: userId, time: DateTime.now(), type: "Not found", newton: 0, kiloPascal: 0);
    }
  }
  Future<User> createUser(User user) async {
    final db = await instance.database;
    final id = await db.insert(tableUser, user.toJson());
    return user.copy(id: id);
  }

  Future<User> readUser(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableUser,
      columns: UserFields.values,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<User>> readAllUser() async {
    final db = await instance.database;

    final orderBy = '${UserFields.createAt} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableUser, orderBy: orderBy);

    return result.map((json) => User.fromJson(json)).toList();
  }

  Future<User> getLogin(String loginName, String loginSurName) async {
    final db = await instance.database;
    final result = await db.rawQuery(
        "SELECT * FROM user WHERE name = '$loginName' and surname = '$loginSurName'");
    // print(result);
    if (result.isNotEmpty) {
      return User.fromJson(result.first);
    } else {
      return User(
          name: "", surname: "", gender: "", age: 0, createAt: DateTime.now());

    }
  }

  Future<int> updateUser(User user) async {
    final db = await instance.database;

    return db.update(
      tableUser,
      user.toJson(),
      where: '${UserFields.id} = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableUser,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
  Future exportUserData() async{
    final db = await instance.database;
    final result = await db.rawQuery(
        "SELECT * FROM user ");
    return result;
  }
  Future exportTestData() async{
    final db = await instance.database;
    final result = await db.rawQuery(
        "SELECT *,user.name,user.surname FROM tongueTest INNER JOIN user ON userId = user._id");
    return result;
  }
}
