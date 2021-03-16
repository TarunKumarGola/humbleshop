import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/Product.dart';

class ProductPage extends StatefulWidget {
  final Product p;
  ProductPage(this.p);

  @override
  State<StatefulWidget> createState() => _ProductPageState(p);
}

class _ProductPageState extends State<ProductPage> {
  String dropdownValue = 'six';
  final Product p;
  _ProductPageState(this.p);
  List<String> _imagePaths = new List<String>();
  @override
  Widget build(BuildContext context) {
    _imagePaths.add(p.imageurl1);
    _imagePaths.add(p.imageurl2);
    _imagePaths.add(p.imageurl3);
    return MaterialApp(
        home: Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CarouselSlider(
                  options: CarouselOptions(autoPlay: true),
                  items: _imagePaths.map((imagePath) {
                    return Builder(builder: (context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          child: Image.network(imagePath));
                    });
                  }).toList()),
              SizedBox(height: 20.0),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  p.name,
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
                          p.speciality,
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
                              '₹${p.price}',
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
                          color: Colors.pink,
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
                  p.description,
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
                  p.offer,
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
              /*  Container(
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
              ),*/
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
              /*MaterialButton(
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
              ),*/
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
                  )),
              FlatButton(
                  onPressed: () {
                    print("Open Comment Sections");
                  },
                  child: Container(
                    color: Colors.pink,
                    width: MediaQuery.of(context).size.width,
                    height: 35.0,
                    child: Center(
                      child: Text(
                        "Reviews",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
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
                            /* Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => CartPage()));*/
                          },
                        ),
                      ),
                    ),
                    Container(
                        color: Colors.pink,
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
                            /* FirebaseFirestore.instance
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
                                    */
                          },
                        ))
                  ]))),
    ));
  }
}
