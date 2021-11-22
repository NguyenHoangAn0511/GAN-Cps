import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:gan_compress/database.dart';

class Post {
  String body;
  String author;
  String imageUrl;
  Set usersLiked = {};
  String userImage;
  DatabaseReference _id;

  Post(this.body, this.author, this.imageUrl, this.userImage);

  void likePost(User user) {
    if (this.usersLiked.contains(user.uid)) {
      this.usersLiked.remove(user.uid);
    } else {
      this.usersLiked.add(user.uid);
    }
    this.update();
  }

  void update() {
    updatePost(this, this._id);
  }

  void setId(DatabaseReference id) {
    this._id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'author': this.author,
      'usersLiked': this.usersLiked.toList(),
      'body': this.body,
      'imageUrl': this.imageUrl,
      'userImage': this.userImage,
    };
  }
}

Post createPost(record) {
  Map<String, dynamic> attributes = {
    'author': '',
    'usersLiked': [],
    'body': '',
    'imageUrl': '',
    'userImage': '',
  };

  record.forEach((key, value) => {attributes[key] = value});

  Post post = new Post(attributes['body'], attributes['author'],
      attributes['imageUrl'], attributes['userImage']);
  post.usersLiked = new Set.from(attributes['usersLiked']);
  return post;
}
