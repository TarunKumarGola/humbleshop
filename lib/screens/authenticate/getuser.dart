import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart'

import 'package:shop_app/models/usermodel.dart';
import 'package:shop_app/services/auth.dart';
import 'package:shop_app/models/sellermodel.dart';

AuthServices authobj;
SellerModel sellerobj;
bool isSeller = false;
Future<void> getuser(String uid) async {
  UserModel obj;
  await FirebaseFirestore.instance
      .collection('USERS')
      .doc(uid)
      .get()
      .then((querySnapshot) {
    print("string ${querySnapshot.data().toString()}");
    Map<String, dynamic> data = querySnapshot.data();

    obj = UserModel(
        uid: uid,
        name: data['name'],
        phonenumber: data['phonenumber'],
        address: data['address'],
        email: data['email'],
        follower: data['follower'],
        following: data['following'],
        imageurl: data['imageurl']);

    // print("userdata is ${obj.name} ${obj.address} ${user.phoneNumber}");
  });

  authobj = AuthServices(currentUser: obj);

  await FirebaseFirestore.instance
      .collection('SELLERS')
      .doc(uid)
      .get()
      .then((docSnapshot) async => {
            if (docSnapshot.exists)
              {
                await FirebaseFirestore.instance
                    .collection("SELLERS")
                    .doc(uid)
                    .get()
                    .then((querySnapshot) {
                  print("string ${querySnapshot.data().toString()}");
                  Map<String, dynamic> data = querySnapshot.data();
                  isSeller = true;
                  sellerobj = SellerModel(
                      aadhar: data['aadhar'],
                      name: data['name'],
                      pan: data['pan'],
                      productsuid: data['productsuid'],
                      shopdescription: data['shopdescription'],
                      shoplocation: data['shoplocation'],
                      shopname: data['shopname']

                      // print("userdata is ${obj.name} ${obj.address} ${user.phoneNumber}");
                      );
                  print("${sellerobj.name}");
                })
              }
          })
      .whenComplete(() => print("successful"));
}
