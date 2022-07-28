final String table_Products = 'products';

class ProductFields {
  static final String id = 'id';
  static final String name = 'name';
  static final String type = 'type';
  static final String price = 'price';

  static final List<String> values = [id, name, type, price];
}

class Product {
  final int? id;
  final String name;
  final String type;
  final double price;

  const Product(
      {this.id, required this.name, required this.type, required this.price});

  Map<String, Object?> toJson() {
    return {
      ProductFields.id: id,
      ProductFields.name: name,
      ProductFields.type: type,
      ProductFields.price: price
    };
  }

  static Product fromJson(Map<String, dynamic> json) {
    return Product(
      id: ProductFields.id as int,
      name: ProductFields.name,
      type: ProductFields.type,
      price: ProductFields.price as double,
    );
  }

  Product copy({
    int? id,
    String? name,
    String? type,
    double? price,
  }) =>
      Product(
        id: this.id,
        name: this.name,
        type: this.type,
        price: this.price,
      );
}
