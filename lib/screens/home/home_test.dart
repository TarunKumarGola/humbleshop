import 'package:flutter/material.dart';
import 'package:shop_app/constant/data_json.dart';
import 'package:shop_app/theme/colors.dart';
import 'package:shop_app/homepage_widget/header_home_page.dart';
import 'package:shop_app/homepage_widget/column_social_icon.dart';
import 'package:shop_app/homepage_widget/left_panel.dart';
import 'package:shop_app/homepage_widget/tik_tok_icons.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePageTest extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageTest> with TickerProviderStateMixin {
  TabController _tabController;
  CollectionReference users =
      FirebaseFirestore.instance.collection('videoproducts');

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
    return StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
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
                  caption: querySnapshot.docs[index].data()['caption'],
                  songName: querySnapshot.docs[index].data()['songName'],
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
}

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String name;
  final String caption;
  final String songName;
  final String profileImg;
  final String likes;
  final String comments;
  final String shares;
  final String shopnow;
  VideoPlayerItem(
      {Key key,
      @required this.size,
      this.name,
      this.caption,
      this.songName,
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
  VideoPlayerController _videoController;
  bool isShowPlaying = false;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        _videoController.play();
        setState(() {
          isShowPlaying = false;
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  Widget isPlaying() {
    return _videoController.value.isPlaying && !isShowPlaying
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
          _videoController.value.isPlaying
              ? _videoController.pause()
              : _videoController.play();
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
                      VideoPlayer(_videoController),
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
                          HeaderHomePage(),
                          Expanded(
                              child: Row(
                            children: <Widget>[
                              LeftPanel(
                                size: widget.size,
                                name: "${widget.name}",
                                caption: "${widget.caption}",
                                songName: "${widget.songName}",
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
                getIcons(TikTokIcons.chat_bubble, comments, 35.0),
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
