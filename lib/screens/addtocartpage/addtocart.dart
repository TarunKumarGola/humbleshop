import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:shop_app/screens/cartpage/cartpage.dart';
import 'package:shop_app/theme/colors.dart';
import 'package:video_player/video_player.dart';

class AddToCart extends StatelessWidget {
  final Product product;

  const AddToCart({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(product: product),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Product product;

  const MyHomePage({Key key, this.product}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int photoIndex = 0;
  String dropdownValue = 'six';

  int colorselect = 0;

  int getColorHexFromStr(String colorStr) {
    colorStr = "FF" + colorStr;
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("An error occurred when converting a color");
      }
    }
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MyProductVideo(
                product: widget.product,
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  widget.product.name,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 25.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Specifications',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: (MediaQuery.of(context).size.width / 4 +
                                MediaQuery.of(context).size.width / 2) -
                            50.0,
                        child: Text(
                          widget.product.speciality,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15.0,
                            color: Colors.grey.withOpacity(1),
                          ),
                        ),
                      ),
                      Container(
                        height: 35,
                        width: 80,
                        child: Material(
                          elevation: 5,
                          child: Center(
                            child: Text(
                              '₹${widget.product.price}',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 15.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  )),
              Divider(
                color: Colors.black,
              ),
              SizedBox(height: 2.0),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Description',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 22.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 5.0),
              Container(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  widget.product.description,
                  style: TextStyle(
                    //  fontFamily: 'Montserrat',
                    fontSize: 17.0,
                    color: Colors.grey.withOpacity(1),
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              SizedBox(height: 2.0),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Offers',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 22.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 5.0),
              Container(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  widget.product.offer,
                  style: TextStyle(
                    //  fontFamily: 'Montserrat',
                    fontSize: 17.0,
                    color: Colors.grey.withOpacity(1),
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              SizedBox(height: 2.0),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Colors',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 22.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 5.0),
              Container(
                height: 60,
                child: ListView.builder(
                    padding: EdgeInsets.all(5),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: widget.product.colors.length,
                    itemBuilder: (context, index) {
                      return MaterialButton(
                        shape: CircleBorder(
                            side: BorderSide(
                                width: 3,
                                color: Color(getColorHexFromStr(widget
                                    .product.colors[index]
                                    .substring(10, 16))),
                                style: BorderStyle.solid)),
                        padding: EdgeInsets.all(5),
                        elevation: 5,
                        color: Color(getColorHexFromStr(
                            widget.product.colors[index].substring(10, 16))),
                        onPressed: () {
                          setState(() {
                            colorselect = index;
                          });
                        },
                      );
                    }),
              ),
              Divider(
                color: Colors.black,
              ),
              SizedBox(height: 2.0),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Colors Selected',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 22.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              MaterialButton(
                shape: CircleBorder(
                    side: BorderSide(
                        width: 3,
                        color: Color(getColorHexFromStr(widget
                            .product.colors[colorselect]
                            .substring(10, 16))),
                        style: BorderStyle.solid)),
                padding: EdgeInsets.all(5),
                elevation: 5,
                color: Color(getColorHexFromStr(
                    widget.product.colors[colorselect].substring(10, 16))),
                onPressed: () {},
              ),
              SizedBox(height: 5.0),
              Divider(
                color: Colors.black,
              ),
              SizedBox(height: 2.0),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Select Size',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 22.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 2.0),
              Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: <Widget>[
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>['six', 'seven', 'eight', 'nine']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ],
                  ))
            ],
          )
        ],
      ),
      bottomNavigationBar: Material(
          elevation: 7.0,
          color: Colors.white,
          child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 10.0),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        color: Colors.white,
                        child: GestureDetector(
                          child: Icon(
                            Icons.shopping_cart,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            print('Cart button pressed');
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => CartPage()));
                          },
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        color: Colors.white,
                        child: Icon(
                          Icons.account_box,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Container(
                        color: primary,
                        width: MediaQuery.of(context).size.width - 130.0,
                        child: GestureDetector(
                          child: Center(
                              child: Text(
                            'Add to Cart',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                          onTap: () {
                            FirebaseFirestore.instance
                                .collection("USERS")
                                .doc(authobj.currentUser.uid)
                                .collection("orders")
                                .doc()
                                .set({
                              "name": widget.product.name,
                              "productuid": widget.product.productuid,
                              "color": widget.product.colors[colorselect]
                                  .substring(10, 16),
                              "selleruid": widget.product.selleruid,
                              "size": dropdownValue,
                              "speciality": widget.product.speciality,
                              "price": widget.product.price,
                            }).whenComplete(() => {
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) => CartPage()))
                                    });
                          },
                        ))
                  ]))),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class MyProductVideo extends StatefulWidget {
  final Product product;

  const MyProductVideo({Key key, this.product}) : super(key: key);

  @override
  _MyProductVideoState createState() => _MyProductVideoState();
}

class _MyProductVideoState extends State<MyProductVideo> {
  VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.network(widget.product.videourl)
          ..initialize().then((value) => {});
    videoPlayerController.setLooping(true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 275,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Scaffold(
          body: Center(
            child: videoPlayerController.value.initialized
                ? AspectRatio(
                    aspectRatio: videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(videoPlayerController),
                  )
                : Container(),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: kPrimaryColor,
            onPressed: () {
              setState(() {
                videoPlayerController.value.isPlaying
                    ? videoPlayerController.pause()
                    : videoPlayerController.play();
              });
            },
            child: Icon(
              videoPlayerController.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }
}
