import 'package:flutter/material.dart';
import '../products/Database_product.dart';
import '../Constants/Consants.dart';
import '../Product.dart';
import 'package:search_page/search_page.dart';

class Edit_elements extends StatefulWidget {
  static const screenID = 'Edit_elements';

  @override
  _Edit_elementsState createState() => _Edit_elementsState();
}

class _Edit_elementsState extends State<Edit_elements> {
  final data = Database_product();
  List<Product> products_list = [];
  final form_key = GlobalKey<FormState>();

  bool isLoading = false;

  TextEditingController name_controller = TextEditingController();
  TextEditingController type_controller = TextEditingController();
  TextEditingController price_controller = TextEditingController();

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
          'تعديل الأصناف',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        tooltip: 'Search products',
        onPressed: () => showSearch(
          context: context,
          delegate: SearchPage<Product>(
            barTheme: ThemeData(
              primaryColor: mainColor,
              appBarTheme: AppBarTheme(backgroundColor: mainColor),
              textTheme:
                  Theme.of(context).textTheme.apply(bodyColor: Colors.white),
            ),
            onQueryUpdate: (s) => print(s),
            items: products_list,
            searchLabel: 'ادخل اسم الصنف',
            failure: Center(
              child: Text('لا يوجد اصناف'),
            ),
            filter: (product) => [
              product.name,
            ],
            builder: (product) => Column(
              children: [
                ListTile(
                  title: Text(
                    product.name,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.price.toString(),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'السعر',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          value: 'edit',
                          child: Text(
                            'تعديل',
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'حذف',
                            textDirection: TextDirection.rtl,
                          ),
                        )
                      ];
                    },
                    onSelected: (String value) {
                      if (value == 'delete') {
                        data.deleteDB(product);
                        refreshProducts();
                      }
                      if (value == 'edit') {
                        name_controller.text = product.name;
                        type_controller.text = product.type;
                        price_controller.text = product.price.toString();
                        showDialog(
                            context: context,
                            builder: (ctc) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: Text(
                                      'تعديل الصنف',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 10),
                                          child: TextFormField(
                                            key: ValueKey('name'),
                                            validator: (val) {
                                              if (val!.isEmpty)
                                                return 'أدخل اسم الصنف';
                                            },
                                            textDirection: TextDirection.rtl,
                                            controller: name_controller,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                            decoration: InputDecoration(
                                              errorStyle: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                              hintText: 'اسم الصنف',
                                              hintStyle: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                              hintTextDirection:
                                                  TextDirection.rtl,
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 10),
                                          child: TextFormField(
                                            key: ValueKey('type'),
                                            validator: (val) {
                                              if (val!.isEmpty)
                                                return 'أدخل النوع';
                                            },
                                            textDirection: TextDirection.rtl,
                                            controller: type_controller,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
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
                                              hintTextDirection:
                                                  TextDirection.rtl,
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0,
                                              right: 10,
                                              top: 0,
                                              bottom: 10),
                                          child: TextFormField(
                                            key: ValueKey('price'),
                                            validator: (val) {
                                              if (val!.isEmpty)
                                                return 'أدخل السعر';
                                            },
                                            textDirection: TextDirection.rtl,
                                            controller: price_controller,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                            ),
                                            decoration: InputDecoration(
                                              errorStyle: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                              hintText: 'السعر',
                                              hintStyle: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                              hintTextDirection:
                                                  TextDirection.rtl,
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.white,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            form_key.currentState!.validate();
                                            if (form_key.currentState!
                                                .validate()) {
                                              data.updateDB(Product(
                                                  id: product.id,
                                                  name: name_controller.text,
                                                  type: type_controller.text,
                                                  price: double.parse(
                                                      price_controller.text)));
                                              Navigator.pop(ctc);
                                              Navigator.pop(context);
                                              
                                              refreshProducts();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'تم تعديل الصنف')));
                                            }
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: Center(
                                              child: Text(
                                                'تعديل',
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
                                ],
                              );
                            });
                      }
                    },
                  ),
                ),
                Divider(
                  height: 10,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
        child: Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
      body: Form(
        key: form_key,
        child: ListView.separated(
          itemCount: products_list.length,
          itemBuilder: (ctx, index) {
            return ListTile(
              title: Text(
                products_list[index].name,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    products_list[index].price.toString(),
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'السعر',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              trailing: PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text(
                        'تعديل',
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'حذف',
                        textDirection: TextDirection.rtl,
                      ),
                    )
                  ];
                },
                onSelected: (String value) {
                  if (value == 'delete') {
                    data.deleteDB(products_list[index]);
                    refreshProducts();
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('تم حذف الصنف')));
                  }
                  if (value == 'edit') {
                    name_controller.text = products_list[index].name;
                    type_controller.text = products_list[index].type;
                    price_controller.text =
                        products_list[index].price.toString();
                    showDialog(
                        context: context,
                        builder: (ctc) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AlertDialog(
                                backgroundColor: Colors.white,
                                title: Text(
                                  'تعديل الصنف',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 10),
                                      child: TextFormField(
                                        key: ValueKey('name'),
                                        validator: (val) {
                                          if (val!.isEmpty)
                                            return 'أدخل اسم الصنف';
                                        },
                                        textDirection: TextDirection.rtl,
                                        controller: name_controller,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                          hintText: 'اسم الصنف',
                                          hintStyle: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                          hintTextDirection: TextDirection.rtl,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 10),
                                      child: TextFormField(
                                        key: ValueKey('type'),
                                        validator: (val) {
                                          if (val!.isEmpty) return 'أدخل النوع';
                                        },
                                        textDirection: TextDirection.rtl,
                                        controller: type_controller,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
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
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10,
                                          top: 0,
                                          bottom: 10),
                                      child: TextFormField(
                                        key: ValueKey('price'),
                                        validator: (val) {
                                          if (val!.isEmpty) return 'أدخل السعر';
                                        },
                                        textDirection: TextDirection.rtl,
                                        controller: price_controller,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                          errorStyle: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                          hintText: 'السعر',
                                          hintStyle: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                          ),
                                          hintTextDirection: TextDirection.rtl,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        form_key.currentState!.validate();
                                        if (form_key.currentState!.validate()) {
                                          data.updateDB(Product(
                                              id: products_list[index].id,
                                              name: name_controller.text,
                                              type: type_controller.text,
                                              price: double.parse(
                                                  price_controller.text)));
                                          Navigator.pop(ctc);
                                          refreshProducts();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text('تم تعديل الصنف')));
                                        }
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Center(
                                          child: Text(
                                            'تعديل',
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
                            ],
                          );
                        });
                  }
                },
              ),
            );
          },
          separatorBuilder: (ctx, index) {
            return Divider(
              height: 10,
              color: Colors.black,
            );
          },
        ),
      ),
    );
  }
}
