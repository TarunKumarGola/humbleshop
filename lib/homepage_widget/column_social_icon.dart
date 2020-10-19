import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/addtocartpage/addtocart.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:shop_app/theme/colors.dart';

Widget getshopnow(albumImg, context) {
  return Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
        // shape: BoxShape.circle,
        // color: black
        ),
    child: Stack(
      children: <Widget>[
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(shape: BoxShape.circle, color: black),
        ),
        Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage("assets/images/shopping_cart.png"),
                )),
          ),
        ),
        InkWell(
            splashColor: Colors.cyan,
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddToCart()),
              );
            })
      ],
    ),
  );
}

Widget getIconstwo(icon, count, size) {
  return Container(
    child: Column(
      children: <Widget>[
        Icon(icon, color: white, size: size),
        SizedBox(
          height: 5,
        ),
        Text(
          count,
          style: TextStyle(
              color: white, fontSize: 12, fontWeight: FontWeight.w700),
        )
      ],
    ),
  );
}

Widget getProfile(img) {
  return Container(
    width: 50,
    height: 60,
    child: Stack(
      children: <Widget>[
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(color: white),
              shape: BoxShape.circle,
              image:
                  DecorationImage(image: NetworkImage(img), fit: BoxFit.cover)),
        ),
        Positioned(
            bottom: 3,
            left: 18,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(shape: BoxShape.circle, color: primary),
              child: Center(
                  child: Icon(
                Icons.add,
                color: white,
                size: 15,
              )),
            ))
      ],
    ),
  );
}

// Here we will add Shopnow widget which will first if user has already resgistered or not
// if already register nevigate to selling page
// else first register the candidates shop and profile for selling
// registering the candidates profile will ask for name of shop
// addhar card number pan card number email id etc.
// Then nevigate to selling page
// Selling page ask for category then it will ask for
// Selling page will ask for product photo, 15 second video , price , locations of sharing
// phone number check phone number by otp and then finally add the product for selling
