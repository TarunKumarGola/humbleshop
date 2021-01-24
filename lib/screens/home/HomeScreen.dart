import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/messaging/messagingadmin.dart';
import 'package:shop_app/screens/addproducts/addproduct.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:shop_app/screens/complete_profile/components/profilefirst.dart';
import 'package:shop_app/screens/complete_profile/profilescreen.dart';
import 'package:shop_app/screens/home/home_page.dart';
import 'package:shop_app/theme/colors.dart';
import 'package:shop_app/screens/seller_registration/seller_registration_screen.dart';

String type;
String typename;
int pageIndex = 0;
String category = 'Default';

class HomeScreen extends StatefulWidget {
  static String routeName = "\HomeScreen";

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      bottomNavigationBar: getFooter(),
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: <Widget>[
        HomePage(category),
        Center(
          child: Scaffold(
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
                myItems(
                    "assets/images/smartphone.png", 'SmartPhones', 0xffed622b),
                myItems("assets/images/laptops.png", 'Laptops', 0xff26cb3c),
                myItems(
                    "assets/images/electronics.png", 'Electronics', 0xff3399fe),
                myItems("assets/images/men.png", 'Men Clothing', 0xffff3266),
                myItems(
                    "assets/images/women.png", 'Women Clothing', 0xfff4c83f),
                myItems("assets/images/footwear.png", 'FootWear', 0xff622F74),
                myItems(
                    "assets/images/kitchen.png", 'Home & Kitchens', 0xff7297ff),
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
          ),
        ),
        onplusbuttonpressed(),
        MessagingWidget(),
        Center(
          child: Profile(),
        ),
      ],
    );
  }

  Widget getFooter() {
    List bottomItems = [
      {
        "icon": ImageIcon(
          AssetImage("assets/images/market.png"),
          color: Colors.white,
          size: 35,
        ),
        "label": "Home",
        "isIcon": true
      },
      {
        "icon": ImageIcon(
          AssetImage("assets/images/search.png"),
          color: Colors.white,
          size: 35,
        ),
        "label": "Discover",
        "isIcon": true
      },
      {"icon": "", "label": "", "isIcon": false},
      {
        "icon": ImageIcon(
          AssetImage("assets/images/inbox.png"),
          color: Colors.white,
          size: 35,
        ),
        "label": "Inbox",
        "isIcon": true
      },
      {
        "icon": ImageIcon(
          AssetImage("assets/images/male_user.png"),
          color: Colors.white,
          size: 35,
        ),
        "label": "Me",
        "isIcon": true
      }
    ];
    return Container(
      height: 69,
      width: double.infinity,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(1.0, 1.0), // shadow direction: bottom right
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(bottomItems.length, (index) {
            return bottomItems[index]['isIcon']
                ? InkWell(
                    onTap: () {
                      type = 'NO';
                      typename = null;
                      if (index == 0) {
                        type = null;
                      }
                      selectedTab(index);
                      if (index != 0) {
                        //videoController.pause();
                        print("pausing videoplayer index$index");
                      } else {
                        // videoController.play();
                        print("playing videoplayer index$index");
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        bottomItems[index]['icon'],
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text(
                            bottomItems[index]['label'],
                            style: TextStyle(
                                color: white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  )
                : InkWell(
                    onTap: () {
                      if (index != 0) {
                        type = 'no';
                      }
                      selectedTab(index);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ImageIcon(
                          AssetImage("assets/images/add.png"),
                          color: Colors.white,
                          size: 35,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text(
                            "Add",
                            style: TextStyle(
                                color: white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ));
          }),
        ),
      ),
    );
  }

  selectedTab(index) {
    setState(() {
      print('debug $index');
      pageIndex = index;
      // if (pageIndex != 0)// videoController.pause();
    });
  }

  gotoregisterpage() {
    //videoController.pause();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (contexts) => SellerRegistration()));
  }

  Widget onplusbuttonpressed() {
    //print(sellerobj.name);
    if (!isSeller) {
      return SellerRegistration();
    } else {
      return AddProduct();
    }
  }

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
            category = heading;
            products.clear();
            controller.sink.add(products);
            print("debug products length ${products.length}");
            lastDocument = null;
            hasMore = true;
            getProducts(heading);
          });

          selectedTab(0);
        },
      ),
    );
  }

  getProducts(String category) async {
    if (!hasMore) {
      print('debug No More Products');
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot;

    await FirebaseFirestore.instance
        .collection('PRODUCT')
        .where('category', isEqualTo: category)
        .limit(2)
        .get()
        .then((value) {
      query = FirebaseFirestore.instance
          .collection('PRODUCT')
          .where('category', isEqualTo: category);
      if (value.size == 0) {
        hasMore = false;
        print("debug $hasMore");
      } else {
        print("debug fetched documents ${value.toString()}");
        querySnapshot = value;
      }
    }).catchError((e) {
      print(e);
      hasMore = false;
    });

    if (querySnapshot != null) {
      if (querySnapshot.docs.length < 2) {
        hasMore = false;
      }

      lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];

      products.addAll(querySnapshot.docs);
      print("debug products length ${products.length}");
      controller.sink.add(products);

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
