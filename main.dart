import 'package:flutter/material.dart';
import 'package:pricing_app_common/products/Products_home.dart';

import 'Constants/Consants.dart';
import 'Fawateer/DataBase_Fawateer.dart';
import 'Fawateer/Fatorah_View.dart';
import 'Fawateer/Fawateer_Menu.dart';
import 'products/Add_Element.dart';
import 'products/Edit_sarf_All_Prices.dart';
import 'products/Edit_sarf_elements.dart';
import 'products/Pricing_sarf_elements.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      title: 'تسعير',
      routes: {
        Products_Home.screenID: (context) => Products_Home(),
        Add_Element.screenID: (context) => Add_Element(),
        Pricing_product.screenID: (context) => Pricing_product(),
        Edit_elements.screenID: (context) => Edit_elements(),
        Edit_All_Prices.screenID: (context) => Edit_All_Prices(),
        Fatorah_view.screenID: (context) => Fatorah_view(),
        Fawateer_Menu.screenID: (context) => Fawateer_Menu(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var db = DataBase_Fawateer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        centerTitle: true,
        title: Text(
          'القائمة الرئيسية',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 30),
        child: ListView(
          shrinkWrap: true,
          children: [
            GestureDetector(
              onTap: () {
                db.getDB();
                Navigator.pushNamed(context, Products_Home.screenID);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 100, left: 100, right: 100),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: secColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 70,
                        width: 100,
                        child: Image.asset('assets/box.png'),
                      ),
                      Text(
                        'المنتجات',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (() {
                db.getDB();

                Navigator.pushNamed(context, Fawateer_Menu.screenID);
              }),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 80),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: secColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Container(
                        height: 70,
                        width: 100,
                        child: Image.asset('assets/bill.png'),
                      ),
                      Text(
                        'الفواتير',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
