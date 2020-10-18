import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/homepage_widget/upload_icon.dart';
import 'package:shop_app/screens/addproducts/addproduct.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:shop_app/screens/complete_profile/components/profilefirst.dart';
import 'package:shop_app/screens/home/categorycardtwo.dart';
import 'package:shop_app/screens/home/home_page.dart';
import 'package:shop_app/theme/colors.dart';
import 'package:shop_app/homepage_widget/tik_tok_icons.dart';
import 'package:shop_app/screens/seller_registration/seller_registration_screen.dart';

String type;
String typename;

class HomeScreen extends StatefulWidget {
  static String routeName = "\HomeScreen";

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<HomeScreen> {
  int pageIndex = 0;
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
        HomePage(),
        Categorycardtwo(),
        Center(
          child: onplusbuttonpressed(),
        ),
        Center(
          child: Text(
            "All Activity",
            style: TextStyle(
                color: black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: ProfilePage(),
        )
      ],
    );
  }

  Widget getFooter() {
    List bottomItems = [
      {"icon": TikTokIcons.home, "label": "Home", "isIcon": true},
      {"icon": TikTokIcons.search, "label": "Discover", "isIcon": true},
      {"icon": "", "label": "", "isIcon": false},
      {"icon": TikTokIcons.messages, "label": "Inbox", "isIcon": true},
      {"icon": TikTokIcons.profile, "label": "Me", "isIcon": true}
    ];
    return Container(
      height: 60,
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
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(bottomItems.length, (index) {
            return bottomItems[index]['isIcon']
                ? InkWell(
                    onTap: () {
                      type = 'NO';
                      typename = null;
                      if (index == 0) type = null;
                      selectedTab(index);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          bottomItems[index]['icon'],
                          color: white,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text(
                            bottomItems[index]['label'],
                            style: TextStyle(color: white, fontSize: 10),
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
                    child: UploadIcon());
          }),
        ),
      ),
    );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
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
}
