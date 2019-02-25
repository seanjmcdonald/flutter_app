import 'package:flutter/material.dart';
import 'homescreen.dart';
import 'login.dart';
import 'profilepage.dart';


void main() {
  runApp(new SeniorProject());
}

class SeniorProject extends StatelessWidget{
  @override

  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Senior Project',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        //canvasColor: Colors.black,
        //primaryColor: Colors.orange,
      ),
      routes: <String,WidgetBuilder>{
        '/homepage':(context)=> new HomeScreen(),
        '/':(context)=> new HomeScreen(),
        '/login':(context)=> new LoginPage(),
        '/Profile':(context)=> new Profile(),
        '/EditProfile':(context)=> new EditProfile(),
    },
    );
  }
}