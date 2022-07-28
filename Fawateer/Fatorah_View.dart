import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pricing_app_common/products/Database_product.dart';

import 'package:searchfield/searchfield.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../Constants/Consants.dart';
import '../Product.dart';
import 'dart:io';

import 'DataBase_Fawateer.dart';
import 'Fawateer_Model.dart';
import 'package:permission_handler/permission_handler.dart';

class Fatorah_view extends StatefulWidget {
  static const String screenID = 'FatorahView';
  @override
  State<Fatorah_view> createState() => _Fatorah_viewState();
}

class _Fatorah_viewState extends State<Fatorah_view> {
  var db = DataBase_Fawateer();
  var db_1 = Database_product();

  List<Fatorah_Item> itemsList = [];
  List<Product> productslist = [];
  Product product = Product(name: '', type: '', price: 0);

  final name_form = GlobalKey<FormState>();
  TextEditingController name_edit = TextEditingController();

  final quantity_form = GlobalKey<FormState>();
  TextEditingController quantity_edit = TextEditingController();

  final add_form = GlobalKey<FormState>();
  TextEditingController add_name = TextEditingController();
  TextEditingController add_quantity = TextEditingController();

  @override
  void initState() {
    super.initState();

    db.getDB();

    refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    Fatorah fatorah = ModalRoute.of(context)!.settings.arguments as Fatorah;
    int? id_fk = fatorah.id;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        actions: [
          IconButton(
            onPressed: () async {
              Permission.storage.request();
              var status = await Permission.storage.status;
              if (!status.isGranted) {
                await Permission.storage.request();
              }
              if (status.isGranted) {
                pw.Document pdf = pw.Document();

                pdf = await makePdf(fatorah);

                final String path =
                    '/storage/emulated/0/Download/${fatorah.name.replaceAll(' ' , '')}' +
                        '.pdf';
                final file = File(path);
                await file.writeAsBytes(await pdf.save());
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('${file.path}' + 'تم حفظ الملف في ...')));
                print(file.path.toString());
              }
            },
            icon: Icon(
              Icons.picture_as_pdf,
              size: 30,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          IconButton(
            onPressed: (() {
              showDialog(
                  context: context,
                  builder: (ctc) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 60,
                        horizontal: 20,
                      ),
                      child: AlertDialog(
                        backgroundColor: mainColor,
                        title: Text(
                          'إضافة صنف',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        content: Form(
                          key: add_form,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Container(
                                child: SearchField<Product>(
                                  key: ValueKey('product'),
                                  validator: (val) {
                                    if (product.name == '') return 'ادخل الصنف';
                                  },
                                  onSuggestionTap:
                                      (SearchFieldListItem<dynamic> val) {
                                    setState(() {
                                      product = val.item!;
                                    });
                                  },
                                  controller: add_name,
                                  hint: 'إسم الصنف',
                                  suggestionItemDecoration: BoxDecoration(),
                                  searchStyle: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                  searchInputDecoration: InputDecoration(
                                    errorStyle: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
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
                                  suggestions: productslist
                                      .map(
                                        (e) => SearchFieldListItem<Product>(
                                          e.name,
                                          item: e,
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: TextFormField(
                                  key: ValueKey('quantity_add'),
                                  onSaved: (val) {
                                    add_quantity.text = val!;
                                  },
                                  validator: (val) {
                                    if (val!.isEmpty) return 'ادخل العدد';
                                  },
                                  textDirection: TextDirection.rtl,
                                  controller: add_quantity,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                      fontSize: 20,
                                      color: secColor,
                                    ),
                                    hintText: 'العدد',
                                    hintStyle: TextStyle(
                                      fontSize: 20,
                                      color: secColor,
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
                              ),
                              GestureDetector(
                                onTap: () {
                                  addto_Fatorah(id_fk!);
                                  refreshItems();
                                  Navigator.pop(ctc);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(10),
                                        border:
                                            Border.all(color: Colors.black)),
                                    height: 40,
                                    child: Icon(
                                      Icons.add,
                                      color: secColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }),
            icon: Icon(
              Icons.add_circle_outline_rounded,
              size: 30,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: (() {
                showDialog(
                    context: context,
                    builder: (ctc) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 100,
                          horizontal: 20,
                        ),
                        child: AlertDialog(
                          backgroundColor: mainColor,
                          title: Text(
                            'معلومات التعديل',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          content: ListView(
                            shrinkWrap: true,
                            children: [
                              Text(
                                '1. .لتعديل اسم الفاتورة قم بالضغط عليه',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '2. .لتعديل عدد الصنف اضغط على العدد المقابل للصنف المطلوب تعديله',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '3. .لحذف صنف من الفاتورة قم بالضغط مطولا على اسم هذا الصنف',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }),
              icon: Icon(
                Icons.info_outline,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<Object>(
          future: db.getDB().then((value) async {
            itemsList = await db.readAllitems(id_fk!);
            return db.readAllitems(id_fk);
          }),
          builder: (context, snapshot) {
            return ListView(
              children: [
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
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (ctc) {
                                    name_edit.text = fatorah.name;
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 100,
                                        horizontal: 20,
                                      ),
                                      child: Form(
                                        key: name_form,
                                        child: AlertDialog(
                                          backgroundColor: mainColor,
                                          title: Text(
                                            'تغيير الإسم الى ...',
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          content: ListView(
                                            shrinkWrap: true,
                                            children: [
                                              TextFormField(
                                                key: ValueKey('name'),
                                                onSaved: (val) {
                                                  name_edit.text = val!;
                                                },
                                                validator: (val) {
                                                  if (val!.isEmpty)
                                                    return 'ادخل اسم الفاتورة';
                                                },
                                                textDirection:
                                                    TextDirection.rtl,
                                                controller: name_edit,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                ),
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                  errorStyle: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                  ),
                                                  hintText: 'إسم الفاتورة',
                                                  hintStyle: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                  ),
                                                  hintTextDirection:
                                                      TextDirection.rtl,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: secColor,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: mainColor,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              GestureDetector(
                                                onTap: (() {
                                                  name_form.currentState!
                                                      .validate();
                                                  if (name_form.currentState!
                                                      .validate()) {
                                                    name_form.currentState!
                                                        .save();

                                                    db.updateDB_Fatorah(Fatorah(
                                                      id: fatorah.id,
                                                      name: name_edit.text,
                                                      date: fatorah.date,
                                                    ));
                                                  }
                                                  setState(() {
                                                    fatorah = Fatorah(
                                                      id: fatorah.id,
                                                      name: name_edit.text,
                                                      date: fatorah.date,
                                                    );
                                                  });

                                                  Navigator.pop(ctc);
                                                }),
                                                child: Container(
                                                  height: 50,
                                                  width: 60,
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: Colors.black)),
                                                  child: Center(
                                                    child: Text(
                                                      'حفظ',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: secColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text(
                                fatorah.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    fatorah.date,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    ':',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'التاريخ',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
                        4: FlexColumnWidth(0.5)
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
                        4: FlexColumnWidth(0.5)
                      },
                      border: TableBorder.all(color: Colors.black),
                      children: List<TableRow>.generate(
                        itemsList.length,
                        (index) {
                          return TableRow(
                            children: [
                              GestureDetector(
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctc) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 100,
                                          horizontal: 20,
                                        ),
                                        child: Form(
                                          key: name_form,
                                          child: AlertDialog(
                                            backgroundColor: mainColor,
                                            title: Text(
                                              'حذف الصنف ؟',
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                            content: ListView(
                                              shrinkWrap: true,
                                              children: [
                                                Text(
                                                  itemsList[index].name,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: (() {
                                                        setState(() {});
                                                        Navigator.pop(ctc);
                                                      }),
                                                      child: Container(
                                                        height: 50,
                                                        width: 60,
                                                        decoration: BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black)),
                                                        child: Center(
                                                          child: Text(
                                                            'لا',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: secColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: (() {
                                                        db.deleteItemDB(
                                                            itemsList[index]);
                                                        setState(() {});
                                                        Navigator.pop(ctc);
                                                      }),
                                                      child: Container(
                                                        height: 50,
                                                        width: 60,
                                                        decoration: BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black)),
                                                        child: Center(
                                                          child: Text(
                                                            'نعم',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  itemsList[index].name,
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctc) {
                                      quantity_edit.text =
                                          itemsList[index].quantity.toString();
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 100,
                                          horizontal: 20,
                                        ),
                                        child: Form(
                                          key: quantity_form,
                                          child: AlertDialog(
                                            backgroundColor: mainColor,
                                            title: Text(
                                              'تغيير العدد الى ...',
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                            content: ListView(
                                              shrinkWrap: true,
                                              children: [
                                                TextFormField(
                                                  key: ValueKey('editquantity'),
                                                  onSaved: (val) {
                                                    quantity_edit.text = val!;
                                                  },
                                                  validator: (val) {
                                                    if (val!.isEmpty)
                                                      return 'ادخل العدد';
                                                  },
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  controller: quantity_edit,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
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
                                                    hintTextDirection:
                                                        TextDirection.rtl,
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: secColor,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: mainColor,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                GestureDetector(
                                                  onTap: (() {
                                                    quantity_form.currentState!
                                                        .validate();
                                                    if (quantity_form
                                                        .currentState!
                                                        .validate()) {
                                                      quantity_form
                                                          .currentState!
                                                          .save();

                                                      db.updateItemDB(
                                                          Fatorah_Item(
                                                        id: itemsList[index].id,
                                                        name: itemsList[index]
                                                            .name,
                                                        quantity: int.parse(
                                                            quantity_edit.text),
                                                        sPrice: itemsList[index]
                                                            .sPrice,
                                                        id_FK: itemsList[index]
                                                            .id_FK,
                                                      ));
                                                    }

                                                    setState(() {});
                                                    Navigator.pop(ctc);
                                                  }),
                                                  child: Container(
                                                    height: 50,
                                                    width: 60,
                                                    decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                            color:
                                                                Colors.black)),
                                                    child: Center(
                                                      child: Text(
                                                        'حفظ',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: secColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  itemsList[index].quantity.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                itemsList[index].sPrice.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${double.parse((itemsList[index].sPrice * itemsList[index].quantity).toStringAsFixed(2))}',
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
            );
          }),
    );
  }

  addto_Fatorah(int id_fk) {
    add_form.currentState!.validate();
    if (add_form.currentState!.validate()) {
      setState(() {
        db.createItem(
            Fatorah_Item(
                name: product.name,
                quantity: int.parse(add_quantity.text),
                sPrice: product.price,
                id_FK: id_fk),
            id_fk);
      });
      add_form.currentState!.reset();
    }
  }

  void refreshItems() async {
    db.db_Fawateer = await db.getDB();

    db_1.product_database = await db_1.getDB();
    
    

    productslist = await db_1.readAllData();
  }

  String get_sum() {
    double sum = 0;
    if (itemsList == [])
      return '0';
    else {
      for (var i = 0; i < itemsList.length; i++) {
        sum += itemsList[i].sPrice * itemsList[i].quantity;
      }
      return sum.toStringAsFixed(2);
    }
  }

  Future<pw.Document> makePdf(Fatorah fatorah) async {
    final pdf = pw.Document();
    var data = await rootBundle.load("assets/Vazirmatn-VariableFont_wght.ttf");
    var myFont = pw.Font.ttf(data);
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.ListView(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Container(
                  width: double.infinity,
                  color: PdfColor.fromHex('FFFFFF'),
                  child: pw.Table(
                    border:
                        pw.TableBorder.all(color: PdfColor.fromHex('000000')),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Text(
                            fatorah.name,
                            textAlign: pw.TextAlign.center,
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                              font: myFont,
                              fontSize: 25,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(horizontal: 15),
                            child: pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  fatorah.date,
                                  textDirection: pw.TextDirection.rtl,
                                  style: pw.TextStyle(
                                    font: myFont,
                                    fontSize: 25,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Text(
                                  ':',
                                  textDirection: pw.TextDirection.rtl,
                                  style: pw.TextStyle(
                                    font: myFont,
                                    fontSize: 25,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Text(
                                  'التاريخ',
                                  textDirection: pw.TextDirection.rtl,
                                  style: pw.TextStyle(
                                    font: myFont,
                                    fontSize: 25,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Container(
                  width: double.infinity,
                  child: pw.Table(
                    columnWidths: {
                      0: pw.FlexColumnWidth(3.5),
                      1: pw.FlexColumnWidth(1),
                      2: pw.FlexColumnWidth(1),
                      3: pw.FlexColumnWidth(1),
                      4: pw.FlexColumnWidth(0.5)
                    },
                    border:
                        pw.TableBorder.all(color: PdfColor.fromHex("000000")),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Text(
                            'إسم الصنف',
                            textAlign: pw.TextAlign.center,
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                              font: myFont,
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            'العدد',
                            textAlign: pw.TextAlign.center,
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                              fontSize: 15,
                              font: myFont,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            'سعر الوحدة',
                            textAlign: pw.TextAlign.center,
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              font: myFont,
                            ),
                          ),
                          pw.Text(
                            'السعر',
                            textAlign: pw.TextAlign.center,
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                              font: myFont,
                              fontSize: 15,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.Text(
                            'م',
                            textAlign: pw.TextAlign.center,
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                              font: myFont,
                              fontSize: 15,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Container(
                  color: PdfColor.fromHex('FFFFFF'),
                  child: pw.Table(
                    columnWidths: {
                      0: pw.FlexColumnWidth(3.5),
                      1: pw.FlexColumnWidth(1),
                      2: pw.FlexColumnWidth(1),
                      3: pw.FlexColumnWidth(1),
                      4: pw.FlexColumnWidth(0.5)
                    },
                    border:
                        pw.TableBorder.all(color: PdfColor.fromHex('000000')),
                    children: [
                      for (var index = 0; index < itemsList.length; index++)
                        pw.TableRow(
                          children: [
                            pw.Text(
                              itemsList[index].name,
                              textAlign: pw.TextAlign.center,
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                                font: myFont,
                              ),
                            ),
                            pw.Text(
                              itemsList[index].quantity.toString(),
                              textAlign: pw.TextAlign.center,
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(
                                fontSize: 15,
                                fontWeight: pw.FontWeight.bold,
                                font: myFont,
                              ),
                            ),
                            pw.Text(
                              itemsList[index].sPrice.toString(),
                              textAlign: pw.TextAlign.center,
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(
                                fontSize: 15,
                                fontWeight: pw.FontWeight.bold,
                                font: myFont,
                              ),
                            ),
                            pw.Text(
                              '${itemsList[index].sPrice * itemsList[index].quantity}',
                              textAlign: pw.TextAlign.center,
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(
                                fontSize: 15,
                                fontWeight: pw.FontWeight.bold,
                                font: myFont,
                              ),
                            ),
                            pw.Text(
                              '${index + 1}',
                              textAlign: pw.TextAlign.center,
                              textDirection: pw.TextDirection.rtl,
                              style: pw.TextStyle(
                                fontSize: 15,
                                fontWeight: pw.FontWeight.bold,
                                font: myFont,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(
                  right: 10,
                  left: 10,
                  bottom: 20,
                ),
                child: pw.Container(
                  width: double.infinity,
                  color: PdfColor.fromHex('FFFFFF'),
                  child: pw.Table(
                    columnWidths: {
                      0: pw.FlexColumnWidth(5),
                      1: pw.FlexColumnWidth(1),
                    },
                    border:
                        pw.TableBorder.all(color: PdfColor.fromHex('000000')),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Text(
                            'إجمالي الفاتورة',
                            textAlign: pw.TextAlign.center,
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                              fontSize: 17,
                              fontWeight: pw.FontWeight.bold,
                              font: myFont,
                            ),
                          ),
                          pw.Text(
                            get_sum(),
                            textAlign: pw.TextAlign.center,
                            textDirection: pw.TextDirection.rtl,
                            style: pw.TextStyle(
                              fontSize: 17,
                              fontWeight: pw.FontWeight.bold,
                              font: myFont,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }));

    return pdf;
  }
}
