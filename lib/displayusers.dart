import 'userobject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:async/async.dart';
import 'logout.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'dart:math' as math;
/*
https://medium.com/saugo360/flutter-my-futurebuilder-keeps-firing-6e774830bc2
http://tphangout.com/flutter-firestore-crud-reading-and-writing-data/
 */


class FilterUsers extends StatefulWidget {
  @override
  _FilterUsers createState() => _FilterUsers();
}

class _FilterUsers extends State<FilterUsers> {
  FirebaseUser user;
  QuerySnapshot ss;

  getUser() async{
    FirebaseUser _user= await FirebaseAuth.instance.currentUser();
    if(_user!=null){
      setState(() {
        user=_user;
      });
    }
  }

  getData() async{
    return await Firestore.instance.collection('user').where('major', isEqualTo:'murderer').snapshots();

  }

  Widget search(query){
    return StreamBuilder(
      stream: Firestore.instance.collection('user').where('major', isEqualTo: query).snapshots(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return Text('loading');
        }
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context,i){
                return ListTileTheme(
                  child:  Center(
                    child: Text(i.toString()),
                  //  child: Text(ss.documents[i].data['major'].toString()),
                  ),
                );
                print(ss.documents[i].data['major']);
              },
          );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    getData().then((snapshot){
      print(snapshot.data.documents.length);
      setState(() {
        ss=snapshot;
        print(snapshot.toString());
      });
    });
    return Scaffold(
      appBar: AppBar(title: Text('query'),),
      body: search('murderer'),
    );
  }
}


class DisplayUsers extends StatefulWidget {
 // final AsyncMemoizer _memoizer = new AsyncMemoizer();

  @override
  _DisplayUsers createState() => _DisplayUsers();

}

class _DisplayUsers extends State<DisplayUsers> {
UserData userData = new UserData();
QuerySnapshot ss;

  initState() {
    getData().then((snapshot){
      setState(() {
        ss=snapshot;
      });
    });
    super.initState();
  }
  getData() async{
    return await Firestore.instance.collection('user').getDocuments();
  }

  Widget ListUsers() {
    if(ss==null){
      return Center(child: Column(children: <Widget>[Text('loading...')],mainAxisAlignment: MainAxisAlignment.spaceEvenly,),);
    }
    return ListView.builder(
      itemCount: ss.documents.length,
        //padding: EdgeInsets.all(5.0),
        itemBuilder: (context,i){
          return ListTileTheme(
            child: Container(
              //width: MediaQuery.of(context).size.width,
              color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0)
              ,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 100.0,
                   // padding: EdgeInsets.all(5.0),
                    height: 150.0,
                    child: Image.network(ss.documents[i].data['imgurl'].toString(),height: 250, width: 100.0,),),
                  Container(child: Column(children: <Widget>[Text(ss.documents[i].data['name']),Text(ss.documents[i].data['major']),Text(ss.documents[i].data['year'])],),),
            //  ListTile(
              //selected: false,
                //title: Text(ss.documents[i].data['uid']),
               // subtitle: Text(ss.documents[i].data['major']),
             // ),
                ],
              ),

          ),
            );
      /*      child: ListTile(
              selected: false,
              title: Text(ss.documents[i].data['uid']),
              subtitle: Text(ss.documents[i].data['major']),
              onTap: () {
                setState(() {

                  Text('sdsd');
                  print('asdad');
                });

              }
            ), */

        });
  }

Future<LoginPage>_logOut() async{
  await FirebaseAuth.instance.signOut().then((_){
    Navigator.of(context).pushNamedAndRemoveUntil('/login',ModalRoute.withName('/'));});
  return LoginPage();
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('searched users'),
        actions: <Widget>[
          FlatButton(onPressed: _logOut, child: Text('sign out',style: TextStyle(color: Colors.white),)),
        ],
      ),
      body: ListUsers(),
    );
  }
}