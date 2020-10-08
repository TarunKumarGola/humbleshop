import 'package:flutter/material.dart';
import 'package:shop_app/homepage_widget/upload_icon.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:shop_app/screens/complete_profile/components/profilefirst.dart';
import 'package:shop_app/services/auth.dart';

import 'package:shop_app/theme/colors.dart';
import 'package:shop_app/homepage_widget/tik_tok_icons.dart';

import 'home_page.dart';
import 'package:shop_app/models/Categories.dart';
import 'package:shop_app/screens/home/categorycard.dart';
import 'package:shop_app/screens/seller_registration/seller_registration_screen.dart';

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
        Center(
            child: Container(
          padding: EdgeInsets.all(6.0),
          child: Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  child: GridView.builder(
                    itemCount: category.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) => CategoryCard(
                        category: category[index],
                        press: () => print('${category[index].title})')),
                  ),
                )),
          ),
        )),
        Center(
          child: SellerRegistration(),
        ),
        Center(
          child: Text(
            "All Activity",
            style: TextStyle(
                color: black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: ProfilePage(
            authobj: authobj,
          ),
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
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.redAccent),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(bottomItems.length, (index) {
            return bottomItems[index]['isIcon']
                ? InkWell(
                    onTap: () {
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
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (contexts) => SellerRegistration()));
  }
}
