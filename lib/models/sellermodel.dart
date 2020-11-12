import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

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
  GeoFirePoint position;
  String selleruid;
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
      this.productsuid,
      this.position,
      this.selleruid});
  SellerModel.fromData(Map<String, dynamic> data)
      : name = data['name'],
        shopname = data['shopname'],
        shopdescription = data['shopdescription'],
        shoplocation = data['shoplocation'],
        aadhar = data['aadhar'],
        pan = data['pan'],
        productsuid = data['productsuid'],
        position = data['position'],
        selleruid = data['selleruid'];

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
