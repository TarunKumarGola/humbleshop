import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shop_app/constant/data_json.dart';
import 'package:shop_app/models/Product.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:shop_app/screens/commentspage/commentscreen2.dart';
import 'package:shop_app/theme/colors.dart';
import 'package:shop_app/homepage_widget/column_social_icon.dart';
import 'package:shop_app/homepage_widget/left_panel.dart';
import 'package:shop_app/homepage_widget/tik_tok_icons.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:visibility_detector/visibility_detector.dart';

Stream<QuerySnapshot> stream;
// VideoPlayerController videoController;
List<DocumentSnapshot> products = [];
bool isLoading = false;
bool hasMore = true;
Query query;
GlobalKey _globalKey = GlobalKey();
DocumentSnapshot lastDocument;
StreamController<List<DocumentSnapshot>> controller =
    StreamController<List<DocumentSnapshot>>();

class HomePage extends StatefulWidget {
  String tag;
  HomePage(this.tag);
  @override
  _HomePageState createState() => _HomePageState(tag);
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  _HomePageState(this.tag);
  TabController _tabController;
  CollectionReference users = FirebaseFirestore.instance.collection('PRODUCT');
  final FirebaseFirestore db = FirebaseFirestore.instance;
  String tag;
  String activetags = 'Default';
  bool nearmeclicked = false;
  bool nationalclicked = false;
  bool followingclicked = false;
  bool _folded = true;
  Geolocator geolocator;
  Geoflutterfire geo = Geoflutterfire();
  // List<DocumentSnapshot> products = [];
  // bool isLoading = false;
  // bool hasMore = true;
  int documentLimit = 1000;
  // DocumentSnapshot lastDocument;
  final PageController _scrollController = PageController();
  //ScrollController _scrollController = ScrollController();

  Stream<List<DocumentSnapshot>> get _streamController => controller.stream;

  @override
  void initState() {
    super.initState();
    query = getQuery(tag: tag) as Query;
    _tabController = TabController(length: items.length, vsync: this);
    getProducts(query);
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        if (nearmeclicked == false) getProducts(query);
      }
    });
    global = context;
  }

  Query getQuery({String tag = 'Default'}) {
    Query query;
    if (tag == 'National') {
      query = db.collection('PRODUCT').where('country', isEqualTo: 'India');
      print(query.toString());
    } else if (tag == 'NearMe') {
      nearmefunction();
    } else {
      query = db.collection('PRODUCT');
      print(query.toString());
    }
    return query;
  }

  getnames(String category) async {
    if (!hasMore) {
      print('debug No More Products');
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot;

    await FirebaseFirestore.instance
        .collection('PRODUCT')
        .where('name', isGreaterThanOrEqualTo: category)
        .orderBy("name", descending: false)
        .limit(2)
        .get()
        .then((value) {
      query = FirebaseFirestore.instance
          .collection('PRODUCT')
          .where('name', isEqualTo: category.toUpperCase());
      if (value.size == 0) {
        hasMore = false;
        print("debug $hasMore");
      } else {
        print("debug fetched documents ${value.toString()}");
        querySnapshot = value;
      }
    }).catchError((e) {
      print(e);
      hasMore = false;
    });

    if (querySnapshot != null) {
      if (querySnapshot.docs.length < 2) {
        hasMore = false;
      }

      lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];

      products.addAll(querySnapshot.docs);
      print("debug products length ${products.length}");
      controller.sink.add(products);

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  nearmefunction() async {
    geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      GeoFirePoint center =
          geo.point(latitude: position.latitude, longitude: position.longitude);
      print("debug lat ${position.latitude} lon ${position.longitude}");
      Stream<List<DocumentSnapshot>> stream = geo
          .collection(collectionRef: db.collection('PRODUCT').limit(10))
          .within(
              center: center, radius: 20, field: 'position', strictMode: true);
      stream.forEach((element) {
        print("debug ${element.isEmpty}");
        products.addAll(element);
        controller.sink.add(products);
      });
    }).catchError((e) {
      print("debug something went wrong while getting position of user $e");
    });
  }

  getProducts(Query query) async {
    if (!hasMore) {
      print('debug No More Products');
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      await query.limit(documentLimit).get().then((value) {
        if (value.size == 0) {
          hasMore = false;
          print("debug $hasMore");
        } else {
          print("debug fetched documents ${value.toString()}");
          querySnapshot = value;
        }
      }).catchError((e) {
        print(e);
        hasMore = false;
      });
    } else {
      await query
          .startAfterDocument(lastDocument)
          .limit(documentLimit)
          .get()
          .then((value) {
        if (value.size == 0) {
          hasMore = false;
          print("debug $hasMore");
        } else {
          print("debug fetched documents ${value.toString()}");
          querySnapshot = value;
        }
      }).catchError((e) {
        print("debug error $e");
      });
      //     .catchError((e) {
      //   print("e");
      //   hasMore = false;
      // });
      print(1);
    }
    if (querySnapshot != null) {
      if (querySnapshot.docs.length < documentLimit) {
        hasMore = false;
      }

      lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];

      products.addAll(querySnapshot.docs);
      print("debug products length ${products.length}");
      controller.sink.add(products);

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;

    List<String> following;
    // performing queries

    // if (type == null) {
    //   stream = users.snapshots();
    // } else if (type == 'following') {
    //   following = getFollowing() as List<String>;
    //   stream = users
    //       .where((d) => following == null || following.contains(d.id))
    //       .snapshots();
    // } else if (type == 'category') {
    //   stream = users.where(type, isEqualTo: typename).snapshots();
    // } else
    //   stream = null;

    return RepaintBoundary(
      key: _globalKey,
      child: Stack(children: [
        Column(children: [
          Expanded(
            child: RotatedBox(
              quarterTurns: 1,
              child: StreamBuilder<List<DocumentSnapshot>>(
                stream: _streamController,
                builder: (sContext, snapshot) {
                  if (snapshot.hasData && snapshot.data.length > 0) {
                    return PageView.builder(
                      allowImplicitScrolling: true,
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return VideoPlayerItem(
                          videoUrl: snapshot.data[index].data()['videoUrl'],
                          size: size,
                          name: snapshot.data[index].data()['name'],
                          price: snapshot.data[index].data()['price'],
                          caption: snapshot.data[index].data()['description'],
                          offer: snapshot.data[index].data()['offer'],
                          profileImg: snapshot.data[index].data()['profileImg'],
                          likes: snapshot.data[index].data()['likes'],
                          comments: snapshot.data[index].data()['comments'],
                          shares: snapshot.data[index].data()['shares'],
                          shopnow: snapshot.data[index].data()['shopnow'],
                          productsuid:
                              snapshot.data[index].data()['productsuid'],
                          colors: snapshot.data[index].data()['colors'],
                          selleruid: snapshot.data[index].data()['selleruid'],
                          description:
                              snapshot.data[index].data()['description'],
                          speciality: snapshot.data[index].data()['speciality'],
                          phonenumber:
                              snapshot.data[index].data()['phonenumber'],
                          imageurl1: snapshot.data[index].data()['imageurl1'],
                          imageurl2: snapshot.data[index].data()['imageurl2'],
                          imageurl3: snapshot.data[index].data()['imageurl3'],
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text('No Data...'),
                    );
                  }
                },
              ),
            ),
          ),
          isLoading
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(5),
                  color: Colors.yellowAccent,
                  child: Text(
                    'Loading',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Container()
        ]),
        SafeArea(
          child: Column(children: <Widget>[
            AnimatedContainer(
              duration: Duration(milliseconds: 400),
              width: _folded ? 56 : 400,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Colors.transparent,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 16),
                      child: !_folded
                          ? TextField(
                              decoration: InputDecoration(
                                  hintText: 'Search',
                                  hintStyle: TextStyle(color: Colors.blue[300]),
                                  border: InputBorder.none),
                              style: TextStyle(color: Colors.blue[300]),
                              onSubmitted: (value) {
                                print("Yep we are here" + value);
                                products.clear();
                                controller.sink.add(products);
                                print(
                                    "debug products length ${products.length}");
                                lastDocument = null;
                                hasMore = true;
                                getnames(value);
                              },
                            )
                          : null,
                    ),
                  ),
                  Container(
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(_folded ? 32 : 0),
                          topRight: Radius.circular(32),
                          bottomLeft: Radius.circular(_folded ? 32 : 0),
                          bottomRight: Radius.circular(32),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            _folded ? Icons.search : Icons.close,
                            color: Colors.blue[900],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _folded = !_folded;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      if (followingclicked == false) {
                        nationalclicked = false;
                        nearmeclicked = false;
                        followingclicked = true;
                      }
                    },
                    child: Text('Following  ',
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.normal,
                            color: followingclicked
                                ? Colors.white
                                : Colors.white54)),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (nearmeclicked == false) {
                        setState(() {
                          print('NearMe clicked');

                          getQuery(tag: 'NearMe') as Query;
                          products.clear();
                          controller.sink.add(products);
                          print("debug products length ${products.length}");
                          lastDocument = null;
                          hasMore = true;

                          nationalclicked = false;
                          nearmeclicked = true;
                          followingclicked = false;
                        });
                      }
                    },
                    child: Text('NearMe  ',
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.normal,
                            color:
                                nearmeclicked ? Colors.white : Colors.white54)),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  /*
                  GestureDetector(
                    onTap: () {
                      if (nationalclicked == false) {
                        setState(() {
                          print('National clicked');
                          query = getQuery(tag: 'National') as Query;
                          products.clear();
                          controller.sink.add(products);
                          print("debug products length ${products.length}");
                          lastDocument = null;
                          hasMore = true;
                          getProducts(query);
                          nationalclicked = true;
                          nearmeclicked = false;
                          followingclicked = false;
                        });
                      }
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          border: Border.all(color: white),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/icons8_india_48px.png"),
                              fit: BoxFit.cover)),
                    ),
                  ),*/
                ]),
          ]),
        ),
      ]),
    );
  }

  Widget animatedSearchbar() {
    bool _folded = true;
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      width: _folded ? 56 : 200,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.white,
        boxShadow: kElevationToShadow[6],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 16),
              child: !_folded
                  ? TextField(
                      decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.blue[300]),
                          border: InputBorder.none),
                    )
                  : null,
            ),
          ),
          Container(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_folded ? 32 : 0),
                  topRight: Radius.circular(32),
                  bottomLeft: Radius.circular(_folded ? 32 : 0),
                  bottomRight: Radius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    _folded ? Icons.search : Icons.close,
                    color: Colors.blue[900],
                  ),
                ),
                onTap: () {
                  setState(() {
                    _folded = !_folded;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<List<String>> getFollowing() async {
    DocumentSnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('USERS')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();

    if (querySnapshot.exists &&
        querySnapshot.data().containsKey('following') &&
        querySnapshot.data()['following'] is List) {
      // Create a new List<String> from List<dynamic>
      return List<String>.from(querySnapshot.data()['following']);
    }

    return [];
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String name;
  final String price;
  final String caption;
  final String offer;
  final String profileImg;
  final String likes;
  final String comments;
  final String shares;
  final String shopnow;
  final String productsuid;
  final String description;
  final String speciality;
  final List<dynamic> colors;
  final String selleruid;
  final String phonenumber;
  final String imageurl1;
  final String imageurl2;
  final String imageurl3;

  VideoPlayerItem(
      {Key key,
      @required this.size,
      this.name,
      this.price,
      this.caption,
      this.offer,
      this.profileImg,
      this.likes,
      this.comments,
      this.shares,
      this.shopnow,
      this.videoUrl,
      this.productsuid,
      this.description,
      this.speciality,
      this.colors,
      this.selleruid,
      this.phonenumber,
      this.imageurl1,
      this.imageurl2,
      this.imageurl3})
      : super(key: key);

  final Size size;

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem>
    with WidgetsBindingObserver {
  bool isShowPlaying = false;
  VideoPlayerController videoController;

  @override
  Future<void> initState() {
    super.initState();

    videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize()
      ..setLooping(true).then((value) {
        setState(() {});
      });
    getLiked();
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        videoController.pause();
        print('paused state');
        isPlaying();
        break;
      case AppLifecycleState.resumed:
        print('resumed state');
        videoController.pause();
        isPlaying();
        break;
      case AppLifecycleState.inactive:
        print('inactive state');
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  Widget isPlaying() {
    return videoController.value.isPlaying && !isShowPlaying
        ? Container()
        : Icon(
            Icons.play_arrow,
            size: 80,
            color: white.withOpacity(0.5),
          );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          videoController.value.isPlaying
              ? videoController.pause()
              : videoController.play();
          isPlaying();
        });
      },
      child: VisibilityDetector(
        key: Key("unique key"),
        onVisibilityChanged: (VisibilityInfo info) {
          if (info.visibleFraction == 0.0) {
            videoController.pause();
            isPlaying();
          } else {
            videoController.play();
            isPlaying();
          }
        },
        child: RotatedBox(
          quarterTurns: -1,
          child: Container(
              height: widget.size.height,
              width: widget.size.width,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: widget.size.height,
                    width: widget.size.width,
                    decoration: BoxDecoration(color: black),
                    child: Stack(
                      children: <Widget>[
                        VideoPlayer(videoController),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(),
                            child: isPlaying(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: widget.size.height,
                    width: widget.size.width,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 15, top: 20, bottom: 70),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                child: Row(
                              children: <Widget>[
                                LeftPanel(
                                  size: widget.size,
                                  name: "${widget.name}",
                                  price: "RS.${widget.price}",
                                  caption: "${widget.speciality}",
                                  offer: "${widget.offer}",
                                ),
                                RightPanel(
                                  size: widget.size,
                                  likes: "${widget.likes}",
                                  comments: "${widget.comments}",
                                  shares: "${widget.shares}",
                                  profileImg: "${widget.profileImg}",
                                  shopnow: "${widget.shopnow}",
                                  productuid: "${widget.productsuid}",
                                  speciality: "${widget.speciality}",
                                  offer: "${widget.offer}",
                                  description: "${widget.description}",
                                  colors: widget.colors,
                                  name: "${widget.name}",
                                  videourl: widget.videoUrl,
                                  price: widget.price,
                                  phonenumber: widget.phonenumber,
                                  selleruid: widget.selleruid,
                                  imageurl1: widget.imageurl1,
                                  imageurl2: widget.imageurl2,
                                  imageurl3: widget.imageurl3,
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}

class RightPanel extends StatefulWidget {
  final String likes;
  final String comments;
  final String shares;
  final String profileImg;
  final String albumImg;
  final String shopnow;
  final String productuid;
  final String description;
  final String offer;
  final String speciality;
  final List<dynamic> colors;
  final String name;
  final String videourl;
  final String price;
  final String phonenumber;
  final String selleruid;
  final String imageurl1;
  final String imageurl2;
  final String imageurl3;

  const RightPanel(
      {Key key,
      @required this.size,
      this.likes,
      this.comments,
      this.shares,
      this.profileImg,
      this.albumImg,
      this.shopnow,
      this.productuid,
      this.description,
      this.offer,
      this.speciality,
      this.colors,
      this.name,
      this.videourl,
      this.price,
      this.phonenumber,
      this.selleruid,
      this.imageurl1,
      this.imageurl2,
      this.imageurl3})
      : super(key: key);

  final Size size;
  @override
  _RightPanelState createState() => _RightPanelState(
      size: size,
      likes: likes,
      comments: comments,
      shares: shares,
      profileImg: profileImg,
      albumImg: albumImg,
      shopnow: shopnow,
      productuid: productuid,
      description: description,
      offer: offer,
      speciality: speciality,
      colors: colors,
      name: name,
      videourl: videourl,
      price: price,
      phonenumber: phonenumber,
      selleruid: selleruid,
      imageurl1: imageurl1,
      imageurl2: imageurl2,
      imageurl3: imageurl3);
}

class _RightPanelState extends State<RightPanel> {
  String likes;
  String comments;
  String shares;
  final String profileImg;
  final String albumImg;
  final String shopnow;
  final String productuid;
  String description;
  String offer;
  String speciality;
  List<dynamic> colors;
  String name;
  String videourl;
  String price;
  String phonenumber;
  String selleruid;
  final String imageurl1;
  final String imageurl2;
  final String imageurl3;

  _RightPanelState(
      {Key key,
      @required this.size,
      this.likes,
      this.comments,
      this.shares,
      this.profileImg,
      this.albumImg,
      this.shopnow,
      this.productuid,
      this.offer,
      this.speciality,
      this.description,
      this.colors,
      this.name,
      this.videourl,
      this.price,
      this.phonenumber,
      this.selleruid,
      this.imageurl1,
      this.imageurl2,
      this.imageurl3});

  final Size size;

  @override
  Widget build(BuildContext context) {
    Color color = liked != null
        ? liked.contains(productuid)
            ? Colors.red
            : white
        : white;
    Product product = new Product(
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
    return Expanded(
      child: Container(
        height: size.height,
        child: Column(
          children: <Widget>[
            Container(
              height: size.height * 0.3,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                getProfile(profileImg),
                //    getIcons(TikTokIcons.heart, likes, 35.0, productuid, likes)
                InkWell(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Icon(TikTokIcons.heart, color: color, size: 35.0),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          likes,
                          style: TextStyle(
                              color: white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                  onTap: () => {
                    /* FirebaseFirestore.instance
                        .collection('USERS')
                        .doc(authobj.currentUser.uid)
                        .collection("Liked")
                        .doc(productuid)
                        .get()
                        .then((DocumentSnapshot documentSnapshot) {
                      if (documentSnapshot.exists) {
                        FirebaseFirestore.instance
                            .collection("USERS")
                            .doc(authobj.currentUser.uid)
                            .collection("Liked")
                            .doc(productuid)
                            .delete();

                        int ans = int.parse(likes) - 1;

                        setState(() {
                          likes = ans.toString();
                        });
                        likes = ans.toString();
                        DocumentReference ref = FirebaseFirestore.instance
                            .collection("PRODUCT")
                            .doc(productuid);
                        ref.update({"likes": ans.toString()});
                      } else {
                        FirebaseFirestore.instance
                            .collection("USERS")
                            .doc(authobj.currentUser.uid)
                            .collection("Liked")
                            .doc(productuid)
                            .set({});
                        int ans = int.parse(likes) + 1;
                        setState(() {
                          likes = ans.toString();
                        });
                        likes = ans.toString();
                        DocumentReference ref = FirebaseFirestore.instance
                            .collection("PRODUCT")
                            .doc(productuid);
                        ref.update({"likes": ans.toString()});
                      }
                    })
                    */
                    updatelikes(
                        FirebaseAuth.instance.currentUser.email, productuid),
                    if (liked.contains(productuid))
                      {
                        liked.remove(productuid),
                        setState(() {
                          int ans = int.parse(likes) - 1;
                          likes = ans.toString();
                          color = white;
                          DocumentReference ref = FirebaseFirestore.instance
                              .collection("PRODUCT")
                              .doc(productuid);
                          ref.update({"likes": ans.toString()});
                        }),
                      }
                    else
                      {
                        liked.add(productuid),
                        setState(() {
                          int ans = int.parse(likes) + 1;
                          likes = ans.toString();
                          color = Colors.red;
                          DocumentReference ref = FirebaseFirestore.instance
                              .collection("PRODUCT")
                              .doc(productuid);
                          ref.update({"likes": ans.toString()});
                        }),
                      }
                  },
                ),
                GestureDetector(
                  child: getIconstwo(TikTokIcons.chat_bubble, comments, 35.0),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => Commentscreen(
                                  productid: productuid,
                                )));
                  },
                ),
                getIconsthree(Icons.call, shares, 35.0, phonenumber),
                getshare(
                    Icons.share,
                    "https://play.google.com/store/apps/details?id=com.humble.shop_app",
                    name + "at price" + price.toString(),
                    35.0,
                    context,
                    _globalKey),
                getshopnow(product, context)
              ],
            ))
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
