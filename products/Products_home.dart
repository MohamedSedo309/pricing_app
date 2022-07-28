import 'package:flutter/material.dart';

import '../Constants/Consants.dart';
import '../Fawateer/DataBase_Fawateer.dart';
import 'Add_Element.dart';
import 'Edit_sarf_All_Prices.dart';
import 'Edit_sarf_elements.dart';
import 'Pricing_sarf_elements.dart';

class Products_Home extends StatelessWidget {
  static const screenID =  'Products_Home';  
  var db = DataBase_Fawateer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: mainColor,
        title: Text(
          'المنتجات',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50),
        child: Padding(
          padding: EdgeInsets.all(50),
          child: GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.9,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Add_Element.screenID);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: secColor,
                  ),
                  child: Column(                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [
                      Icon(
                        Icons.add,
                        size: 45,
                      ),
                      Text(
                        "إضافة",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Pricing_product.screenID);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: secColor,
                  ),
                  child: Column(                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [
                      Icon(
                        Icons.monetization_on_outlined,
                        size: 45,
                      ),
                      Text(
                        "تسعير",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Edit_elements.screenID);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: secColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                     Container(
                        height: 40,
                        width: 60,
                        child: Image.asset('assets/edit.png'),
                      ),
                      Text(
                        "تعديل",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Edit_All_Prices.screenID);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: secColor,
                  ),
                  child: Column(                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [
                   Container(
                        height: 50,
                        width: 70,
                        child: Image.asset('assets/writing.png'),
                      ),
                      Text(
                        "تعديل ليست كاملة",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                                                    fontWeight: FontWeight.bold

                        ),
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
}
