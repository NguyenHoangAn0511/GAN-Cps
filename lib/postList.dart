import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'post.dart';

class PostList extends StatefulWidget {
  final List<Post> listItems;
  final User user;

  PostList(this.listItems, this.user);

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  void like(Function callBack) {
    this.setState(() {
      callBack();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: ListView.builder(
            shrinkWrap: true,
            // reverse: true,
            itemCount: this.widget.listItems.length,
            itemBuilder: (context, index) {
              var postList = this.widget.listItems.reversed.toList();
              var post = postList[index];
              return Card(
                color: Colors.black,
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        post.author,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      subtitle:
                          Text(post.body, style: TextStyle(color: Colors.grey)),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(post.userImage),
                      ),
                    ),
                    CachedNetworkImage(
                      // height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      imageUrl: post.imageUrl,
                      fit: BoxFit.fill,
                    ),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //         child: Image.network(
                    //       post.imageUrl,
                    //       fit: BoxFit.fill,
                    //     ))
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: <Widget>[
                            // Padding(
                            //   padding: EdgeInsets.all(20.0),
                            // ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      iconSize: 30,
                                      // padding: EdgeInsets.zero,
                                      icon: Icon(
                                        Icons.star,
                                      ),
                                      onPressed: () => this.like(
                                          () => post.likePost(widget.user)),
                                      color: post.usersLiked
                                              .contains(widget.user.uid)
                                          ? Colors.red
                                          : Colors.white),
                                  Text(post.usersLiked.length.toString(),
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        ),
                      ],
                    ),
                    // Divider(
                    //   color: Colors.white,
                    //   thickness: 1,
                    // ),
                  ],
                ),
                // margin: EdgeInsets.only(left: 0.0, right: 20.0, top: 5.0),
              );
            }
            // return Card(
            //     child: Row(children: <Widget>[
            //   Expanded(
            //       child: ListTile(
            //     title: Text(post.body),
            //     subtitle: Text(post.author),
            //   )),
            //   Row(
            //     children: <Widget>[
            //       Container(
            //         child: Text(post.usersLiked.length.toString(),
            //             style: TextStyle(fontSize: 20)),
            //         padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            //       ),
            //       IconButton(
            //           icon: Icon(Icons.thumb_up),
            //           onPressed: () => this.like(() => post.likePost(widget.user)),
            //           color: post.usersLiked.contains(widget.user.uid)
            //               ? Colors.green
            //               : Colors.black)
            //     ],
            //   )
            // ])
            // );
            // },
            ));
  }
}
