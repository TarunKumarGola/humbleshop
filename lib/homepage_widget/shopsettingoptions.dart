import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:shop_app/constants.dart';

class ShopSettingListItem extends StatelessWidget {
  final ImageIcon icon;
  final String text;
  final bool hasNavigation;

  const ShopSettingListItem({
    Key key,
    this.icon,
    this.text,
    this.hasNavigation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kSpacingUnit.w * 5.5,
      margin: EdgeInsets.symmetric(
        horizontal: 0,
      ).copyWith(
        bottom: 0,
      ),
      decoration:
          BoxDecoration(color: Theme.of(context).backgroundColor, boxShadow: [
        BoxShadow(
          color: Color(0xFFF50057),
          blurRadius: 4,
          offset: Offset(0, 4),
        )
      ]),
      child: Row(
        children: <Widget>[
          icon,
          SizedBox(width: kSpacingUnit.w * 1.5),
          Text(
            this.text,
            style: kTitleTextStyle.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          if (this.hasNavigation)
            Icon(
              LineAwesomeIcons.angle_right,
              size: kSpacingUnit.w * 2.5,
            ),
        ],
      ),
    );
  }
}
