import 'package:cloud_firestore/cloud_firestore.dart';

class SellerModel {
  // String uid;
  //String email;
  String name;
  String shopname;
  String shopdescription;
  //String shoplocation;
  String aadhar;
  String pan;
  GeoPoint shoplocation;
  List<dynamic> productsuid = [];
  //String phonenumber;
  //String address;
  // int follower;
  // int following;
  // String imageurl;

  SellerModel(
      {this.name,
      this.shopname,
      this.shopdescription,
      this.shoplocation,
      this.aadhar,
      this.pan,
      this.productsuid});
  SellerModel.fromData(Map<String, dynamic> data)
      : name = data['name'],
        shopname = data['shopname'],
        shopdescription = data['shopdescription'],
        shoplocation = data['shoplocation'],
        aadhar = data['aadhar'],
        pan = data['pan'],
        productsuid = data['productsuid'];

  Map<String, dynamic> toJson() {
    return {
      'shopname': shopname,
      'name': name,
      'shopdescription': shopdescription,
      'shoplocation': shoplocation,
      'aadhar': aadhar,
      'pan': pan,
      'productsuid': productsuid,
    };
  }
}
