import 'package:flutter/material.dart';

import '../Constants/Consants.dart';
import 'DataBase_Fawateer.dart';
import 'Fatorah_View.dart';
import 'Fawateer_Model.dart';

class Fawateer_Menu extends StatefulWidget {
  static const String screenID = 'Fawateer_Menu';

  @override
  State<Fawateer_Menu> createState() => _Fawateer_MenuState();
}

class _Fawateer_MenuState extends State<Fawateer_Menu> {
  var db = DataBase_Fawateer();
  List<Fatorah> fawateerList = [];
  @override
  void initState() {
    super.initState();

    db.getDB();
    refreshFawateer();
  }

  @override
  void dispose() {
    super.dispose();
    db.closeDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'قائمة الفواتير',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: mainColor,
      ),
      body: FutureBuilder<Object>(
          future: db.getDB(),
          builder: (context, snapshot) {
            List<Fatorah> fawateerReversed = fawateerList.reversed.toList();

            return ListView.separated(
              itemCount: fawateerReversed.length,
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Fatorah_view.screenID,
                        arguments: fawateerReversed[index]);
                  },
                  child: ListTile(
                    title: Text(
                      fawateerReversed[index].name,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      fawateerReversed[index].date,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    leading: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 30,
                      ),
                      onPressed: () {
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
                                  'حذف الفاتورة ؟',
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
                                      fawateerReversed[index].name,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: Center(
                                              child: Text(
                                                'لا',
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
                                            db.deleteDB_Fatorah(
                                                fawateerReversed[index]);
                                            refreshFawateer();
                                            setState(() {});
                                            Navigator.pop(ctc);
                                          }),
                                          child: Container(
                                            height: 50,
                                            width: 60,
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: Center(
                                              child: Text(
                                                'نعم',
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
                    ),
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return Divider(
                  color: Colors.black,
                );
              },
            );
          }),
    );
  }

  void refreshFawateer() async {
    db.db_Fawateer = await db.getDB();

    fawateerList = await db.readAllFawateer();
  }
}
