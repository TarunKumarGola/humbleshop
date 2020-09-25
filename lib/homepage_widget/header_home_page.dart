import 'package:flutter/material.dart';
import 'package:shop_app/theme/colors.dart';

class HeaderHomePage extends StatefulWidget {
  const HeaderHomePage({
    Key key,
  }) : super(key: key);

  @override
  _HeaderHomePageState createState() => _HeaderHomePageState();
}

class _HeaderHomePageState extends State<HeaderHomePage> {
  bool nearMepressed = false;
  bool followingpresseed = true;
  bool followpressed = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          child: Text(
            "Near by",
            style: TextStyle(
              color: (nearMepressed) ? white : white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
          onTap: () {
            print("Nearme pressed");
            setState(() {
              followingpresseed = false;
              nearMepressed = true;
              followpressed = false;
            });
          },
        ),
        SizedBox(
          width: 6,
        ),
        Text(
          "|",
          style: TextStyle(
            color: white.withOpacity(0.3),
            fontSize: 17,
          ),
        ),
        SizedBox(
          width: 6,
        ),
        GestureDetector(
          child: Text(
            "Following",
            style: TextStyle(
              color: (followingpresseed) ? white : white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
          onTap: () {
            print("Following pressed");
            setState(() {
              followingpresseed = true;
              nearMepressed = false;
              followpressed = false;
            });
          },
        ),
        SizedBox(
          width: 6,
        ),
        Text(
          "|",
          style: TextStyle(
            color: white.withOpacity(0.3),
            fontSize: 17,
          ),
        ),
        SizedBox(
          width: 6,
        ),
        GestureDetector(
          child: Text(
            "Follow",
            style: TextStyle(
                color: (followpressed ? white : white.withOpacity(0.7)),
                fontSize: 17,
                fontWeight: FontWeight.w500),
          ),
          onTap: () {
            print("Follow pressed");
            setState(() {
              followingpresseed = false;
              nearMepressed = false;
              followpressed = true;
            });
          },
        ),
        SizedBox(
          width: 6,
        ),
        GestureDetector(
          child: Text(
            "National",
            style: TextStyle(
                color: (followpressed ? white : white.withOpacity(0.7)),
                fontSize: 17,
                fontWeight: FontWeight.w500),
          ),
          onTap: () {
            print("Follow pressed");
            setState(() {
              followingpresseed = false;
              nearMepressed = false;
              followpressed = true;
            });
          },
        )
      ],
    );
  }
}
