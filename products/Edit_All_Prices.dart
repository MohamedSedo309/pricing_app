import 'package:flutter/material.dart';
import '../products/Database_product.dart';
import '../Constants/Consants.dart';
import '../Product.dart';


class Edit_All_Prices extends StatefulWidget {
  static const screenID = 'Edit_All_Prices';

  @override
  _Edit_All_PricesState createState() => _Edit_All_PricesState();
}

class _Edit_All_PricesState extends State<Edit_All_Prices> {
  final form_key = GlobalKey<FormState>();
  var data = Database_product();
  bool isLoading = false;

  List<Product> products_list = [];
  Product product = Product(name: '', type: '', price: 0);

  int type_group_VAL = 0;
  TextEditingController type_controller = TextEditingController();
  TextEditingController added_val_controller = TextEditingController();

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

    products_list = await data.readAllData() as List<Product>;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: mainColor,
        title: Text(
          'تعديل الليست',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      body: Form(
        key: form_key,
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Radio(
                              activeColor: Colors.amber,
                              value: 1,
                              onChanged: (val) {
                                setState(() {
                                  type_group_VAL = int.parse(val.toString());
                                  type_controller.text = 'نوع 3';
                                });
                              },
                              groupValue: type_group_VAL,
                            ),
                            Text(
                              'نوع 3',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: secColor,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              activeColor: Colors.amber,
                              value: 2,
                              onChanged: (val) {
                                setState(() {
                                  type_group_VAL = int.parse(val.toString());
                                  type_controller.text = 'نوع 2';
                                });
                              },
                              groupValue: type_group_VAL,
                            ),
                            Text(
                              'نوع 2',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: secColor,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              activeColor: Colors.amber,
                              value: 3,
                              onChanged: (val) {
                                setState(() {
                                  type_group_VAL = int.parse(val.toString());
                                  type_controller.text = 'نوع 1';
                                });
                              },
                              groupValue: type_group_VAL,
                            ),
                            Text(
                              'نوع 1',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: secColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: TextFormField(
                      key: ValueKey('type'),
                      validator: (val) {
                        if (val!.isEmpty) return 'أدخل النوع';
                      },
                      textDirection: TextDirection.rtl,
                      controller: type_controller,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        hintText: 'النوع',
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
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: TextFormField(
                      key: ValueKey('addedval'),
                      validator: (val) {
                        if (val!.isEmpty) return 'أدخل قيمة الزيادة';
                      },
                      textDirection: TextDirection.rtl,
                      controller: added_val_controller,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        hintText: 'قيمة الزيادة (رقم فقط)',
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
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      form_key.currentState!.validate();
                      if (form_key.currentState!.validate()) {
                        showDialog(
                            context: context,
                            builder: (ctc) {
                              return AlertDialog(
                                title: Text(
                                  'جميع منتجات شركة ' +
                                      '${type_controller.text}' +
                                      ' ستزيد اسعارها بقيمة ' +
                                      '%${added_val_controller.text}',
                                  textAlign: TextAlign.center,
                                ),
                                content: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(ctc);
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            color: mainColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border:
                                                Border.all(color: mainColor)),
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
                                      onTap: () {
                                        update_products_price();
                                        Navigator.pop(ctc);
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            color: mainColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border:
                                                Border.all(color: mainColor)),
                                        child: Center(
                                          child: Text(
                                            'موافق',
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
                              );
                            });
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 120,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black)),
                      child: Center(
                        child: Text(
                          'تعديل الليست',
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
      ),
    );
  }

  update_products_price() {
    for (var i = 0; i < products_list.length; i++) {
      if (products_list[i].type == type_controller.text) {
        setState(() {
          isLoading = true;
          product = products_list[i];
          double newPrice =
              ((int.parse(added_val_controller.text) / 100) * product.price) +
                  product.price;
          print(newPrice);

          product = Product(
              id: product.id,
              name: product.name,
              type: product.type,
              price: newPrice);
        });
        data.updateDB(product);
      }
    }
    setState(() {
      isLoading = false;
    });
  }
}
