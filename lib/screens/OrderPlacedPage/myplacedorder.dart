import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:shop_app/screens/reviewscreen/review.dart';
import 'package:shop_app/theme/colors.dart';
import 'package:toast/toast.dart';

//import 'CheckOutPage.dart';

class MyPlacedOrder extends StatefulWidget {
  @override
  _MyPlacedOrderState createState() => _MyPlacedOrderState();
}

class _MyPlacedOrderState extends State<MyPlacedOrder> {
  CollectionReference orders = FirebaseFirestore.instance
      .collection("USERS")
      .doc(authobj.currentUser.email)
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
                                                RaisedButton(
                                                  onPressed: () async {
                                                    FirebaseFirestore.instance
                                                        .collection("Return")
                                                        .doc()
                                                        .set({
                                                      "Buyerid": authobj
                                                          .currentUser.uid,
                                                      "Buyeremailid": authobj
                                                          .currentUser.email,
                                                      "productuid": _card
                                                          .get('productuid')
                                                    });
                                                    custumersendMail(
                                                        authobj
                                                            .currentUser.email,
                                                        authobj
                                                            .currentUser.name,
                                                        _card.get('price'));
                                                    Toast.show(
                                                        "Return Request Sent",
                                                        context);
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  24.0))),
                                                  child: Text('Return'),
                                                  textColor: Colors.white,
                                                  splashColor: Colors.red,
                                                  color: Colors.green,
                                                ),
                                                RaisedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                            builder: (context) => ReviewPage(
                                                                productuid: _card
                                                                    .get(
                                                                        'productuid')
                                                                    .toString())));
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  24.0))),
                                                  child: Text('Review'),
                                                  textColor: Colors.white,
                                                  splashColor: Colors.red,
                                                  color: Colors.green,
                                                ),
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

  custumersendMail(String email, String name, String price) async {
    String username = 'humblemarketofficial@gmail.com';
    String password = 'qwerty123qwertyK';

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = Address(username, 'Your name')
      ..recipients.add(email)
      ..ccRecipients.addAll([email, email])
      ..bccRecipients.add(Address(email))
      ..subject =
          'We are processing your return request :: 😀 :: ${DateTime.now()}'
      ..text = 'We are processing your return request. You Ordered ' +
          name +
          "At price " +
          price
      ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
