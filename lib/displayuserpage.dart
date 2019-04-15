import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'logout.dart';
import 'chat.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
https://stackoverflow.com/questions/52547731/tabbarview-with-variable-height-inside-a-listview
 */

class DisplayUserPage extends StatefulWidget {
  DocumentSnapshot userDocument;
  DisplayUserPage({Key key,this.userDocument}) :super(key:key);
  @override
  _DisplayUserPage createState() => _DisplayUserPage();
}

class _DisplayUserPage extends State<DisplayUserPage> with SingleTickerProviderStateMixin{
  String ss;
  TabController tabcontroller;
  int currentPage=0;
  FirebaseUser user;
  //FIX change ot init state
  List<bool> toggleCalender= new List(7*12);



  @override
  void initState(){
    getUser();
    tabcontroller=TabController(length: 3, vsync: this, initialIndex: 0);
    currentPage=0;
    toggleCalender.fillRange(0, toggleCalender.length, false);
  }


  Widget showCalender(){
    return Expanded(
      child: Column(
        children: <Widget>[
          daysOfWeek(),
          test('8 am',0),
          test('9 am',1),
          test('10 am',2),
          test('11 am',3),
          test('12 pm',4),
          test('1 pm',5),
          test('2 pm',6),
          test('3 pm',7),
          test('4 pm',8),

        ],
      )
    );
}

Widget test(String hour,int i){
  return Row(
    children: <Widget>[
      SizedBox(
        width: MediaQuery.of(context).size.width/8,
        child: Text(hour),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width/8,
        child: RaisedButton(onPressed: (){
          setState(() {
            toggleCalender[i*7]=!toggleCalender[i*7];
          });
        },color: toggleCalender[i*7]?Colors.red:Colors.blue,),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width/8,
        child: RaisedButton(onPressed: (){
          setState(() {
            toggleCalender[i*7+1]=!toggleCalender[i*7+1];
          });
        },color: toggleCalender[i*7+1]?Colors.red:Colors.blue,),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width/8,
        child: RaisedButton(onPressed: (){
          setState(() {
            toggleCalender[i*7+2]=!toggleCalender[i*7+2];
          });
        },color: toggleCalender[i*7+2]?Colors.red:Colors.blue,),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width/8,
        child: RaisedButton(onPressed: (){
          setState(() {
            toggleCalender[i*7+3]=!toggleCalender[i*7+3];
          });
        },color: toggleCalender[i*7+3]?Colors.red:Colors.blue,),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width/8,
        child: RaisedButton(onPressed: (){
          setState(() {
            toggleCalender[i*7+4]=!toggleCalender[i*7+4];
          });
        },color: toggleCalender[i*7+4]?Colors.red:Colors.blue,),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width/8,
        child: RaisedButton(onPressed: (){
          setState(() {
            toggleCalender[i*7+5]=!toggleCalender[i*7+5];
          });
        },color: toggleCalender[i*7+5]?Colors.red:Colors.blue,),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width/8,
        child: RaisedButton(onPressed: (){
          setState(() {
            toggleCalender[i*7+6]=!toggleCalender[i*7+6];
          });
        },color: toggleCalender[i*7+6]?Colors.red:Colors.blue,),
      ),
    ],
  );
}

  Widget daysOfWeek(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width/8,
          child: Text(''),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width/8,
          child: Text('Mon'),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width/8,
          child: Text('Tue'),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width/8,
          child: Text('Wed'),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width/8,
          child: Text('Thu'),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width/8,
          child: Text('Fri'),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width/8,
          child: Text('Sat'),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width/8,
          child: Text('Sun'),
        ),



      ],
    );
  }

  void setCurrentPage(index){
    setState(() {
      currentPage=index;
    });
  }
  getUser() async {
    FirebaseUser _user= await FirebaseAuth.instance.currentUser();
    setState(() {
      user=_user;
    });
  }

  Widget chat(){

    //FirebaseUser user;
    String toUser;
    String content;
    String message;
    String type;
    String groupchatid;
    MessageUsers users=MessageUsers();


    if (user.email.hashCode<='${widget.userDocument['email']}'.toString().hashCode){
      print('less thatn');
      setState(() {
        users.groupchatid=user.email+' '+'${widget.userDocument['email']}'.toString();
        users.toUser='${widget.userDocument['email']}'.toString();
        users.fromUser=user.email;
      });
    } else {
      setState(() {
        users.groupchatid='${widget.userDocument['email']}'.toString()+' '+user.email;
        users.toUser='${widget.userDocument['email']}'.toString();
        users.fromUser=user.email;
      });
    }

    return Column(
      children: <Widget>[

      ],
    );
  }

  Widget userPage(){
    return  Column(
      children: <Widget>[
                 Container(
                 padding: EdgeInsets.all(10),
               height: MediaQuery.of(context).size.height/3,
             child: Image.network('${widget.userDocument['imgurl']}'.toString()),
         ),
        Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Text('${widget.userDocument['name']}',style: TextStyle(fontSize: 40,color: Colors.teal),),
        ),
        Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Text('${widget.userDocument['major']}',style: TextStyle(fontSize: 30,color: Colors.teal),),
        ),
        Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Text('${widget.userDocument['year']}',style: TextStyle(fontSize: 20,color: Colors.teal),),
        ),
        Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Text('Classes Taking: ',style: TextStyle(fontSize: 20,color: Colors.teal),),
        ),
        Container(
          height: MediaQuery.of(context).size.height/5,
          child:
          Container(
            alignment: Alignment.center,
            child: Text('${widget.userDocument['classes']}'.replaceAll('[', '').replaceAll(']',''),style: TextStyle(color: Colors.white,fontSize: 25),),
          ),
        )
      ],
    );

  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      ss='${widget.userDocument}';
    });
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.teal
        ),
        backgroundColor: Colors.white,
        title: Text('Profile of '+'${widget.userDocument['name']}',style: TextStyle(color: Colors.teal),),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          currentPage==0?userPage():currentPage==1?showCalender():chat(),
        ],
/*              Container(
               // height: 100,
                child:
              TabBar(
                unselectedLabelColor: Colors.black,
                labelColor: Colors.white,
                controller: tabcontroller,
                tabs: <Widget>[
                  Tab(child: Text('User Information'),),
                  Tab(icon: Text('Availability'),),
                  Tab(child:Text(tabcontroller.index.toString()+' hello')),
                ],
              ),
              ),
              */
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.teal,
        currentIndex: currentPage,
        onTap: setCurrentPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('User Information'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            title: Text('Availability'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('message'),
          ),
        ],
      ),
    );
  }
}