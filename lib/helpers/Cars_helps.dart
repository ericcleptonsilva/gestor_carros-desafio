import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String carsTable = "carsTable";
final String brandColumn = "brandColumn";
final String idColumn = "idColumn";
final String modelColumn = "modelColumn";
final String photoColumn = "photoColumn";
final String priceColumn = "priceColumn";
final String yearColumn = "yearColumn";

class CarsHelper {
  static final CarsHelper _instance = CarsHelper.internal();
  factory CarsHelper() => _instance;
  CarsHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

// inicializando o banco de dados
  Future<Database> initDb() async {
    final databesePath = await getDatabasesPath();
    final path = join(databesePath, "CarsList2.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVesion) async {
      await db.execute(
          "CREATE TABLE $carsTable($idColumn INTEGER PRIMARY KEY, $modelColumn TEXT, $brandColumn TEXT,"
          "$photoColumn TEXT, $priceColumn TEXT, $yearColumn TEXT)");
    });
  }

// savando os dados no banco de dados
  Future<CarsList> saveCarsLIst(CarsList carsList) async {
    Database dbCarsList = await db;
    carsList.id = await dbCarsList.insert(carsTable, carsList.toMap());
    return carsList;
  }

  Future<CarsList> getCarsList(int id) async {
    Database dbCarsList = await db;
    List<Map> maps = await dbCarsList.query(carsTable,
        columns: [
          idColumn,
          modelColumn,
          brandColumn,
          photoColumn,
          priceColumn,
          yearColumn
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return CarsList.fromMap(maps.first);
    } else {
      return null;
    }
  }

// deletar dos dados no banco de dados
  Future<int> deleteCarsList(int id) async {
    Database dbCarslist = await db;
    return await dbCarslist
        .delete(carsTable, where: "$idColumn = ?", whereArgs: [id]);
  }

// Atualizar os dados no banco de dados
  Future<int> updateCarList(CarsList carsList) async {
    Database dbCarslist = await db;
    return await dbCarslist.update(carsTable, carsList.toMap(),
        where: "$idColumn = ?", whereArgs: [carsList.id]);
  }

  Future<List> getALLCarsList() async {
    Database dbCarslist = await db;
    List listMap = await dbCarslist.rawQuery("SELECT * FROM $carsTable");
    List<CarsList> listCarsList = [];
    for (Map m in listMap) {
      listCarsList.add(CarsList.fromMap(m));
    }
    return listCarsList;
  }

  Future<int> getNumber() async {
    Database dbCarslist = await db;
    return Sqflite.firstIntValue(
        await dbCarslist.rawQuery("SELECT COUNT(*) FROM $carsTable"));
  }

  Future close() async {
    Database dbCarslist = await db;
    dbCarslist.close();
  }
}

class CarsList {
  int id;
  String model;
  String brand;
  String photo;
  String price;
  String year;

  CarsList();

  CarsList.fromMap(Map map) {
    id = map[idColumn];
    model = map[modelColumn];
    brand = map[brandColumn];
    photo = map[photoColumn];
    price = map[priceColumn];
    year = map[yearColumn];
  }
// Função que retorna um map
  Map toMap() {
    Map<String, dynamic> map = {
      modelColumn: model,
      brandColumn: brand,
      photoColumn: photo,
      priceColumn: price,
      yearColumn: year
    };

    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "CarsList(id: $id, model: $model, brand: $brand, photo: $photo, price: $price, year: $year )";
  }
}
