import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gan_compress/homepage.dart';
import 'package:gan_compress/login.dart';
import 'package:gan_compress/penstagram.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:image/image.dart' as img;
import 'penstagram.dart';
// import 'package:image_cropper/image_cropper.dart';

class Transfer extends StatefulWidget {
  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  img.Image aimage;
  File _image;
  final imagePicker = ImagePicker();
  List generate4dList(List<double> fList) {
    //this function will return 4D Array made by a flatten array
    // print(fList.shape);
    var list = List.generate(
        1,
        (i) => List.generate(3,
            (j) => List.generate(256, (k) => List.generate(256, (l) => 0.0))));
    int y = 0;
    for (int j = 0; j < 256; j++) {
      for (int k = 0; k < 256; k++) {
        list[0][0][j][k] = fList[y];
        list[0][1][j][k] = fList[y + 1];
        list[0][2][j][k] = fList[y + 2];
        y += 3;
      }
    }
    return list;
  }

  img.Image createImage(List list, int inputSize) {
    img.Image image = img.Image(inputSize, inputSize);
    img.fill(image, img.getColor(0, 0, 0));
    for (int i = 0; i < inputSize; i++) {
      for (int j = 0; j < inputSize; j++) {
        double redValue = list[0][0][j][i];
        double greenValue = list[0][1][j][i];
        double blueValue = list[0][2][j][i];
        img.drawPixel(
            image,
            i,
            j,
            img.getColor(
                (((redValue + 1) / 2.0) * 255).round(),
                (((greenValue + 1) / 2.0) * 255).round(),
                (((blueValue + 1) / 2.0) * 255).round()));
      }
    }
    return image;
  }

  Future loadModel(File _image) async {
    ImageProcessor imageProcessor = ImageProcessorBuilder()
        .add(ResizeOp(256, 256, ResizeMethod.NEAREST_NEIGHBOUR))
        .add(new NormalizeOp(0, 255))
        .add(new NormalizeOp(0.5, 0.5))
        .build();
    img.Image imageInput = img.decodeImage(_image.readAsBytesSync());

    TensorImage tensorImage;
    tensorImage = TensorImage(TfLiteType.float32);
    tensorImage.loadImage(imageInput);
    try {
      // Create interpreter from asset.
      tensorImage = imageProcessor.process(tensorImage);

      Interpreter interpreter = await Interpreter.fromAsset("pt2vna.tflite");
      var _outputShape = interpreter.getOutputTensor(0).shape;
      var _outputType = interpreter.getOutputTensor(0).type;

      TensorBuffer probabilityBuffer =
          TensorBuffer.createFixedSize(_outputShape, _outputType);
      interpreter.run(tensorImage.buffer, probabilityBuffer.buffer);
      List<List<List<List<double>>>> lis =
          generate4dList(probabilityBuffer.getDoubleList());
      img.Image image = createImage(lis, 256);
      aimage = image;
    } catch (e) {
      print('Error loading model: ' + e.toString());
    }
  }

  Uint8List loadImage() {
    if (aimage == null) {
      img.Image image = img.Image(256, 256);
      img.fill(image, img.getColor(0, 0, 0));
      img.Image resizeImageContent =
          img.copyResize(image, height: 256, width: 256);

      return img.encodeJpg(resizeImageContent);
    } else {
      return img.encodeJpg(aimage);
    }
  }

  Future getImageCamera() async {
    final image = await imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 100);
    setState(() {
      _image = File(image.path);
      loadModel(_image);
    });
    // img_ = Image.memory(loadImage(),
    //     width: MediaQuery.of(context).size.width,
    //     height: MediaQuery.of(context).size.width,
    //     fit: BoxFit.fill);
  }

  Future getImageGallery() async {
    final image = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 100);

    setState(() {
      _image = File(image.path);
      loadModel(_image);
    });
    // img_ = aimage != null
    //     ? Image.memory(loadImage(),
    //         width: MediaQuery.of(context).size.width,
    //         height: MediaQuery.of(context).size.width,
    //         fit: BoxFit.fill)
    //     : Text("No Image selected");
  }

  void saveImage() async {
    var now = DateTime.now();
    final result = await ImageGallerySaver.saveImage(loadImage(),
        quality: 60, name: now.toString());
    print(result);
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => MyHomePage());
      }
      if (index == 1) {
        isTap = false;

        getImageCamera();
        // img_ = null;
      }
      if (index == 2) {
        isTap = false;

        getImageGallery();
        // img_ = null;
      }
      if (index == 3) {
        saveImage();
      }
      if (index == 4) {
        Body();
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => Body()));
      }
    });
  }

  bool isTap = false;
  Image img_;

  Widget ImageWidget() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            aimage != null
                ? Image.memory(loadImage(),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill)
                : Image.asset('assets/images/MMLAB.png',
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    fit: BoxFit.contain),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ))
          ],
        ));
  }

  Widget testing() {
    if ([0, 1, 2, 3].contains(_selectedIndex)) {
      return ImageWidget();
    }
    return Body();
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
        actions: [
          IconButton(
              icon: Icon(Icons.info_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondRoute()),
                );
              })
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/black.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        // child: ImageWidget(),
        child: (_selectedIndex != 4) ? testing() : Body(),
        // child: Container(
        //     width: MediaQuery.of(context).size.width,
        //     height: MediaQuery.of(context).size.height,
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         aimage != null
        //             ? Image.memory(loadImage(),
        //                 width: MediaQuery.of(context).size.width,
        //                 height: MediaQuery.of(context).size.width,
        //                 fit: BoxFit.fill)
        //             : Image.asset('assets/images/wooble3.jpg',
        //                 width: MediaQuery.of(context).size.width,
        //                 height: MediaQuery.of(context).size.width,
        //                 fit: BoxFit.fill),
        //         Container(
        //             child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //         ))
        //       ],
        //     )),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Upload image',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              size: 35,
            ),
            label: 'Add from gallery',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.save),
            label: 'save',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: 'media',
            backgroundColor: Colors.black,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        enableFeedback: false,
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Credit"),
        backgroundColor: Colors.grey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Authors:',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
                letterSpacing: 0.5,
                fontSize: 30,
              ),
            ),
            Text(
              'Nguyễn Hoàng An',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
                letterSpacing: 0.5,
                fontSize: 20,
              ),
            ),
            Text(
              'Dương Trọng Văn',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
                letterSpacing: 0.5,
                fontSize: 20,
              ),
            ),
            Text(
              'Special thanks to:',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
                letterSpacing: 0.5,
                fontSize: 30,
              ),
            ),
            Text(
              'UIT MMLAB',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
                letterSpacing: 0.5,
                fontSize: 20,
              ),
            ),
            Text(
              'Artist Trần Nguyên',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
                letterSpacing: 0.5,
                fontSize: 20,
              ),
            ),
            Text(
              'Việt Nam ơi Facebook group',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
                letterSpacing: 0.5,
                fontSize: 20,
              ),
            ),
            Text(
              'Pixabay',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
                letterSpacing: 0.5,
                fontSize: 20,
              ),
            ),
            Text(
              'Unsplash',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
                letterSpacing: 0.5,
                fontSize: 20,
              ),
            ),
            Text(
              'Pexel',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
                letterSpacing: 0.5,
                fontSize: 20,
              ),
            ),
            Text(
              'Wikiart',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
                letterSpacing: 0.5,
                fontSize: 20,
              ),
            ),
            Text(
              'vietnamartist.com',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
                letterSpacing: 0.5,
                fontSize: 20,
              ),
            ),
            Text(
              'oilpaintingdc.com',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
                letterSpacing: 0.5,
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
