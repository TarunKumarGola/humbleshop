import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'dart:ui' as ui;
import 'package:shop_app/homepage_widget/common_widgets.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:shop_app/theme/colors.dart';

//import 'CheckOutPage.dart';

class MyOrder extends StatefulWidget {
  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  CollectionReference orders = FirebaseFirestore.instance
      .collection("SELLERS")
      .doc(sellerobj.selleruid)
      .collection("orderplaced");
  Color endcolor = Color(0xffF8556D);
  String countryvalue = 'Set Status';
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
            title: Text('Order Received'),
          ),
          body: StreamBuilder(
              stream: orders.snapshots(),
              builder: (sContext, snapshot) {
                if (!snapshot.hasData) {
                  return Text(
                    'No OrderYet...',
                  );
                } else {
                  print('tarun${snapshot.data.docs}');
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot _card =
                            snapshot.data.documents[index];
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: 350,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFF50057),
                                          Color(0xFFF50057)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFFF50057),
                                        blurRadius: 12,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned.fill(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 4,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                _card.get('name'),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Avenir',
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 20),
                                              ),
                                              Text(
                                                _card.get('speciality'),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Avenir',
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.account_box,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      _card.get('buyername'),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'Avenir',
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                _card.get('buyeremailid'),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Avenir',
                                                  fontSize: 17,
                                                ),
                                              ),
                                              Text(
                                                _card.get('buyerphonenumber'),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Avenir',
                                                    fontSize: 17),
                                              ),
                                              Text(
                                                _card.get('size'),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Avenir',
                                                    fontSize: 17),
                                              ),
                                              Text(
                                                _card.get('color'),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Avenir',
                                                    fontSize: 17),
                                              ),
                                              Text(
                                                _card.get('buyeraddress'),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Avenir',
                                                    fontSize: 17),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                '₹${_card.get('price')}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Avenir',
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                        /*Expanded(
                                          flex: 2,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Container(
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.white,
                                                      blurRadius: 12,
                                                      offset: Offset(0, 6),
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: DropdownButton<String>(
                                                    value: countryvalue,
                                                    elevation: 16,
                                                    style: TextStyle(
                                                        backgroundColor:
                                                            Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    onChanged:
                                                        (String newValue) {
                                                      setState(() {
                                                        countryvalue = newValue;
                                                      });
                                                    },
                                                    items: <String>[
                                                      'Set Status',
                                                      'Accepted',
                                                      'Dispatched',
                                                      'Delivered',
                                                    ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.pink),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),*/
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }
              })),
    );
  }
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
