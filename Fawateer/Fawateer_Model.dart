final String table_Fawateer = 'fawateer_table';
final String table_FatorahItem = 'items_table';


class FawateerTable_Fields {
  static final String id = 'id_fatorah';
  static final String name = 'name';
  static final String date = 'date';

  static final List<String> values = [id, name, date];
}



class Fatorah {
  final int? id;
  final String name;
  final String date;

  const Fatorah(
      {this.id, required this.name, required this.date});

  Map<String, Object?> toJson() {
    return {
      FawateerTable_Fields.id: id,
      FawateerTable_Fields.name: name,
      FawateerTable_Fields.date: date,
    };
  }

  static Fatorah fromJson(Map<String, dynamic> json) {
    return Fatorah(
      id: FawateerTable_Fields.id as int,
      name: FawateerTable_Fields.name,
      date: FawateerTable_Fields.date,
    );
  }

  Fatorah copy({
    int? id,
    String? name,
    String? date,
  }) =>
      Fatorah(
        id: this.id,
        name: this.name,
        date: this.date,
      );
}


class ItemsTable_Fields {
  static final String id = 'id_item';
  static final String name = 'name';
  static final String quantity = 'quantity';
  static final String sPrice = 'single_price';
  static final String id_FK = 'id_FK';

  static final List<String> values = [id, name, quantity , sPrice , id_FK];
}

class Fatorah_Item {
  final int? id;
  final String name;
  final int quantity;
  final double sPrice ; 
  final int id_FK ;
  const Fatorah_Item(
      {this.id, required this.name, required this.quantity , required this.sPrice , required this.id_FK});

  Map<String, Object?> toJson() {
    return {
     ItemsTable_Fields.id: id,
     ItemsTable_Fields.name: name,
     ItemsTable_Fields.quantity: quantity,
     ItemsTable_Fields.sPrice : sPrice
    };
  }

  static Fatorah_Item fromJson(Map<String, dynamic> json) {
    return Fatorah_Item(
      id: ItemsTable_Fields.id as int,
      name: ItemsTable_Fields.name,
      quantity: ItemsTable_Fields.quantity as int,
      sPrice:  ItemsTable_Fields.sPrice as double,
      id_FK: ItemsTable_Fields.id_FK as int,
    );
  }

  Fatorah_Item copy({
    int? id,
    String? name,
    int? quantity,
    double? sPrice,
        int? id_FK,

  }) =>
      Fatorah_Item(
        id: this.id,
        name: this.name,
        quantity: this.quantity,
        sPrice: this.sPrice,
        id_FK: this.id_FK
      );
}
