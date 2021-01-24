import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/OrderPlacedPage/myplacedorder.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:shop_app/theme/colors.dart';
import 'package:toast/toast.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Razorpay _razorpay;
  String pname = "";
  String price = "";
  String selleruid = "";
  String color = "";
  String productuid = "";
  String size = "";
  String speciality = "";
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
  void initState() {
    super.initState();
    _razorpay = new Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlerPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlerErrorFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handlerExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void checkout(name, price) {
    options = {
      "key": "rzp_test_aRmBQvWMybUfXx",
      "amount": num.parse(price) * 100,
      "name": authobj.currentUser.name,
      "description": "Payment for " + name,
      "prefill": {
        "contact": authobj.currentUser.phonenumber,
        "email": authobj.currentUser.email,
      },
      "external": {
        "wallets": ["paytm", "googlepay"]
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print('Makicho$e');
    }
  }

  void _handlerPaymentSuccess(PaymentSuccessResponse response) {
    print("Tarun Payment Success");
    Toast.show("Payment SuccessFull", context);
    FirebaseFirestore.instance
        .collection("SELLERS")
        .doc(selleruid)
        .collection("orderplaced")
        .doc()
        .set({
      "name": pname,
      "price": price,
      "productuid": productuid,
      "color": color,
      "size": size,
      "speciality": speciality,
      "buyername": authobj.currentUser.name,
      "buyeremailid": authobj.currentUser.email,
      "buyeraddress": authobj.currentUser.address,
      "buyerphonenumber": authobj.currentUser.phonenumber
    });
    FirebaseFirestore.instance
        .collection("USERS")
        .doc(selleruid)
        .collection("orderplaced")
        .doc()
        .set({
      "name": pname,
      "price": price,
      "productuid": productuid,
      "color": color,
      "size": size,
      "speciality": speciality,
      "buyername": authobj.currentUser.name,
      "buyeremailid": authobj.currentUser.email,
      "buyeraddress": authobj.currentUser.address,
      "buyerphonenumber": authobj.currentUser.phonenumber
    });
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => MyPlacedOrder()));
  }

  void _handlerErrorFailure(PaymentFailureResponse response) {
    print("Payment error");
    Toast.show("Payment error", context);
  }

  void _handlerExternalWallet(ExternalWalletResponse response) {
    Toast.show("Payment ExternalWalletResponse", context);
  }

  var options;

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
              'Shopping Cart',
              style: TextStyle(color: kPrimaryColor),
            ),
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: handleclick,
                itemBuilder: (BuildContext context) {
                  return {'Order Placed'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
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
                            image: AssetImage('assets/images/splash_1.png'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Your Cart Is Empty!',
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

                                                MaterialButton(
                                                  shape: CircleBorder(
                                                      side: BorderSide(
                                                    width: 0,
                                                    color: Color(
                                                        getColorHexFromStr(_card
                                                            .get('color'))),
                                                  )),
                                                  padding: EdgeInsets.all(0),
                                                  elevation: 5,
                                                  color: Color(
                                                      getColorHexFromStr(
                                                          _card.get('color'))),
                                                  onPressed: () {},
                                                ),
                                                //   Text("size :"),
                                                //   Text(_card.get('size')),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Container(
                                                    height: 30,
                                                    width: 80,
                                                    child: RaisedButton(
                                                      onPressed: () {
                                                        print(
                                                            'checkout button pressed');
                                                        // Navigator.push(context,
                                                        //     new MaterialPageRoute(builder: (context) => CheckOutPage()));
                                                      },
                                                      color: primary,
                                                      padding:
                                                          EdgeInsets.all(1),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          24))),
                                                      child: InkWell(
                                                        onTap: () async {
                                                          pname =
                                                              _card.get('name');
                                                          selleruid = _card
                                                              .get('selleruid');
                                                          productuid =
                                                              _card.get(
                                                                  'productuid');
                                                          size =
                                                              _card.get('size');
                                                          speciality =
                                                              _card.get(
                                                                  'speciality');
                                                          color = _card
                                                              .get('color');
                                                          price = _card
                                                              .get('price');
                                                          checkout(
                                                              _card.get('name'),
                                                              _card.get(
                                                                  'price'));
                                                          await FirebaseFirestore
                                                              .instance
                                                              .runTransaction(
                                                                  (Transaction
                                                                      myTransaction) async {
                                                            await myTransaction
                                                                .delete(snapshot
                                                                    .data
                                                                    .documents[
                                                                        index]
                                                                    .reference);
                                                          });
                                                        },
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
                                                  ),
                                                ),
                                                RaisedButton(
                                                  onPressed: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .runTransaction((Transaction
                                                            myTransaction) async {
                                                      await myTransaction
                                                          .delete(snapshot
                                                              .data
                                                              .documents[index]
                                                              .reference);

                                                      // Also remove from the sellers list
                                                    });
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  24.0))),
                                                  child: Text('Remove'),
                                                  textColor: Colors.white,
                                                  splashColor: Colors.red,
                                                  color: Colors.green,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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

  Future<void> handleclick(String value) async {
    switch (value) {
      case 'Order Placed':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyPlacedOrder()));
        break;
    }
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
          'Thanks for ordering from Humble Market your order has been placed :: 😀 :: ${DateTime.now()}'
      ..text =
          'Thanks for ordering from Humble Market your order has been placed. You Ordered ' +
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

  sellersendMail(String email, String name, String price) async {
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
          'You have received an Order Please Deliver it on time  :: 😀 :: ${DateTime.now()}'
      ..text = 'New Order . Product Ordered ' + name + "At price " + price
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
