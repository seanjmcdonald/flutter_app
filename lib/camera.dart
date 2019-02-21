import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:async/async.dart';


/*

https://www.youtube.com/watch?v=kNe4Fw3zkKY

 */


class CameraApp extends StatefulWidget{

  @override
  _CameraApp createState() => _CameraApp();
}

class _CameraApp extends State<CameraApp> {

  File image;
  picker() async{
    print('clicker was called');
  //  ImagePicker.pickImage(source: ImageSource.camera);
    File _image= await ImagePicker.pickImage(source: ImageSource.camera);
    if(_image!=null) {
      print(_image.path);
      setState(() {
        image = _image;
      });
    }
  }

  @override
  Widget build(context){
    return Scaffold(
      appBar: AppBar(title: Text('camera')),
      body: Container(
        child: Center(
          child: image==null?Text('no image so show'):Image.file(image)),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: picker,
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}