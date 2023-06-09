import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../commons/const.dart';
import '../../models/student_model.dart';

class MySQFLite {
  static const _databaseName = "MyDatabase.db";

  static const _databaseV1 = 1;
  static const _databaseV2 = 2;
  static const tableStudent = 'Student';
  static const tableOrganization = 'Organization';

  // Singleton class
  MySQFLite._privateConstructor();

  static final MySQFLite instance = MySQFLite._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);

    return await openDatabase(path, version: _databaseV2,
        onCreate: (db, version) async {
      var batch = db.batch();
      _onCreateTableStudentV2(batch);
      _onCreateTableOrganizationV2(batch);
      await batch.commit();
    }, onUpgrade: (db, oldVersion, newVersion) async {
      var batch = db.batch();
      if (oldVersion == _databaseV1) {
        _onUpdateTableStudentV1ToV2(batch);
        _onCreateTableOrganizationV2(batch);
      }
      await batch.commit();
    });
  }

  void _onCreateTableStudentV2(Batch batch) async {
    batch.execute('''
          CREATE TABLE $tableStudent (
            ${Constant.studentId} TEXT PRIMARY KEY,
            ${Constant.studentName} TEXT,
            ${Constant.studentDepartment} TEXT,
            ${Constant.studentSKS} INTEGER,
            ${Constant.studentAddress} TEXT
          )
          ''');
  }

  void _onUpdateTableStudentV1ToV2(Batch batch) async {
    batch.execute(
        '''ALTER TABLE $tableStudent ADD COLUMN ${Constant.studentAddress} TEXT''');
  }

  void _onCreateTableOrganizationV2(Batch batch) async {
    batch.execute('''
          CREATE TABLE $tableOrganization (
            ${Constant.organizationName} TEXT,
            ${Constant.organizationId} TEXT
          )
          ''');
  }

  ///TABLE Student
  Future<int> insertStudent(StudentModel model) async {
    Database db = await instance.database;

    return await db.insert(
      tableStudent,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertStudents(List<StudentModel> models) async {
    Database db = await instance.database;

    Batch batch = db.batch();
    for (var model in models) {
      batch.insert(tableStudent, model.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<StudentModel>> getStudents() async {
    Database db = await instance.database;

    // var allData = await db.rawQuery("SELECT * FROM $tableStudent");
    var allData = await db.query(tableStudent);

    return List.generate(allData.length, (i) {
      return StudentModel(
        id: allData[i][Constant.studentId] as String,
        name: allData[i][Constant.studentName] as String,
        department: allData[i][Constant.studentDepartment] as String,
        sks: int.parse(
          allData[i][Constant.studentSKS].toString(),
        ),
        address: allData[i][Constant.studentAddress] as String?,
      );
    });
  }

  Future<StudentModel?> getStudentById(String id) async {
    Database db = await instance.database;

    // var allData = await db
    //     .rawQuery("SELECT * FROM $tableStudent WHERE ${Constant.studentId} = "
    //         "$id LIMIT 1");
    var allData = await db.query(
      tableStudent,
      where: '${Constant.studentId} = ?',
      whereArgs: [id],
    );

    if (allData.isNotEmpty) {
      return StudentModel(
          id: allData[0][Constant.studentId] as String,
          name: allData[0][Constant.studentName] as String,
          department: allData[0][Constant.studentDepartment] as String,
          sks: int.parse(allData[0][Constant.studentSKS] as String));
    }
    return null;
  }

  Future<int> updateStudentDepartment(StudentModel model) async {
    Database db = await instance.database;

    // return await db.rawUpdate(
    //   'UPDATE $tableStudent SET ${Constant.studentName} = ${model.name}, '
    //   '${Constant.studentDepartment} = ${model.department}, '
    //   '${Constant.studentSKS} = ${model.sks} '
    //   'Where ${Constant.studentId} = ${model.id}',
    // );
    return await db.update(
      tableStudent,
      model.toMap(),
      where: '${Constant.studentId} = ?',
      whereArgs: [model.id],
    );
  }

  Future<int> deleteStudent(String id) async {
    Database db = await instance.database;

    // return await db.rawDelete(
    //   'DELETE FROM $tableStudent Where ${Constant.studentId} = $id',
    // );
    return await db.delete(
      tableStudent,
      where: '${Constant.studentId} = ?',
      whereArgs: [id],
    );
  }

  clearAllData() async {
    Database db = await instance.database;

    // await db.rawQuery("DELETE FROM $tableStudent");
    await db.delete(tableStudent);
  }
}
