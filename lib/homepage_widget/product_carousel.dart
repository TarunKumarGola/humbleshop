import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/addtocartpage/addtocart.dart';
import 'package:shop_app/screens/productscreen/productscreen.dart';

class ProductCarousel extends StatelessWidget {
  final String title;
  ProductCarousel({
    this.title,
  });

  _buildProductCard(
      String name,
      String price,
      String speciality,
      String description,
      String productuid,
      String imageurl1,
      String imageurl2,
      String imageurl3,
      String category,
      String offer,
      String videourl,
      String likes,
      String comments,
      String profileImg,
      String albumImg,
      String shopnow,
      String phonenumber,
      String selleruid,
      List<dynamic> colors,
      String shares,
      BuildContext context) {
    Product p = new Product(
        likes: likes,
        name: name,
        shares: shares,
        comments: comments,
        productuid: productuid,
        profileImg: profileImg,
        colors: colors,
        offer: offer,
        albumImg: albumImg,
        description: description,
        speciality: speciality,
        shopnow: shopnow,
        videourl: videourl,
        price: price,
        phonenumber: phonenumber,
        selleruid: selleruid,
        imageurl1: imageurl1,
        imageurl2: imageurl2,
        imageurl3: imageurl3);
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      width: 150.0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0.0, 2.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Image(
              image: NetworkImage(imageurl1),
              height: 100.0,
              width: 150.0,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            name,
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "₹${price}",
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.0),
                FlatButton(
                  padding: EdgeInsets.all(4.0),
                  onPressed: () {
                    /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddToCart(product: p,));*/
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddToCart(
                                  product: p,
                                )));
                  },
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  child: Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
        Container(
          height: 280.0,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("HomePage")
                  .doc("283IbXEXq1L1ykjk726P")
                  .collection(title)
                  .snapshots(),
              builder: (context, snapshot) {
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot ds = snapshot.data.documents[index];
                    return _buildProductCard(
                        ds.data()['name'],
                        ds.data()['price'],
                        ds.data()['speciality'],
                        ds.data()['description'],
                        ds.data()['productuid'],
                        ds.data()['imageurl1'],
                        ds.data()['imageurl2'],
                        ds.data()['imageurl3'],
                        ds.data()['category'],
                        ds.data()['offer'],
                        ds.data()['videoUrl'],
                        ds.data()['likes'],
                        ds.data()['comments'],
                        ds.data()['profileImg'],
                        ds.data()['albumimg'],
                        ds.data()['shopnow'],
                        ds.data()['phonenumber'],
                        ds.data()['selleruid'],
                        ds.data()['colors'],
                        ds.data()['shares'],
                        context);
                  },
                );
              }),
        ),
      ],
    );
  }
}
