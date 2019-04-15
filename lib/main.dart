import 'package:flutter/material.dart';
import 'homescreen.dart';
import 'login.dart';
import 'profilepage.dart';
import 'displayusers.dart';
import 'chat.dart';
import 'createuser.dart';
import 'camera.dart';
import 'onboarding.dart';


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
      ),
      routes: <String,WidgetBuilder>{
        '/homepage':(context)=> new HomeScreen(),
        '/':(context)=> new HomeScreen(),
        '/login':(context)=> new LoginPage(),
        '/chat':(context)=> new Chat(),
        '/Profile':(context)=> new Profile(),
        '/EditProfile':(context)=> new EditProfile(),
        '/createaccount':(context)=> new CreateAccountPage(),
        '/camera':(context)=> new CameraApp(),
        '/onboarding':(context)=> Onboarding(),

      },
    );
  }
}