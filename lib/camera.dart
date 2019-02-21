import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart';
import 'package:firebase_storage/firebase_storage.dart';

/*

https://www.youtube.com/watch?v=kNe4Fw3zkKY
https://stackoverflow.com/questions/51857796/flutter-upload-image-to-firebase-storage
 */


class CameraApp extends StatefulWidget{

  @override
  _CameraApp createState() => _CameraApp();
}

class _CameraApp extends State<CameraApp> {
  FirebaseUser user;
  File image;
  String location;
  StorageReference reference = FirebaseStorage.instance.ref().child('QI5G6Mf46AfLIbVzL73QlZ3ZUbo1');

  uploadImage() async {
    if(user!=null) {
      final StorageReference ref = FirebaseStorage.instance.ref().child(user.uid);
      final StorageUploadTask task = ref.putFile(image);
      String downurl = (await (await task.onComplete).ref.getDownloadURL()).toString();
      setState(() {
        location= downurl.toString();
      });
    }
  }

  @override
  initState(){
      getUid();
    super.initState();
  }

  getUid() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    if (_user!=null){
      setState(() {
        user=_user;
      });
    }
  }

  getFromGallery() async{
    File _image= await ImagePicker.pickImage(source: ImageSource.gallery);
    if(_image!=null) {
      print(_image.path);
      setState(() {
        image = _image;
      });
    }
  }

  getFromCamera() async{
    File _image= await ImagePicker.pickImage(source: ImageSource.camera);
    if(_image!=null) {
      print(_image.path);
      setState(() {
        image = _image;
      });
    }
  }

  getPhoto() async{
    String download= await reference.getDownloadURL();
    setState(() {
      location='';
    });

  }

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
      body: ListView(
        children: <Widget>[
          SizedBox(
            width: 200.0,
            height: 270.0,
            child: image==null?Container():Image.file(image),
          ),
          Column(
            //mainAxisAlignment: MainAxisAlignment.,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(height: 40.0,width: 110.0,child: RaisedButton(child: Text('from gallery'),onPressed: getFromGallery,color: Colors.red,),),
                  SizedBox(height: 40.0,width:110.0,child:RaisedButton(child: Text('with camera'),onPressed: getFromCamera,color: Colors.blue,),),
                ],
              ),
              SizedBox(child: image!=null?RaisedButton(child: Text('upload photo'),onPressed: () {
                uploadImage();location==null?print('waiting'):Container(child:Text('the future is '+location.toString()));
              }
              ):Text(''),),
              location==null?Text(''):Text(location),
              //image!=null?RaisedButton(onPressed: null):
          ],
          ),
        ],
      ),
  //    floatingActionButton: FloatingActionButton(
    //    onPressed: null,
      //  child: Icon(Icons.camera_alt),
      //),
    );
  }
}