import 'package:flutter/material.dart';
import 'package:shop_app/brands/Kidsfashion.dart';
import 'package:shop_app/brands/appliances.dart';
import 'package:shop_app/brands/beautyproducts.dart';
import 'package:shop_app/brands/books.dart';
import 'package:shop_app/brands/doctors.dart';
import 'package:shop_app/brands/electronics.dart';
import 'package:shop_app/brands/footwear.dart';
import 'package:shop_app/brands/kitchen.dart';
import 'package:shop_app/brands/laptops.dart';
import 'package:shop_app/brands/menclothing.dart';
import 'package:shop_app/brands/smartphone.dart';
import 'package:shop_app/brands/toys.dart';
import 'package:shop_app/brands/womenclothing.dart';

class CategoryCarousel extends StatelessWidget {
  final String title;

  CategoryCarousel({
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
        Container(
            height: 180.0,
            child: ListView(
              // This next line does the trick.
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                myItems("assets/images/smartphonecategory.png", 'SmartPhones',
                    0xffed622b, context),
                myItems("assets/images/laptopcategory.png", 'Laptops',
                    0xff26cb3c, context),
                myItems(
                    "assets/images/ec.png", 'Electronics', 0xff3399fe, context),
                myItems("assets/images/mc.png", 'Men Clothing', 0xffff3266,
                    context),
                myItems("assets/images/wc.png", 'Women Clothing', 0xfff4c83f,
                    context),
                myItems(
                    "assets/images/fc.png", 'FootWear', 0xff622F74, context),
                myItems("assets/images/kc.png", 'Home & Kitchens', 0xff7297ff,
                    context),
                myItems("assets/images/tc.png", 'Toys', 0xff7297ff, context),
                myItems("assets/images/bc.png", 'Beauty Product', 0xff7297ff,
                    context),
                myItems("assets/images/kfc.png", 'Kids Fashion', 0xff7297ff,
                    context),
                myItems(
                    "assets/images/ac.png", 'Appliances', 0xff7297ff, context),
                myItems("assets/images/bbc.png", 'Books', 0xff7297ff, context),
                myItems("assets/images/ddc.png", 'Doctor', 0xff7297ff, context),
              ],
            )),
      ],
    );
  }

  Material myItems(
      String path, String heading, int color, BuildContext context) {
    return Material(
      child: InkWell(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Text
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        heading,
                        style: TextStyle(
                          color: new Color(color),
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    //Icon
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 1,
                              color: Colors.blueAccent,
                              spreadRadius: 1)
                        ],
                      ),
                      child: CircleAvatar(
                        // color: new Color(color),
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage(path),
                        radius: 45,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          if (heading == 'SmartPhones') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SmartPhoneBrand()));
          } else if (heading == 'Laptops') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LaptopsBrands()));
          } else if (heading == 'Electronics') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ElectronicsBrands()));
          } else if (heading == 'Men Clothing') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MenClothingBrands()));
          } else if (heading == 'FootWear') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FootWearBrands()));
          } else if (heading == 'Home & Kitchens') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => KitchenBrands()));
          } else if (heading == 'Toys') {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ToysBrands()));
          } else if (heading == 'Beauty Product') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BeautyProductBrands()));
          } else if (heading == 'Kids Fashion') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => KidsFashsionBrands()));
          } else if (heading == 'Appliances') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Appliancesbrands()));
          } else if (heading == 'Books') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BooksBrands()));
          } else if (heading == 'Doctor') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DoctorsBrands()));
          } else if (heading == 'Women Clothing') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => WomenClothingBrands()));
          }
        },
      ),
    );
  }
}
