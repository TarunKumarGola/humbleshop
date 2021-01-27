import 'dart:developer';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/homepage_widget/profile_list_item.dart';
import 'package:shop_app/homepage_widget/shopsettingoptions.dart';
import 'package:shop_app/screens/OrderPlacedPage/myplacedorder.dart';
import 'package:shop_app/screens/ShopSetting/shopsetting.dart';
import 'package:shop_app/screens/authenticate/authenticate.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:shop_app/screens/cartpage/cartpage.dart';
import 'package:shop_app/screens/complete_profile/components/profilefirst.dart';
import 'package:toast/toast.dart';

class ShopSetting extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: kLightTheme,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeProvider.of(context),
            home: ShopSettingScreen(),
          );
        },
      ),
    );
  }
}

class ShopSettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);

    var themeSwitcher = ThemeSwitcher(
      builder: (context) {
        return AnimatedCrossFade(
          duration: Duration(milliseconds: 200),
          crossFadeState:
              ThemeProvider.of(context).brightness == Brightness.dark
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
          firstChild: GestureDetector(
            onTap: () =>
                ThemeSwitcher.of(context).changeTheme(theme: kLightTheme),
            child: Icon(
              LineAwesomeIcons.sun,
              size: ScreenUtil().setSp(kSpacingUnit.w * 3),
            ),
          ),
          secondChild: GestureDetector(
            onTap: () =>
                ThemeSwitcher.of(context).changeTheme(theme: kDarkTheme),
            child: Icon(
              LineAwesomeIcons.moon,
              size: ScreenUtil().setSp(kSpacingUnit.w * 3),
            ),
          ),
        );
      },
    );

    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: kSpacingUnit.w * 3),
        themeSwitcher,
        SizedBox(width: kSpacingUnit.w * 3),
      ],
    );

    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Column(
              children: <Widget>[
                SizedBox(height: kSpacingUnit.w * 5),
                header,
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      InkWell(
                        child: ShopSettingListItem(
                          icon: ImageIcon(
                            AssetImage("assets/images/shopaddress.png"),
                            size: 35,
                          ),
                          text: 'Shop Address',
                        ),
                        onTap: () {},
                      ),
                      InkWell(
                        child: ShopSettingListItem(
                          icon: ImageIcon(
                            AssetImage("assets/images/shoplocation.png"),
                            size: 35,
                          ),
                          text: 'Shop Location',
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => CartPage()));
                        },
                      ),
                      InkWell(
                        child: ShopSettingListItem(
                          icon: ImageIcon(
                            AssetImage("assets/images/time.png"),
                            size: 35,
                          ),
                          text: 'Shop Timmings',
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => MyPlacedOrder()));
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      InkWell(
                        child: ShopSettingListItem(
                          icon: ImageIcon(
                            AssetImage("assets/images/paymentoption.png"),
                            size: 35,
                          ),
                          text: 'Payment Option',
                        ),
                        onTap: () {},
                      ),
                      ShopSettingListItem(
                        icon: ImageIcon(
                          AssetImage("assets/images/discount.png"),
                          size: 35,
                        ),
                        text: 'Discount Coupons',
                      ),
                      InkWell(
                        child: ShopSettingListItem(
                          icon: ImageIcon(
                            AssetImage("assets/images/taking.png"),
                            size: 35,
                          ),
                          text: 'Taking Orders Now',
                        ),
                        onTap: () {},
                      ),
                      InkWell(
                        child: ShopSettingListItem(
                          icon: ImageIcon(
                            AssetImage("assets/images/updown.png"),
                            size: 35,
                          ),
                          text: 'Take Out/Pick Up',
                        ),
                        onTap: () {},
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      InkWell(
                        child: ShopSettingListItem(
                          icon: ImageIcon(
                            AssetImage("assets/images/delivery.png"),
                            size: 35,
                          ),
                          text: 'Delivery Available',
                        ),
                        onTap: () {},
                      ),
                      InkWell(
                        child: ShopSettingListItem(
                          icon: ImageIcon(
                            AssetImage("assets/images/dlocation.png"),
                            size: 35,
                          ),
                          text: 'Delivery Area',
                        ),
                        onTap: () {},
                      ),
                      InkWell(
                        child: ShopSettingListItem(
                          icon: ImageIcon(
                            AssetImage("assets/images/money.png"),
                            size: 35,
                          ),
                          text: 'Delivery Fee',
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
