import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api/fire_base_upload.dart';
import 'post.dart';

class TextInputWidget extends StatefulWidget {
  final Function(String, String) callback;
  // final String image_url = '';

  TextInputWidget(this.callback);

  @override
  _TextInputWidgetState createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  final controller = TextEditingController();
  final imagePicker = ImagePicker();
  File file;
  UploadTask task;
  String imageUrl;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void click() async {
    final result = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 100);

    if (result == null) return;
    final path = result.path;

    setState(() => file = File(path));
    if (file == null) return;
    String fileName = file.path.split('/').last;
    // final fileName = basename(file.path);
    final destination = 'files/$fileName';
    print(destination);

    task = FirebaseApi.uploadFile(destination, file);
    setState(() {});

    if (task == null) return;

    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
    widget.callback(controller.text, urlDownload);
    FocusScope.of(context).unfocus();

    // selectFile();
    // uploadFile();

    controller.clear();
  }

  Future selectFile() async {
    final result = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 100);

    if (result == null) return;
    final path = result.path;

    setState(() => file = File(path));
    if (file == null) return;
    String fileName = file.path.split('/').last;
    // final fileName = basename(file.path);
    final destination = 'files/$fileName';
    print(destination);

    task = FirebaseApi.uploadFile(destination, file);
    setState(() {});

    if (task == null) return;

    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download-Link: $urlDownload');
    setState(() {});
  }

  Future uploadFile() async {
    if (file == null) return;
    String fileName = file.path.split('/').last;
    // final fileName = basename(file.path);
    final destination = 'files/$fileName';
    print(destination);

    task = FirebaseApi.uploadFile(destination, file);
    setState(() {});

    if (task == null) return;

    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: this.controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.add_a_photo_rounded,
              color: Colors.white,
            ),
            hintStyle: TextStyle(
              color: Colors.white,
            ),
            hintText: "Post somethings fun here!!!",
            suffixIcon: IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.white,
              ),
              splashColor: Colors.grey,
              tooltip: "Post message",
              color: Colors.white,
              onPressed: this.click,
            )));
  }
}
