import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'userobject.dart';


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
      appBar: AppBar(
        title: Text('user profile'),
      ),
      body: Container(
         //   Text("name "+userData.name),
           // Text("email "+userData.email),
           // Text("major "+userData.major),
           // Text("year "+userData.year),
           child: Container(
             child: ListView(
               children: <Widget>[
                 Center(
                   child: Text("uid: "+userData.uid,
                     style: TextStyle(
                       fontSize: 29.0,
                     ),),
                 ),
                 Center(
                   child: Text("email: "+userData.email,
                     style: TextStyle(
                       fontSize: 29.0,
                     ),),
                 ),
                 Center(
                   child: Text("major: "+userData.major,
                     style: TextStyle(
                       fontSize: 29.0,
                     ),),
                 ),
                 Center(
                   child: Text("year: "+userData.year,
                   style: TextStyle(
                     fontSize: 29.0,
                   ),),
                 ),
               ],
                 ),
             ),
              height: MediaQuery.of(context).size.height/2,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(42),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
            ),
/*
            StreamBuilder(
              stream: Firestore.instance.collection('user').document(userData.uid).snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Text('empty');
                }
                return Column(
                  children: <Widget>[
                  //  Text(snapshot.data['name']),
                   // Text('email '+snapshot.data['email']),
                    //Text('major '+snapshot.data['major']),
                    //Text('year '+snapshot.data['year']),
                  ],
                );
              },

            ),
  */
      );
  }
}