import 'package:flutter/material.dart';
import 'package:shop_app/screens/seller_registration/components/Form.dart';

class SellerRegistration extends StatelessWidget {
  const SellerRegistration({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('New Seller Registration'),
      ),
      body: TextFormFieldDemo(),
    );
  }
}
