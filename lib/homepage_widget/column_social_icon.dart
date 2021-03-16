import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:share/share.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/addtocartpage/addtocart.dart';
import 'package:shop_app/theme/colors.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:url_launcher/url_launcher.dart';

Widget getshopnow(Product product, context) {
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
                MaterialPageRoute(
                    builder: (context) => AddToCart(
                          product: product,
                        )),
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
      ],
    ),
  );
}

Widget getIconsthree(icon, count, size, phonenumber) {
  return InkWell(
    onTap: () {
      makecall('tel:$phonenumber');
    },
    child: Container(
      child: Column(
        children: <Widget>[
          Icon(icon, color: white, size: size),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    ),
  );
}

Widget getshare(icon, link, title, size, context, globalKey) {
  return InkWell(
    onTap: () {
      shareScreenshot(context, link, globalKey);
    },
    child: Container(
      child: Column(
        children: <Widget>[
          Icon(icon, color: white, size: size),
          SizedBox(
            height: 5,
          ),
        ],
      ),
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

Future<Null> shareScreenshot(context, link, globalKey) async {
  try {
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();
    if (boundary.debugNeedsPaint) {
      Timer(Duration(seconds: 1),
          () => shareScreenshot(context, link, globalKey));
      return null;
    }
    ui.Image image = await boundary.toImage();
    final directory = (await getExternalStorageDirectory()).path;
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    File imgFile = new File('$directory/screenshot.png');
    imgFile.writeAsBytes(pngBytes);
    final RenderBox box = context.findRenderObject();
    List<String> sharefiles = List();
    sharefiles.add('$directory/screenshot.png');
    Share.shareFiles(sharefiles,
        subject: 'Humble Market',
        text:
            'Hello,Check out the Humble Market App to find latest deal! Please Visit Find Best Deals on the Products  $link',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  } on PlatformException catch (e) {
    print("Exception while taking screenshot:" + e.toString());
  }
}

Future<void> makecall(String phonenumber) async {
  print(phonenumber);
  if (await canLaunch(phonenumber)) {
    print(phonenumber);
    await launch(phonenumber);
  } else {
    print('Tarun$phonenumber');
    throw 'could not call';
  }
}

Future<void> share(dynamic link, String title) async {
  List<String> sharefile = List();
  sharefile.add("assets/icons/facebook-2.svg");
  await Share.shareFiles(sharefile,
      text: "Please Visit Find Best Deals on the Products  $link");
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
