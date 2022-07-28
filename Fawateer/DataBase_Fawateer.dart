import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'Fawateer_Model.dart';


class DataBase_Fawateer {
var db_Fawateer ;


Future<Database> getDB() async {
    if (db_Fawateer != null) return db_Fawateer;
    db_Fawateer = await initializeDB('fawateer.db');
    return db_Fawateer;
  }

  Future<Database> initializeDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: createDB);
  }

  Future createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE '$table_Fawateer' (
    '${FawateerTable_Fields.id}' INTEGER PRIMARY KEY , 
    '${FawateerTable_Fields.name}' TEXT NOT NULL , 
    '${FawateerTable_Fields.date}' TEXT NOT NULL 
    )
    ''');
    await db.execute('''
CREATE TABLE '$table_FatorahItem' (
'${ItemsTable_Fields.id}' INTEGER PRIMARY KEY , 
'${ItemsTable_Fields.name}' TEXT NOT NULL ,
'${ItemsTable_Fields.quantity}' INTEGER NOT NULL ,
'${ItemsTable_Fields.sPrice}' DOUBLE NOT NULL ,
'${ItemsTable_Fields.id_FK}' INTEGER NOT NULL ,
FOREIGN KEY('${ItemsTable_Fields.id_FK}') REFERENCES '$table_Fawateer'('${FawateerTable_Fields.id}')

)

''');
  }

  Future<Fatorah> createFatorah(Fatorah fatorah) async {
    getDB();
    final id = await db_Fawateer.insert(
      table_Fawateer,
      fatorah.toJson(),
    );
    return fatorah.copy(id: id);
  }

  Future<Fatorah?> readFatorah(int id) async {
    final maps = await db_Fawateer.query(table_Fawateer,
        columns: FawateerTable_Fields.values,
        where: '${FawateerTable_Fields.id} = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Fatorah.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Fatorah>> readAllFawateer() async {
    final List<Map<String, dynamic>> maps = await db_Fawateer.query(
      table_Fawateer,
      orderBy: '${FawateerTable_Fields.id} ASC',
    );

    return List.generate(
        maps.length,
        (index) => Fatorah(
              id: maps[index][FawateerTable_Fields.id],
              name: maps[index][FawateerTable_Fields.name],
              date: maps[index][FawateerTable_Fields.date],
            ));
  }

  Future<int> updateDB_Fatorah(Fatorah fatorah) async {
    return db_Fawateer.update(
      table_Fawateer,
      fatorah.toJson(),
      where: '${FawateerTable_Fields.id} = ?',
      whereArgs: [fatorah.id],
    );
  }

  Future<int> deleteDB_Fatorah(Fatorah fatorah) async {
    return db_Fawateer.delete(
      table_Fawateer,
      where: '${FawateerTable_Fields.id} = ?',
      whereArgs: [fatorah.id],
    );
  }

  Future closeDB() async {
    db_Fawateer.close();
  }

Future<Fatorah_Item> createItem(Fatorah_Item fatorah_item , int id_fk ) async {
  Map<String, Object?> thirdmap = {};
  thirdmap.addAll(fatorah_item.toJson());
  thirdmap.addAll({ItemsTable_Fields.id_FK.toString() : id_fk });
    final id = await db_Fawateer.insert(
      table_FatorahItem,
      thirdmap,
    );
    return fatorah_item.copy(id: id);
  }

  Future<Fatorah_Item?> readItem(int id) async {
    final maps = await db_Fawateer.query(table_FatorahItem,
        columns: ItemsTable_Fields.values,
        where: '${ItemsTable_Fields.id} = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Fatorah_Item.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Fatorah_Item>> readAllitems(int id_fk) async {
    final List<Map<String, dynamic>> maps = await db_Fawateer.query(
      table_FatorahItem,
      where : '${ItemsTable_Fields.id_FK} = $id_fk',
      orderBy: '${ItemsTable_Fields.id} ASC',
    );

    return List.generate(
        maps.length,
        (index) => Fatorah_Item(
              id: maps[index][ItemsTable_Fields.id],
              name: maps[index][ItemsTable_Fields.name],
              quantity: maps[index][ItemsTable_Fields.quantity],
              sPrice: maps[index][ItemsTable_Fields.sPrice],
              id_FK: maps[index][ItemsTable_Fields.id_FK]
            ));
  }

  Future<int> updateItemDB(Fatorah_Item fatorah_item) async {
    return db_Fawateer.update(
      table_FatorahItem,
      fatorah_item.toJson(),
      where: '${ItemsTable_Fields.id} = ?',
      whereArgs: [fatorah_item.id],
    );
  }

  Future<int> deleteItemDB(Fatorah_Item fatorah_item) async {
    return db_Fawateer.delete(
      table_FatorahItem,
      where: '${ItemsTable_Fields.id} = ?',
      whereArgs: [fatorah_item.id],
    );
  }


}