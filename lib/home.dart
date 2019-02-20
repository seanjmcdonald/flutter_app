import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Home extends StatefulWidget{
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {

  FirebaseUser user;

  @override
  initState(){
    getFireBaseUser();
    super.initState();
  }


  getFireBaseUser() async{
    FirebaseUser _user=await FirebaseAuth.instance.currentUser();

    setState(() {
      user=_user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.verified_user),onPressed: null,),
        ],
        backgroundColor: Colors.white,
        title: Text('homepage'),
      ),
      body: Text('HOMEPAGE FOR '+user.uid),
      backgroundColor: Colors.white,
    );
  }
}