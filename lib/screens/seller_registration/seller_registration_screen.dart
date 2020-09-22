import 'package:flutter/material.dart';
import 'package:shop_app/screens/seller_registration/components/Form.dart';
import 'package:shop_app/theme/colors.dart';

class SellerRegistration extends StatelessWidget {
  const SellerRegistration({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: primary, accentColor: Colors.pink[300]),
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('New Seller Registration'),
          backgroundColor: primary,
        ),
        body: TextFormFieldDemo(),
      ),
    );
  }
}
