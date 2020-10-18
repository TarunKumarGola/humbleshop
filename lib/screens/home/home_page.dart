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

Stream<QuerySnapshot> stream;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController _tabController;
  CollectionReference users = FirebaseFirestore.instance.collection('PRODUCT');

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: items.length, vsync: this);
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

    if (type == null) {
      stream = users.snapshots();
    } else if (type == 'following') {
      following = getFollowing() as List<String>;
      stream = users
          .where((d) => following == null || following.contains(d.id))
          .snapshots();
    } else if (type == 'category') {
      stream = users.where(type, isEqualTo: typename).snapshots();
    } else
      stream = null;

    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (BuildContext context, stream) {
          if (stream.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (stream.hasError) {
            return Center(child: Text(stream.error.toString()));
          }
          QuerySnapshot querySnapshot = stream.data;

          return RotatedBox(
            quarterTurns: 1,
            child: TabBarView(
              controller:
                  TabController(length: querySnapshot.size, vsync: this),
              children: List.generate(querySnapshot.size, (index) {
                return VideoPlayerItem(
                  videoUrl: querySnapshot.docs[index].data()['videoUrl'],
                  size: size,
                  name: querySnapshot.docs[index].data()['name'],
                  price: querySnapshot.docs[index].data()['price'],
                  caption: querySnapshot.docs[index].data()['description'],
                  offer: querySnapshot.docs[index].data()['offer'],
                  profileImg: querySnapshot.docs[index].data()['profileImg'],
                  likes: querySnapshot.docs[index].data()['likes'],
                  comments: querySnapshot.docs[index].data()['comments'],
                  shares: querySnapshot.docs[index].data()['shares'],
                  shopnow: querySnapshot.docs[index].data()['shopnow'],
                );
              }),
            ),
          );
        });
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
      this.videoUrl})
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
  const RightPanel(
      {Key key,
      @required this.size,
      this.likes,
      this.comments,
      this.shares,
      this.profileImg,
      this.albumImg,
      this.shopnow})
      : super(key: key);

  final Size size;
  final String productid = "bWJLO2jCGw7rfIslImEp";

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
                                  productid: productid,
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
