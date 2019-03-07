import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'home.dart';
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
    CameraApp(),
    DisplayUsers(),
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
          fixedColor: Colors.black,
          currentIndex: currentPage,
          onTap: setCurrentPage,
          items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.notifications),
            title: Text('Notifications'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            title: Text('store'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('place holder'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('filter'),
          ),
        ],
        ),
      ),
    );
  }
}