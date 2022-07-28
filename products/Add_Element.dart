import 'package:flutter/material.dart';
import '../products/Database_product.dart';
import '../Constants/Consants.dart';
import '../Product.dart';

class Add_Element extends StatefulWidget {
  static const screenID = 'Add_Element';

  @override
  _Add_sarf_ElementState createState() => _Add_sarf_ElementState();
}

class _Add_sarf_ElementState extends State<Add_Element> {
  var data = Database_product();

  bool isLoading = false;

  final form_key = GlobalKey<FormState>();

  TextEditingController name_controller = TextEditingController();
  TextEditingController inch_controller = TextEditingController();
  TextEditingController door_controller = TextEditingController();
  TextEditingController type_controller = TextEditingController();
  TextEditingController type2_controller = TextEditingController();
  TextEditingController full_name_controller = TextEditingController();
  TextEditingController price_controller = TextEditingController();

  int name_group_VAL = 0;
  int inch_group_VAL = 0;
  int door_group_VAL = 0;
  int type_group_VAL = 0;

  String bosa = 'بوصه';

  add_Product() async {
    form_key.currentState!.validate();
    if (form_key.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await data.createItem(Product(
          name: full_name_controller.text,
          type: type_controller.text == ''
              ? type2_controller.text
              : type_controller.text,
          price: double.parse(price_controller.text)));
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم اضافة ' + full_name_controller.text)));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    data.getDB();
  }

  @override
  void dispose() {
    super.dispose();
    data.closeDB();
  }

  @override
  Widget build(BuildContext context) {
    get_fullName();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: mainColor,
        title: Text(
          'إضافة صنف',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: mainColor,
      body: SingleChildScrollView(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              )
            : Form(
              key: form_key,
              child: Column(
                children: [
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0 , vertical: 40),
                    child: TextFormField(
                      key: ValueKey('name'),
                      validator: (val) {
                        if (val!.isEmpty) return 'أدخل اسم الصنف';
                        if (type_controller.text == '' &&
                            type2_controller.text == '')
                          return 'يجب اختيار النوع';
                      },
                      textDirection: TextDirection.rtl,
                      controller: full_name_controller,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        hintText: 'أدخل اسم الصنف',
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
                        horizontal: 10.0, vertical: 10),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Radio(
                                activeColor: Colors.amber,
                                value: 1,
                                onChanged: (val) {
                                  setState(() {
                                    type_group_VAL =
                                        int.parse(val.toString());
                                    type2_controller.text = 'نوع 1';
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
                          Row(
                            children: [
                              Radio(
                                activeColor: Colors.amber,
                                value: 2,
                                onChanged: (val) {
                                  setState(() {
                                    type_group_VAL =
                                        int.parse(val.toString());
                                    type2_controller.text = 'نوع 2';
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
                                    type_group_VAL =
                                        int.parse(val.toString());
                                    type2_controller.text = 'نوع 3';
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
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 40),
                    child: TextFormField(
                      key: ValueKey('price'),
                      validator: (val) {
                        if (val!.isEmpty) return 'أدخل سعر الصنف';
                      },
                      textDirection: TextDirection.rtl,
                      controller: price_controller,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 25,
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
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      add_Product();
                      FocusManager.instance.primaryFocus?.unfocus();
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
                          'إضافة',
                          style: TextStyle(
                            fontSize: 25,
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
      ),
    );
  }

  get_fullName() {
    if (name_controller.text != '' ||
        inch_controller.text != '' ||
        door_controller.text != '' ||
        type_controller.text != '') {
      setState(() {
        full_name_controller.text = name_controller.text +
            ' ' +
            type_controller.text +
            ' ' +
            door_controller.text +
            ' ' +
            inch_controller.text;
      });
    }
  }
}
