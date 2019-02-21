import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'userobject.dart';
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

   // return Firestore.instance.collection('user').document(userData.uid).getData();
  }


  setLocal() {
    StreamBuilder(
      stream: Firestore.instance.collection('user').document(userData.uid).snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          changeData();
        }

        userData.name=snapshot.data['name'];
        userData.major=snapshot.data['major'];
        userData.year=snapshot.data['year'];

        // Text('email '+snapshot.data['email']),
            //Text('major '+snapshot.data['major']),
            //Text('year '+snapshot.data['year']),
      },

    );
  }

  getUserInfo() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    setState(() {

      userData.uid=_user.uid;
      userData.email=_user.email;
      userData.major='compsci';
      getFromFirebase();
      setLocal();
      //userData.email=_user.
      changeData();

    });
  }

  @override
  Widget build(BuildContext context) {
  //    getUserInfo();
 //   getUserInfo();
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
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
                Container(
                 //              child: Image(image: ),
                ),
            ],
          ),
            ),
          GestureDetector(child: Text('asdasdasd'),onTap: () {
            print('asdds');
            Center(child:
           new  Text('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',style: TextStyle(color: Colors.white),),
            );
          }),


        ],
      ),
    );
  }
}