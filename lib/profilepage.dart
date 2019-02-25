import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'userobject.dart';
import 'main.dart';
import 'camera.dart';

class Profile extends StatefulWidget{

  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
 // FirebaseUser user;
  UserData userData = new UserData();
  DocumentSnapshot ss;

  @override
  initState(){
    //fix to not get all data
    getUserInfo();
    super.initState();
  }


  Future<void> changeData() async{
    //check logged in
    Firestore.instance.collection('user').document(userData.uid).setData(userData.toJson()).catchError((e) {
      print(e);
    });
  }

  getFromFirebase() async {
    final DocumentReference postRef = Firestore.instance.document("user/"+userData.uid);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if(postSnapshot!=null) {
        setState(() {
          ss = postSnapshot;
        });
      }
    });
  }


  setLocal() {
    userData.name=ss.data['name'];
    userData.major=ss.data['major'];
    userData.year=ss.data['year'];
    userData.imgurl=ss.data['imgurl'];
  }

  getUserInfo() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    if(_user!=null) {
      setState(() {
        userData.uid = _user.uid;
        userData.email = _user.email;
        getFromFirebase();
        //setLocal();
        // changeData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //fix??
    setLocal();
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.account_circle),
            onPressed: () {
            print('pressed edit');
              Navigator.pushNamed(context, '/EditProfile');
            },
          ),

        ],
        title: Text('user profile'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(400.0),
                bottomLeft: Radius.circular(400.0),
              )
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
                Text('email: '+userData.email,
                  style: TextStyle(color: Colors.white),
                ),

                Text('year: '+userData.year,
                  style: TextStyle(color: Colors.white),
                ),
                Text('major: '+userData.major,
                  style: TextStyle(color: Colors.white),
                ),
                Text('name: '+userData.name,
                  style: TextStyle(color: Colors.white),
                ),
              /*  SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child:
                    Container(
                      child: Image.network(userData.imgurl),
                      //child: Image.network('https://firebasestorage.googleapis.com/v0/b/something-fcc9c.appspot.com/o/QI5G6Mf46AfLIbVzL73QlZ3ZUbo1?alt=media&token=7b946a10-b4f0-420c-9bb1-82c2d446e3bb'),
                    ),
                ),*/
              Image.network(userData.imgurl,height: 250.0, width: 100.0,),
            ],
          ),
            ),
        ],
      ),
    );
  }
}

class EditProfile extends StatefulWidget {
  @override
  _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    print('asdads');
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile'),
      backgroundColor: Colors.blue,),
      body: Column(
        children: <Widget>[
          Center(
            child:
          SizedBox(
            width: MediaQuery.of(context).size.width-50,
            height: 30.0,
            child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}