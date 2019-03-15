import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'home.dart';
import 'chat.dart';
import 'displayusers.dart';
import 'profilepage.dart';
import 'camera.dart';


class Object{
  String uid='default';
  String something='default';
  String answer='default';
  int question_number=-1;

  toJson(){
    return {
      "something":something,
      "answer":answer,
      "question_number":question_number,
      "uid":uid,

    };
  }
}


class HomeScreen extends StatefulWidget{
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  int currentPage=0;
  String wow;
//  final Future
  FirebaseUser user;

  @override
  void initState() {
    CheckLogin();
    super.initState();
  }

  CheckLogin() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    setState(() {
      user=_user;
    });
  }

//  FirebaseUser current;

//  Object oops=new Object();

  final List<Widget> renderedPages =[
    //CameraApp(),
    Chat(),
    Profile(),
   // FilterUsers(),
    CreateQuery(),
  ];

/*
  String getrealuid(){
    FirebaseAuth.instance.currentUser().then((uer){
      print(uer.uid.toString());
      wow=uer.uid;
      oops.uid=wow;
      //uer.uid.then((temp){
        //print(temp);
        return wow;
      //});
    });
  }
*/


  void setCurrentPage(index){
    setState(() {
      currentPage=index;
    });
  }



  @override
  Widget build(BuildContext context) {
    if(user==null){
      return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          child: LoginPage(),
        ),
      );
    }
    return new Scaffold(
      body: renderedPages[currentPage],
      bottomNavigationBar:
          Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.green,
            ),
        child: BottomNavigationBar(
          fixedColor: Colors.white,
          currentIndex: currentPage,
          onTap: setCurrentPage,
          items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('Message'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
        ],
        ),
      ),
    );
  }
}