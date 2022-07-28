import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Product.dart';

class Database_product {
  var product_database;

  Future<Database> getDB() async {
    if (product_database != null) return product_database;
    product_database = await initializeDB('products.db');
    return product_database;
  }

  Future<Database> initializeDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: createDB);
  }

  Future createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE '$table_Products' (
    '${ProductFields.id}' INTEGER PRIMARY KEY , 
    '${ProductFields.name}' TEXT NOT NULL , 
    '${ProductFields.type}' TEXT NOT NULL , 
    '${ProductFields.price}' DOUBLE NOT NULL 
    )
    ''');
    print('data created');
  }

  Future<Product> createItem(Product product) async {
    final id = await product_database.insert(
      table_Products,
      product.toJson(),
    );
    print('item created');
    return product.copy(id: id);
  }

  Future<Product?> readProduct(int id) async {
    final maps = await product_database.query(table_Products,
        columns: ProductFields.values,
        where: '${ProductFields.id} = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Product.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Product>> readAllData() async {
    final List<Map<String, dynamic>> maps = await product_database.query(
      'products',
      orderBy: '${ProductFields.name} ASC',
    );

    return List.generate(
        maps.length,
        (index) => Product(
              id: maps[index][ProductFields.id],
              name: maps[index][ProductFields.name],
              type: maps[index][ProductFields.type],
              price: maps[index][ProductFields.price],
            ));
  }

  Future<int> updateDB(Product product) async {
    return product_database.update(
      table_Products,
      product.toJson(),
      where: '${ProductFields.id} = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteDB(Product product) async {
    return product_database.delete(
      table_Products,
      where: '${ProductFields.id} = ?',
      whereArgs: [product.id],
    );
  }

  Future closeDB() async {
    product_database.close();
  }
}
