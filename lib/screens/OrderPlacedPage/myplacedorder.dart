import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:shop_app/theme/colors.dart';

//import 'CheckOutPage.dart';

class MyPlacedOrder extends StatefulWidget {
  @override
  _MyPlacedOrderState createState() => _MyPlacedOrderState();
}

class _MyPlacedOrderState extends State<MyPlacedOrder> {
  CollectionReference orders = FirebaseFirestore.instance
      .collection("USERS")
      .doc(authobj.currentUser.uid)
      .collection("orderplaced");

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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
            backgroundColor: Colors.white,
            title: Text(
              'Order Placed',
              style: TextStyle(color: kPrimaryColor),
            ),
            shadowColor: kPrimaryColor,
            actionsIconTheme: IconThemeData(color: kPrimaryColor),
          ),
          body: StreamBuilder(
              stream: orders.snapshots(),
              builder: (sContext, snapshot) {
                if (!snapshot.hasData || (snapshot.data.docs.length == 0)) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 80),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/splash_2.png'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'No Order Placed!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 36,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Looks like you didn\'t \n add anything to your cart yet',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
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
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(
                                            _card.get('buyername'),
                                            style: TextStyle(fontFamily: 'Muli')
                                                .copyWith(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                          ),
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          Text(
                                            _card.get('buyeremailid'),
                                            style: TextStyle(fontFamily: 'Muli')
                                                .copyWith(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                          ),
                                          Text(
                                            _card.get('buyeraddress'),
                                            style: TextStyle(fontFamily: 'Muli')
                                                .copyWith(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                          ),
                                          Text(
                                            _card.get('size'),
                                            style: TextStyle(fontFamily: 'Muli')
                                                .copyWith(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                          ),
                                          Text(
                                            _card.get('color'),
                                            style: TextStyle(fontFamily: 'Muli')
                                                .copyWith(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                          ),
                                          Text(
                                            _card.get('buyerphonenumber'),
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
                                                SizedBox(
                                                  width: 1,
                                                ),
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
                          ],
                        );
                      });
                }
              })),
    );
  }
}
