import 'package:flutter/material.dart';
//import 'package:shopping_cart/utils/CustomTextStyle.dart';
//import 'package:shopping_cart/utils/CustomUtils.dart';
import 'package:shop_app/theme/colors.dart';
//import 'CheckOutPage.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
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
          bottom: PreferredSize(
            child: Text(
              'totol (x) items',
              style: TextStyle(color: Colors.white),
            ),
            preferredSize: null,
          ),
        ),
        body: Builder(
          builder: (context) {
            return ListView(
              children: <Widget>[createCartList(), footer(context)],
            );
          },
        ),
      ),
    );
  }

  footer(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 30),
                child: Text(
                  "Total",
                  style: TextStyle(fontFamily: 'Muli')
                      .copyWith(color: Colors.grey, fontSize: 12),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 30),
                child: Text(
                  "\$299.00",
                  style: TextStyle(fontFamily: 'Muli')
                      .copyWith(fontSize: 14, color: Colors.pink[500]),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          RaisedButton(
            onPressed: () {
              print('checkout button pressed');
              // Navigator.push(context,
              //     new MaterialPageRoute(builder: (context) => CheckOutPage()));
            },
            color: primary,
            padding: EdgeInsets.only(top: 12, left: 60, right: 60, bottom: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))),
            child: Text(
              "Checkout",
              style:
                  TextStyle(fontFamily: 'Muli').copyWith(color: Colors.white),
            ),
          ),
          SizedBox(
            height: 8.0,
          )
        ],
      ),
      margin: EdgeInsets.only(top: 16),
    );
  }

  createHeader() {
    return Container(
      color: primary,
      alignment: Alignment.topLeft,
      child: Text(
        "SHOPPING CART",
        style: TextStyle(fontFamily: 'Muli')
            .copyWith(fontSize: 16, color: Colors.black),
      ),
      margin: EdgeInsets.only(left: 12, top: 12),
    );
  }

  createSubTitle() {
    return Container(
      color: primary,
      alignment: Alignment.topLeft,
      child: Text(
        "Total(3) Items",
        style: TextStyle(fontFamily: 'Muli')
            .copyWith(fontSize: 12, color: Colors.grey),
      ),
      margin: EdgeInsets.only(left: 12, top: 4),
    );
  }

  createCartList() {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, position) {
        return createCartListItem();
      },
      itemCount: 5,
    );
  }

  createCartListItem() {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    color: Colors.blue.shade200,
                    image: DecorationImage(
                        image: AssetImage("images/shoes_1.png"))),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 8, top: 4),
                        child: Text(
                          "NIKE XTM Basketball Shoeas",
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyle(fontFamily: 'Muli')
                              .copyWith(fontSize: 14),
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        "Green M",
                        style: TextStyle(fontFamily: 'Muli')
                            .copyWith(color: Colors.grey, fontSize: 14),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "\$299.00",
                              style: TextStyle(fontFamily: 'Muli')
                                  .copyWith(color: Colors.pinkAccent),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Icon(
                                    Icons.remove,
                                    size: 24,
                                    color: Colors.grey.shade700,
                                  ),
                                  Container(
                                    color: Colors.grey.shade200,
                                    padding: const EdgeInsets.only(
                                        bottom: 2, right: 12, left: 12),
                                    child: Text(
                                      "1",
                                      style: TextStyle(fontFamily: 'Muli'),
                                    ),
                                  ),
                                  Icon(
                                    Icons.add,
                                    size: 24,
                                    color: Colors.grey.shade700,
                                  )
                                ],
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
        Align(
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
        )
      ],
    );
  }
}
