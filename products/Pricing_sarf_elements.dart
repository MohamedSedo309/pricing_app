import 'package:flutter/material.dart';

import 'package:date_format/date_format.dart';
import 'package:pricing_app_common/products/Database_product.dart';


import 'package:searchfield/searchfield.dart';

import '../Constants/Consants.dart';
import '../Fawateer/DataBase_Fawateer.dart';
import '../Fawateer/Fawateer_Model.dart';
import '../Product.dart';

class Pricing_product extends StatefulWidget {
  static const screenID = 'Pricing_product';

  @override
  _Pricing_productState createState() => _Pricing_productState();
}

class _Pricing_productState extends State<Pricing_product> {
  final data = Database_product();
  final db_fawateer = DataBase_Fawateer();
  final form_key = GlobalKey<FormState>();
  List<Fatorah> fawateer_list = [];
  List<Product> products_list = [];
  List<Product> fatorahProducts_list = [];
  List<int> count_list = [];
  List<double> price_list = [];
  bool isLoading = false;
  

  Product product = Product(name: '', type: '', price: 0);
  TextEditingController count_controller = TextEditingController();
  TextEditingController name_controller = TextEditingController();
  TextEditingController nameCustomer_controller = TextEditingController();

  addto_Fatorah() {
    form_key.currentState!.validate();
    if (form_key.currentState!.validate()) {
      setState(() {
        fatorahProducts_list.add(product);
        count_list.add(int.parse(count_controller.text));
        price_list.add(product.price * int.parse(count_controller.text));
      });
      product = Product(name: '', type: '', price: 0);
      count_controller.clear();
      name_controller.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    data.getDB();
    refreshProducts();
  }

  @override
  void dispose() {
    super.dispose();
    data.closeDB();
  }

  void refreshProducts() async {
    setState(() {
      isLoading = true;
    });
    data.product_database = await data.getDB();
    products_list = await data.readAllData();
    refreshFawateer();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: mainColor,
        title: Text(
          'تسعير فاتورة',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctc) {
                  nameCustomer_controller.text =
                      'فاتورة رقم' + ' ' + '${fawateer_list.length + 1}';
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 100,
                      horizontal: 20,
                    ),
                    child: AlertDialog(
                      backgroundColor: mainColor,
                      title: Text(
                        'حفظ الفاتورة',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextFormField(
                            key: ValueKey('name'),
                            validator: (val) {
                              if (val!.isEmpty) return 'أدخل إسم العميل / الفاتورة';
                            },
                            textDirection: TextDirection.rtl,
                            controller: nameCustomer_controller,
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              hintText: ' إسم العميل / الفاتورة' ,
                              hintStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              hintTextDirection: TextDirection.rtl,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: secColor,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: mainColor,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (() {
                                  Navigator.pop(ctc);
                                }),
                                child: Container(
                                  height: 50,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black)),
                                  child: Center(
                                    child: Text(
                                      'إلغاء',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: secColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (() {
                                  save_fatorah();
                              
                                  Navigator.pop(ctc);
                                  
                                }),
                                child: Container(
                                  height: 50,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black)),
                                  child: Center(
                                    child: Text(
                                      'حفظ',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: secColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: Icon(
              Icons.save,
              size: 25,
            ),
          ),
        ],
      ),
      body: Form(
        key: form_key,
        child: Container(
          color: mainColor,
          child: ListView(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: Container(
                  child: SearchField<Product>(
                    key: ValueKey('product'),
                    validator: (val) {
                      if (product.name == '') return 'ادخل الصنف';
                    },
                    onSuggestionTap: (SearchFieldListItem<dynamic> val) {
                      setState(() {
                        product = val.item!;
                      });
                    },
                    controller: name_controller,
                    hint: 'إسم الصنف',
                    suggestionItemDecoration: BoxDecoration(),
                    searchStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    searchInputDecoration: InputDecoration(
                      errorStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      hintTextDirection: TextDirection.rtl,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: secColor,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: secColor,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    suggestions: products_list
                        .map(
                          (e) => SearchFieldListItem<Product>(
                            e.name,
                            item: e,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                child: Container(
                  child: TextFormField(
                    key: ValueKey('count'),
                    validator: (val) {
                      if (val!.isEmpty) return 'أدخل العدد';
                    },
                    textDirection: TextDirection.rtl,
                    controller: count_controller,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      hintText: 'العدد',
                      hintStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      hintTextDirection: TextDirection.rtl,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: secColor,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: secColor,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  addto_Fatorah();
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 80),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black)),
                    height: 40,
                    child: Icon(
                      Icons.add,
                      color: secColor,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: double.infinity,
                  color: secColor,
                  child: Table(
                    border: TableBorder.all(color: Colors.black),
                    children: [
                      TableRow(
                        children: [
                          Text(
                            'الفاتورة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: double.infinity,
                  color: secColor,
                  child: Table(
                    columnWidths: {
                      0: FlexColumnWidth(3.5),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(0.5),
                    },
                    border: TableBorder.all(color: Colors.black),
                    children: [
                      TableRow(
                        children: [
                          Text(
                            'إسم الصنف',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'العدد',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'سعر الوحدة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'السعر',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'م',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  color: secColor,
                  child: Table(
                    columnWidths: {
                      0: FlexColumnWidth(3.5),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(0.5),
                    },
                    border: TableBorder.all(color: Colors.black),
                    children: List<TableRow>.generate(
                      fatorahProducts_list.length,
                      (index) {

                        return TableRow(
                          children: [
                            Text(
                              fatorahProducts_list[index].name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              count_list[index].toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              fatorahProducts_list[index].price.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${double.parse((fatorahProducts_list[index].price * count_list[index]).toStringAsFixed(2))}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${index + 1}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 10,
                  left: 10,
                  bottom: 20,
                ),
                child: Container(
                  width: double.infinity,
                  color: secColor,
                  child: Table(
                    columnWidths: {
                      0: FlexColumnWidth(5),
                      1: FlexColumnWidth(1),
                    },
                    border: TableBorder.all(color: Colors.black),
                    children: [
                      TableRow(
                        children: [
                          Text(
                            'إجمالي الفاتورة',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            get_sum(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get_sum() {
    double sum = 0;
    if (price_list == [])
      return '0';
    else {
      for (var i = 0; i < price_list.length; i++) {
        sum += price_list[i];
      }
      return sum.toStringAsFixed(2);
    }
  }

  void refreshFawateer() async {
    db_fawateer.db_Fawateer = await db_fawateer.getDB();

    fawateer_list = await db_fawateer.readAllFawateer();
  }

  void save_fatorah() async {
    FocusManager.instance.primaryFocus?.unfocus();
      var newFatorah = await db_fawateer.createFatorah(Fatorah(
        name: nameCustomer_controller.text,
        date: formatDate(
          DateTime.now(),
          [yyyy, '-', mm, '-', dd],
        )));    for (var i = 0; i <  fatorahProducts_list.length; i++) {
      await db_fawateer.createItem(
          Fatorah_Item(
              name: fatorahProducts_list[i].name,
              quantity: count_list[i],
              sPrice: fatorahProducts_list[i].price,
              id_FK: fawateer_list.length == 0? 1 : fawateer_list.last.id! + 1),
         fawateer_list.length == 0? 1 : fawateer_list.last.id! + 1);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      'تم حفظ الفاتورة',
      textDirection: TextDirection.rtl,
      style: TextStyle(
        fontSize: 20,
      ),
    )));
  }

   
}
