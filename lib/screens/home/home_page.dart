import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constant/data_json.dart';
import 'package:shop_app/screens/commentspage/commentscreen2.dart';
import 'package:shop_app/theme/colors.dart';
import 'package:shop_app/homepage_widget/column_social_icon.dart';
import 'package:shop_app/homepage_widget/left_panel.dart';
import 'package:shop_app/homepage_widget/tik_tok_icons.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/screens/home/HomeScreen.dart';
import 'package:flutter/src/widgets/framework.dart';

Stream<QuerySnapshot> stream;
// VideoPlayerController videoController;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController _tabController;
  CollectionReference users = FirebaseFirestore.instance.collection('PRODUCT');
  final FirebaseFirestore db = FirebaseFirestore.instance;
  String activetags = 'Default';
  bool nearmeclicked = false;
  bool nationalclicked = false;
  bool followingclicked = false;

  List<DocumentSnapshot> products = [];
  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 1;
  DocumentSnapshot lastDocument;
  ScrollController _scrollController = ScrollController();
  Query query;

  StreamController<List<DocumentSnapshot>> _controller =
      StreamController<List<DocumentSnapshot>>();

  Stream<List<DocumentSnapshot>> get _streamController => _controller.stream;

  @override
  void initState() {
    super.initState();
    query = getQuery(tag: 'Default');
    _tabController = TabController(length: items.length, vsync: this);
    getProducts(query);
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getProducts(query);
      }
    });
  }

  Query getQuery({String tag = 'Default'}) {
    Query query;
    if (tag == 'National') {
      query = db.collection('PRODUCT').where('country', isEqualTo: 'india');
      print(query.toString());
    } else {
      query = db.collection('PRODUCT');
      print(query.toString());
    }
    return query;
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
      _controller.sink.add(products);

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
    super.dispose();
    _tabController.dispose();
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

    return Stack(children: [
      Column(children: [
        Expanded(
          child: RotatedBox(
            quarterTurns: 1,
            child: StreamBuilder<List<DocumentSnapshot>>(
              stream: _streamController,
              builder: (sContext, snapshot) {
                if (snapshot.hasData && snapshot.data.length > 0) {
                  return ListView.builder(
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
                              snapshot.data[index].data()['productsuid']);
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
        child: Container(
          padding: EdgeInsets.only(top: 20),
          child: Row(
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
                  child: Text('Following',
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
                Container(
                  color: Colors.white70,
                  height: 10,
                  width: 1.0,
                ),
                SizedBox(
                  width: 3,
                ),
                GestureDetector(
                  onTap: () {
                    if (nearmeclicked == false) {
                      nationalclicked = false;
                      nearmeclicked = true;
                      followingclicked = false;
                    }
                  },
                  child: Text('NearMe',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.normal,
                          color:
                              nearmeclicked ? Colors.white : Colors.white54)),
                ),
                SizedBox(
                  width: 3,
                ),
                Container(
                  color: Colors.white70,
                  height: 10,
                  width: 1.0,
                ),
                SizedBox(
                  width: 3,
                ),
                GestureDetector(
                  onTap: () {
                    if (nationalclicked == false) {
                      setState(() {
                        print('National clicked');
                        query = getQuery(tag: 'National');
                        products.clear();
                        _controller.sink.add(products);
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
                  child: Text('National',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color:
                              nationalclicked ? Colors.white : Colors.white54)),
                )
              ]),
        ),
      ),
    ]);
    // return StreamBuilder<QuerySnapshot>(
    //     stream: stream,
    //     builder: (BuildContext context, stream) {
    //       if (stream.connectionState == ConnectionState.waiting) {
    //         return Center(child: CircularProgressIndicator());
    //       }

    //       if (stream.hasError) {
    //         return Center(child: Text(stream.error.toString()));
    //       }
    //       QuerySnapshot querySnapshot = stream.data;

    //       return RotatedBox(
    //         quarterTurns: 1,
    //         child: TabBarView(
    //           controller:
    //               TabController(length: querySnapshot.size, vsync: this),
    //           children: List.generate(querySnapshot.size, (index) {
    //             return VideoPlayerItem(
    //               videoUrl: querySnapshot.docs[index].data()['videoUrl'],
    //               size: size,
    //               name: querySnapshot.docs[index].data()['name'],
    //               price: querySnapshot.docs[index].data()['price'],
    //               caption: querySnapshot.docs[index].data()['description'],
    //               offer: querySnapshot.docs[index].data()['offer'],
    //               profileImg: querySnapshot.docs[index].data()['profileImg'],
    //               likes: querySnapshot.docs[index].data()['likes'],
    //               comments: querySnapshot.docs[index].data()['comments'],
    //               shares: querySnapshot.docs[index].data()['shares'],
    //               shopnow: querySnapshot.docs[index].data()['shopnow'],
    //             );
    //           }),
    //         ),
    //       );
    //     });
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
      this.productsuid})
      : super(key: key);

  final Size size;

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  bool isShowPlaying = true;
  VideoPlayerController videoController;

  @override
  void initState() {
    super.initState();

    videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize()
      ..setLooping(true)
      ..play().then((value) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();

    videoController.dispose();
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
        });
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
                        const EdgeInsets.only(left: 15, top: 20, bottom: 10),
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
                                caption: "${widget.caption}",
                                offer: "${widget.offer}",
                              ),
                              RightPanel(
                                  size: widget.size,
                                  likes: "${widget.likes}",
                                  comments: "${widget.comments}",
                                  shares: "${widget.shares}",
                                  profileImg: "${widget.profileImg}",
                                  shopnow: "${widget.shopnow}",
                                  productuid: "${widget.productsuid}")
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
    );
  }
}

class RightPanel extends StatelessWidget {
  final String likes;
  final String comments;
  final String shares;
  final String profileImg;
  final String albumImg;
  final String shopnow;
  final String productuid;
  const RightPanel(
      {Key key,
      @required this.size,
      this.likes,
      this.comments,
      this.shares,
      this.profileImg,
      this.albumImg,
      this.shopnow,
      this.productuid})
      : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
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
                getIcons(TikTokIcons.heart, likes, 35.0),
                GestureDetector(
                  child: getIcons(TikTokIcons.chat_bubble, comments, 35.0),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => Commentscreen(
                                  productid: productuid,
                                )));
                  },
                ),
                getIcons(TikTokIcons.reply, shares, 25.0),
                getshopnow(shopnow, context)
              ],
            ))
          ],
        ),
      ),
    );
  }
}
