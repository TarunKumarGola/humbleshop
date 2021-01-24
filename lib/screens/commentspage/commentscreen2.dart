import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helpers/style.dart';
import 'package:shop_app/screens/authenticate/getuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Commentscreen extends StatefulWidget {
  final String productid;
  Commentscreen({Key key, this.productid}) : super(key: key);

  @override
  _CommentscreenState createState() =>
      _CommentscreenState(productid: productid);
}

class _CommentscreenState extends State<Commentscreen> {
  final String productid;
  _CommentscreenState({this.productid});
  List<Comment> products = []; // stores fetched products

  bool isLoading = false; // track if products fetching

  bool hasMore = true; // flag for more products available or not

  int documentLimit = 10; // documents to be fetched per request
  final TextEditingController _commentController = TextEditingController();

  DocumentSnapshot
      lastDocument; // flag for last document from where next 10 records to be fetched
  CollectionReference ref;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ref = FirebaseFirestore.instance
        .collection("commentstest")
        .doc(productid)
        .collection("comments");
    getProducts();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getProducts();
      }
    });
  }

  getProducts() async {
    if (!hasMore) {
      print('No More Products');
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot;
    List<Comment> current = [];
    if (lastDocument == null) {
      querySnapshot = await ref.orderBy('timestamp').limit(documentLimit).get();
      // .then((QuerySnapshot querySnapshot) => {
      //       querySnapshot.docs.forEach((doc) {
      //         current.add(Comment.fromDocument(doc));
      //       })
      //     });
    } else {
      querySnapshot = await ref
          .orderBy('timestamp')
          .startAfterDocument(lastDocument)
          .limit(documentLimit)
          .get();

      // .then((QuerySnapshot querySnapshot) => {
      //       querySnapshot.docs.forEach((doc) {
      //         current.add(Comment.fromDocument(doc));
      //       })
      //     });
      //await ref.startAfterDocument(lastDocument).limit(documentLimit).get();
      print(1);
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }
    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    querySnapshot.docs.forEach((element) {
      current.add(Comment.fromDocument(element));
    });
    products.addAll(current);
    setState(() {
      isLoading = false;
    });
  }

  Widget buildlisttile() {
    return ListTile(
      title: TextFormField(
        controller: _commentController,
        decoration: InputDecoration(labelText: 'Write a comment...'),
      ),
      trailing: OutlineButton(
        onPressed: () {
          addComment(_commentController.text);
        },
        borderSide: BorderSide.none,
        child: Text("Post"),
      ),
    );
  }

  Future<List<Comment>> getComments() async {
    List<Comment> comments = [];

    // QuerySnapshot data = await ref.get();
    // data.then.forEach((DocumentSnapshot doc) {
    //   comments.add(Comment.fromDocument(doc));
    // });
    ref
        .orderBy('timestamp')
        .limit(documentLimit)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                comments.add(Comment.fromDocument(doc));
              })
            });
    return comments;
  }

  addComment(String comment) async {
    _commentController.clear();
    await ref.add({
      "username": authobj.currentUser.name,
      "comment": comment,
      "timestamp": Timestamp.now(),
      "avatarUrl": authobj.currentUser.imageurl,
      "userId": authobj.currentUser.uid
    });

    // add comment to the current listview for an optimistic update
    // setState(() {
    //   fetchedComments = List.from(fetchedComments)
    //     ..add(Comment(
    //         username: authobj.currentUser.name,
    //         comment: comment,
    //         timestamp: Timestamp.now(),
    //         avatarUrl: authobj.currentUser.imageurl,
    //         userId: authobj.currentUser.uid));
    // });
    setState(() {
      products = List.from(products)
        ..add(Comment(
            username: authobj.currentUser.name,
            comment: comment,
            timestamp: Timestamp.now(),
            avatarUrl: authobj.currentUser.imageurl,
            userId: authobj.currentUser.uid));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Comments',
          style: TextStyle(color: kPrimaryColor),
        ),
        shadowColor: kPrimaryColor,
        actionsIconTheme: IconThemeData(color: kPrimaryColor),
        elevation: 10,
      ),
      body: Column(children: [
        Expanded(
          child: products.length == 0
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SvgPicture.asset(
                          'assets/images/chat.svg',
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.4,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Chat with Sellers and Other Buyers',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 36,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Be the First One to Start the chat',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          title:
                              Text(products[index].username ?? 'defaultvalue'),
                          subtitle:
                              Text(products[index].comment ?? 'defaultvalue'),
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(products[index].avatarUrl),
                          ),
                        ),
                        Text(products[index].timestamp.toDate().toString()),
                        Divider(),
                      ],
                    );
                    // return ListTile(
                    //   contentPadding: EdgeInsets.all(5),
                    //   title: Text(products[index].data['name']),
                    //   subtitle: Text(products[index].data['short_desc']),
                    // );
                  },
                ),
        ),
        Divider(),
        (products.length != 0 && isLoading)
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
            : Container(),
        buildlisttile()
      ]),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final Timestamp timestamp;

  Comment(
      {this.username,
      this.userId,
      this.avatarUrl,
      this.comment,
      this.timestamp});

  factory Comment.fromDocument(QueryDocumentSnapshot document) {
    print("${document.data().toString()}");
    return Comment(
      username: document.data()['username'],
      userId: document.data()['userId'],
      comment: document.data()["comment"],
      timestamp: document.data()["timestamp"],
      avatarUrl: document.data()["avatarUrl"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(username ?? 'defaultvalue'),
          subtitle: Text(comment ?? 'defaultvalue'),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(avatarUrl),
          ),
        ),
        Text(timestamp.toDate().toString()),
        Divider(),
      ],
    );
  }
}
