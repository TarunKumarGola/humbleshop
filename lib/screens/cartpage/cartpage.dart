import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
//import 'package:shopping_cart/utils/CustomTextStyle.dart';
//import 'package:shopping_cart/utils/CustomUtils.dart';
import 'package:shop_app/theme/colors.dart';
//import 'CheckOutPage.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CollectionReference orders = FirebaseFirestore.instance
      .collection("USERS")
      .doc(authobj.currentUser.uid)
      .collection("orders");
  int getColorHexFromStr(String colorStr) {
    colorStr = "FF" + colorStr;
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("An error occurred when converting a color");
      }
    }
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: primary, accentColor: Colors.pink[300]),
      home: Scaffold(
          resizeToAvoidBottomPadding: false,
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            centerTitle: true,
            title: Text('Shopping Cart'),
          ),
          body: StreamBuilder(
              stream: orders.snapshots(),
              builder: (sContext, snapshot) {
                if (!snapshot.hasData) {
                  return Text(
                    'NO item in you cart  ...',
                  );
                } else {
                  print('tarun${snapshot.data.docs}');
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot _card =
                            snapshot.data.documents[index];
                        return Stack(
                          children: <Widget>[
                            Container(
                              margin:
                                  EdgeInsets.only(left: 16, right: 16, top: 16),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(
                                                right: 8, top: 4),
                                            child: Text(
                                              _card.get('name'),
                                              maxLines: 2,
                                              softWrap: true,
                                              style:
                                                  TextStyle(fontFamily: 'Muli')
                                                      .copyWith(fontSize: 14),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(
                                            _card.get('speciality'),
                                            style: TextStyle(fontFamily: 'Muli')
                                                .copyWith(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                          ),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  '₹${_card.get('price')}',
                                                  style: TextStyle(
                                                          fontFamily: 'Muli')
                                                      .copyWith(
                                                          color: Colors
                                                              .pinkAccent),
                                                ),
                                                Text("color :"),
                                                MaterialButton(
                                                  shape: CircleBorder(
                                                      side: BorderSide(
                                                          width: 0,
                                                          color: Color(
                                                              getColorHexFromStr(
                                                                  _card.get(
                                                                      'color'))),
                                                          style: BorderStyle
                                                              .solid)),
                                                  padding: EdgeInsets.all(1),
                                                  elevation: 5,
                                                  color: Color(
                                                      getColorHexFromStr(
                                                          _card.get('color'))),
                                                  onPressed: () {},
                                                ),
                                                Text("size :"),
                                                Text(_card.get('size')),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: 30,
                                                    width: 100,
                                                    child: RaisedButton(
                                                      onPressed: () {
                                                        print(
                                                            'checkout button pressed');
                                                        // Navigator.push(context,
                                                        //     new MaterialPageRoute(builder: (context) => CheckOutPage()));
                                                      },
                                                      color: primary,
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          24))),
                                                      child: Text(
                                                        "Checkout",
                                                        style: TextStyle(
                                                                fontFamily:
                                                                    'Muli')
                                                            .copyWith(
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    flex: 100,
                                  )
                                ],
                              ),
                            ),
                            /* Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width: 24,
                                height: 24,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(right: 10, top: 8),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                    color: Colors.pink[500]),
                              ),
                            )*/
                          ],
                        );
                      });
                }
              })),
    );
  }
}
