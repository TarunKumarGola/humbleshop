import 'package:flutter/material.dart';
import 'package:shop_app/screens/cartpage/cartpage.dart';
import 'package:shop_app/theme/colors.dart';

class AddToCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int photoIndex = 0;
  String dropdownValue = 'six';
  List<String> photos = [
    'assets/images/otto.jpg',
    'assets/images/otto2.jpg',
    'assets/images/otto.jpg',
    'assets/images/otto2.jpg'
  ];

  void _previousImage() {
    setState(() {
      photoIndex = photoIndex > 0 ? photoIndex - 1 : 0;
    });
  }

  void _nextImage() {
    setState(() {
      photoIndex = photoIndex < photos.length - 1 ? photoIndex + 1 : photoIndex;
    });
  }

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
              Stack(
                children: <Widget>[
                  Container(
                    height: 275.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(photos[photoIndex]),
                            fit: BoxFit.cover)),
                  ),
                  GestureDetector(
                    child: Container(
                      height: 275.0,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                    ),
                    onTap: _nextImage,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 275.0,
                      width: MediaQuery.of(context).size.width / 2,
                      color: Colors.transparent,
                    ),
                    onTap: _previousImage,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.arrow_back),
                            color: Colors.black,
                            onPressed: () {}),
                        Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                                height: 40.0,
                                width: 40.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )))
                      ],
                    ),
                  ),
                  Positioned(
                      top: 240.0,
                      left: MediaQuery.of(context).size.width / 2 - 30.0,
                      child: Row(
                        children: <Widget>[
                          SelectedPhoto(
                            numberOfDots: photos.length,
                            photoIndex: photoIndex,
                          )
                        ],
                      ))
                ],
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Article code: 2323X',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15.0,
                      color: Colors.grey),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Mountain View',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 25.0,
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
                            10.0,
                        child: Text(
                          'Mountain View Hotel scene',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12.0,
                            color: Colors.grey.withOpacity(0.8),
                          ),
                        ),
                      ),
                      Text(
                        'Rs.248',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'COLOR',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 22.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Color(getColorHexFromStr('#5A5551'))),
                      ),
                      SizedBox(width: 15.0),
                      Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Color(getColorHexFromStr('#C3BCB5'))),
                      ),
                      SizedBox(width: 15.0),
                      Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Color(getColorHexFromStr('#EFEFEF'))),
                      )
                    ],
                  )),
              SizedBox(height: 20.0),
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
              SizedBox(height: 20.0),
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
                            print('Add to cart pressed');
                          },
                        ))
                  ]))),
    );
  }
}

class SelectedPhoto extends StatelessWidget {
  final int numberOfDots;
  final int photoIndex;

  SelectedPhoto({this.numberOfDots, this.photoIndex});

  Widget _inactivePhoto() {
    return new Container(
      child: Padding(
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Container(
            width: 8.0,
            height: 8.0,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(4.0))),
      ),
    );
  }

  Widget _activePhoto() {
    return new Container(
      child: Padding(
        padding: EdgeInsets.only(left: 3.0, right: 3.0),
        child: Container(
            width: 10.0,
            height: 10.0,
            decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, spreadRadius: 0.0, blurRadius: 2.0)
                ])),
      ),
    );
  }

  List<Widget> _buildDots() {
    List<Widget> dots = [];

    for (int i = 0; i < numberOfDots; ++i) {
      dots.add(i == photoIndex ? _activePhoto() : _inactivePhoto());
    }

    return dots;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildDots(),
    ));
  }
}
