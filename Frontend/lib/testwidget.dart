import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/allimports.dart'; 
import 'package:image_picker/image_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  List<File> _images = [];

  Future<void> pickImages() async {
    List<XFile>? images = await ImagePicker().pickMultiImage(
      maxWidth: 800,
      imageQuality: 70,
    );

    if (images != null) {
      setState(() {
        _images = images.map((image) => File(image.path)).toList();
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Images'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: pickImages,
            child: Text('Pick Images'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_images.isNotEmpty) {
                APIHandler().uploadImages(_images);
              } else {
                print('No images selected');
              }
            },
            child: Text('Upload Images'),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.file(_images[index]),
                  title: Text(_images[index].path.split('/').last),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
