import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gan_compress/database.dart';
// import 'package:gan_compress/screens/view_image.dart';
import 'post.dart';
import 'postList.dart';
import 'textInputWidget.dart';

class MyHomePage extends StatefulWidget {
  final User user;

  MyHomePage(this.user);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Post> posts = [];

  void newPost(String text, String image_url) {
    var post = new Post(
        text, widget.user.displayName, image_url, widget.user.photoURL);
    post.setId(savePost(post));
    this.setState(() {
      posts.add(post);
    });
  }

  void updatePosts() {
    getAllPosts().then((posts) => {
          this.setState(() {
            this.posts = posts;
          })
        });
  }

  @override
  void initState() {
    super.initState();
    updatePosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Penstagram",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Column(children: <Widget>[
          Expanded(child: PostList(this.posts, widget.user)),
          TextInputWidget(this.newPost)
        ]));
  }
}
