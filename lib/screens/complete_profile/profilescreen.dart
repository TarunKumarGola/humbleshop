import 'dart:developer';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/homepage_widget/profile_list_item.dart';
import 'package:shop_app/screens/OrderPlacedPage/myplacedorder.dart';
import 'package:shop_app/screens/ShopSetting/shopsetting.dart';
import 'package:shop_app/screens/authenticate/authenticate.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:shop_app/screens/cartpage/cartpage.dart';
import 'package:shop_app/screens/complete_profile/components/profilefirst.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatelessWidget {
  BuildContext maincontext;
  Profile(BuildContext context) {
    maincontext = context;
  }

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
            home: ProfileScreen(maincontext),
          );
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  BuildContext maincontext;
  ProfileScreen(BuildContext maincontext) {
    this.maincontext = maincontext;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);

    var profileInfo = Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: kSpacingUnit.w * 10,
            width: kSpacingUnit.w * 10,
            margin: EdgeInsets.only(top: kSpacingUnit.w * 3),
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                    radius: kSpacingUnit.w * 5,
                    backgroundImage: authobj.currentUser.imageurl == null
                        ? AssetImage("assets/images/male_user.png")
                        : NetworkImage(authobj.currentUser.imageurl)),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: kSpacingUnit.w * 2.5,
                    width: kSpacingUnit.w * 2.5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      heightFactor: kSpacingUnit.w * 1.5,
                      widthFactor: kSpacingUnit.w * 1.5,
                      child: Icon(
                        LineAwesomeIcons.pen,
                        color: kDarkPrimaryColor,
                        size: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: kSpacingUnit.w * 2),
          Text(
            authobj.currentUser.name,
            style: kTitleTextStyle,
          ),
          SizedBox(height: kSpacingUnit.w * 0.5),
          Text(
            authobj.currentUser.email,
            style: kCaptionTextStyle,
          ),
        ],
      ),
    );

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
        SizedBox(
          width: kSpacingUnit.w * 3,
        ),
        profileInfo,
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
                        child: ProfileListItem(
                          icon: ImageIcon(
                            AssetImage("assets/images/privacy.png"),
                            size: 35,
                          ),
                          text: 'Privacy',
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      ProfilePage(maincontext)));
                        },
                      ),
                      InkWell(
                        child: ProfileListItem(
                          icon: ImageIcon(
                            AssetImage("assets/images/cart.png"),
                            size: 35,
                          ),
                          text: 'Cart',
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => CartPage()));
                        },
                      ),
                      InkWell(
                        child: ProfileListItem(
                          icon: ImageIcon(
                            AssetImage("assets/images/orderhistory.png"),
                            size: 35,
                          ),
                          text: 'Orders',
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => MyPlacedOrder()));
                        },
                      ),
                      /*InkWell(
                        child: ProfileListItem(
                          icon: ImageIcon(
                            AssetImage("assets/images/market.png"),
                            size: 35,
                          ),
                          text: 'My Shop',
                        ),
                        onTap: () {
                          if (isSeller) {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => ShopSetting()));
                          } else
                            Toast.show("Please Register Your Shop", context);
                        },
                      ),*/
                      ProfileListItem(
                        icon: ImageIcon(
                          AssetImage("assets/images/invite.png"),
                          size: 35,
                        ),
                        text: 'Invite a Friend',
                      ),
                      InkWell(
                        child: ProfileListItem(
                          icon: ImageIcon(
                            AssetImage("assets/images/invite.png"),
                            size: 35,
                          ),
                          text: 'HelpLine',
                        ),
                        onTap: () async {
                          Toast.show("You will be directed to Whatsapp support",
                              context);
                          var whatsappUrl =
                              "whatsapp://send?phone=${918076462208}";
                          await canLaunch(whatsappUrl)
                              ? launch(whatsappUrl)
                              : Toast.show(
                                  "There is no whatsapp installed", context);
                        },
                      ),
                      InkWell(
                        child: ProfileListItem(
                          icon: ImageIcon(
                            AssetImage("assets/images/logout.png"),
                            size: 35,
                          ),
                          text: 'Logout',
                          hasNavigation: false,
                        ),
                        onTap: () {
                          FirebaseAuth.instance.signOut().whenComplete(() => {
                                Navigator.pushAndRemoveUntil(
                                    maincontext,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Authenticate()),
                                    (route) => false)
                              });
                        },
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
