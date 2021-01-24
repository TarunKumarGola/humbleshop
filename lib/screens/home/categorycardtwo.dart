import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/home/HomeScreen2.dart';

class Categorycardtwo extends StatefulWidget {
  @override
  _CategorycardtwoState createState() => _CategorycardtwoState();
}

class _CategorycardtwoState extends State<Categorycardtwo> {
  Material myItems(String path, String heading, int color) {
    return Material(
      child: InkWell(
        child: Material(
          color: Colors.white,
          elevation: 14.0,
          shadowColor: Color(0x802196F3),
          borderRadius: BorderRadius.circular(24.0),
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
                            fontSize: 13.0,
                          ),
                        ),
                      ),

                      //Icon
                      Material(
                        // color: new Color(color),
                        borderRadius: BorderRadius.circular(24.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: new Image(
                            image: new AssetImage(path),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: () {
          print("debug $heading");

          setState(() {
            print('debug $pageIndex');
            pageIndex = 0;
            print('debug $pageIndex');
            category = heading;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'Category',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: StaggeredGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: <Widget>[
          myItems("assets/images/smartphone.png", 'SmartPhones', 0xffed622b),
          myItems("assets/images/laptops.png", 'Laptops', 0xff26cb3c),
          myItems("assets/images/electronics.png", 'Electronics', 0xff3399fe),
          myItems("assets/images/men.png", 'Men Clothing', 0xffff3266),
          myItems("assets/images/women.png", 'Women Clothing', 0xfff4c83f),
          myItems("assets/images/footwear.png", 'FootWear', 0xff622F74),
          myItems("assets/images/kitchen.png", 'Home & Kitchens', 0xff7297ff),
          myItems("assets/images/toys.png", 'Toys', 0xff7297ff),
        ],
        staggeredTiles: [
          StaggeredTile.extent(1, 200.0),
          StaggeredTile.extent(1, 200.0),
          StaggeredTile.extent(1, 200.0),
          StaggeredTile.extent(1, 200.0),
          StaggeredTile.extent(1, 210.0),
          StaggeredTile.extent(1, 200.0),
          StaggeredTile.extent(2, 200.0),
          StaggeredTile.extent(1, 200.0),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
