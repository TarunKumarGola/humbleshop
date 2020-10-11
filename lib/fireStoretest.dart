import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
          color: Colors.cyan, child: Text('Check Data'), onPressed: checkdata),
    );
  }

  checkdata() {
    DocumentReference collectionReference = FirebaseFirestore.instance
        .collection('PhoneNumbers')
        .doc("+919910949565");
    collectionReference.get().then((value) =>
        {if (value.exists) print("Yo it exits") else print("Sorry fuck off")});
  }
}
