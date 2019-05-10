import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'userobject.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'homescreen.dart';
/*

https://www.youtube.com/watch?v=kNe4Fw3zkKY
https://stackoverflow.com/questions/51857796/flutter-upload-image-to-firebase-storage
 */


class CameraApp extends StatefulWidget{

  @override
  _CameraApp createState() => _CameraApp();
}



class _CameraApp extends State<CameraApp> {
  UserData userData;
  FirebaseUser user;
  File image;
  String location;
  //StorageReference reference = FirebaseStorage.instance.ref().child();


  changeProfilePicture() {
      //check logged in
    Firestore.instance.collection('user').document(user.uid).updateData({"imgurl":location}).catchError((e){
      print(e.toString()+ 'error in changeprofilepicture');
    });
    //  Firestore.instance.collection('user').document(userData.uid).setData(userData.toJson()).catchError((e) {
      //print(e);
  //  });
  }

  uploadImage() async {
    Fluttertoast.showToast(msg: "Don't move to the next page until you get a confirmation");
    if(user!=null) {
      final StorageReference ref = FirebaseStorage.instance.ref().child(user.uid);
      final StorageUploadTask task = ref.putFile(image);

      String downurl = (await (await task.onComplete).ref.getDownloadURL()).toString();
      Fluttertoast.showToast(msg: 'Image uploaded, change your image or go to the next page.');
      if(downurl!=null) {
        setState(() {
          location = downurl.toString();
          changeProfilePicture();
        });
      }
    }
  }

  @override
  initState(){
      getUid();
      if(user!=null){

      }
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

  getAuth(){
    if(user!=null && user.isEmailVerified){
      Navigator.pushReplacement(context,new MaterialPageRoute(builder: (context)=> new HomeScreen()));
    } else{
      Fluttertoast.showToast(msg: "Are you sure you verified your email?");
    }
  }

  @override
  Widget build(context){
    return Scaffold(
      backgroundColor: Colors.teal,
     // appBar: AppBar(title: Text('camera')),
      body: ListView(
        children: <Widget>[
          SizedBox(
            width: 200.0,
            height: 270.0,
            child: image==null?Center(child:Container(child: Text("You don't need to upload a picture, you are welcome to do so!",style: TextStyle(color: Colors.white,fontSize: 25),textAlign: TextAlign.center,),
            padding: EdgeInsets.all(20),),)
                :Image.file(image),
          ),
          Column(
            //mainAxisAlignment: MainAxisAlignment.,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(height: 40.0,width: 110.0,child: RaisedButton(child: Text('from gallery'),onPressed: getFromGallery,color: Colors.white,),),
                  SizedBox(height: 40.0,width:110.0,child:RaisedButton(child: Text('with camera'),onPressed: getFromCamera,color: Colors.white,),),
                ],
              ),
              SizedBox(child: image!=null?RaisedButton(child: Text('upload photo'),onPressed: () {
                uploadImage();
                location==null?Text('waiting'):Container(child:Text('the future is '+location.toString()));
              }
              ):Text(''),),
              Center(child:Container(child: Text("You should have received an authentication email, hit the buttom below after you confirm",style: TextStyle(color: Colors.white,fontSize: 25),textAlign: TextAlign.center,),
                padding: EdgeInsets.all(20),),),
             RaisedButton(onPressed: getAuth,child: Text('Log In',),color: Colors.white,),

             /* SizedBox(height: 40.0,width: 110.0,
                child: RaisedButton(child:
                Text('back to profile'),
                  onPressed:() {
                    Navigator.of(context).pushNamed('/Profile');
    },

                   // Navigator.pushNamed(context,'/Profile'),
                  color: Colors.red,
              ),),
              */
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