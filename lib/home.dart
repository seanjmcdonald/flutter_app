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
        backgroundColor: Colors.white,
        title: Text('homepage'),
      ),
      body: Text('HOMEPAGE FOR '+user.uid),
      backgroundColor: Colors.white,
    );
  }
}