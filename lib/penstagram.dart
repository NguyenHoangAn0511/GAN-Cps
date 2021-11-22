import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Penstagram extends StatefulWidget {
  @override
  _PenstagramState createState() => _PenstagramState();
}

class _PenstagramState extends State<Penstagram> {
  final myController = TextEditingController();
  final imagePicker = ImagePicker();
  File image_to_upload;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  Future getImageGallery() async {
    final image = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 100);

    setState(() {
      image_to_upload = File(image.path);
      print(image_to_upload);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload image',
          style: TextStyle(
          fontSize: 25,
        ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
        // padding: const EdgeInsets.all(16.0),
        children: [
          TextField(
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow),
              ),
              hintText: "Say somethings about this picture",
              hintStyle: TextStyle(
                color: Colors.grey,
              )
          ),
          controller: myController,
        ),
          image_to_upload != null ? Image.file(image_to_upload, width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ) : Text(''),
        ]
      ),

      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          print(myController.text);
          FocusScope.of(context).unfocus();
          getImageGallery();
          // Get text input before clear
          // Get it here
          myController.clear();
          print(myController.text);
        },
        tooltip: 'Show me the value!',
        child: const Icon(Icons.text_fields),
      ),
    );
  }
}
