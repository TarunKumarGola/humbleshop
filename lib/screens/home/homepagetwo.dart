import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/homepage_widget/categorycarousel.dart';
import 'package:shop_app/homepage_widget/product_carousel.dart';
import 'package:shop_app/models/top_bar.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:shop_app/screens/cartpage/cartpage.dart';

class HomeScreenTwo extends StatefulWidget {
  @override
  _HomeScreenTwoState createState() => _HomeScreenTwoState();
}

class _HomeScreenTwoState extends State<HomeScreenTwo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.pink,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Container(
                      width: 200,
                      child: Text(
                        "Humble Market",
                        style: TextStyle(color: Colors.white),
                      ),
                      height: 50,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => CartPage()));
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          CarouselSlider(
              options: CarouselOptions(autoPlay: true),
              items: imagePaths.map((imagePath) {
                return Builder(builder: (context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: Image.network(imagePath));
                });
              }).toList()),
          SizedBox(height: 15.0),
          CategoryCarousel(
            title: "Categories",
          ),
          ProductCarousel(
            title: 'Humble Deals',
          ),
          ProductCarousel(
            title: 'Humble Deals',
          ),
          ProductCarousel(
            title: 'Humble Deals',
          ),
          /*ProductCarousel(
            title: 'Popular Books',
            products: books,
          ),
          */
        ],
      ),
    );
  }
}
