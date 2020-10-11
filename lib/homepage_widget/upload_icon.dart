import 'package:flutter/material.dart';
import 'package:shop_app/theme/colors.dart';

class UploadIcon extends StatelessWidget {
  const UploadIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 35,
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: 38.0,
      ),
    );
  }
}
