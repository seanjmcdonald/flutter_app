import 'userobject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:async/async.dart';

/*
https://medium.com/saugo360/flutter-my-futurebuilder-keeps-firing-6e774830bc2
http://tphangout.com/flutter-firestore-crud-reading-and-writing-data/
 */



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
        padding: EdgeInsets.all(5.0),
        itemBuilder: (context,i){
          return ListTileTheme(
            child: ListTile(
              selected: false,
              title: Text(ss.documents[i].data['uid']),
              subtitle: Text(ss.documents[i].data['major']),
              onTap: () {
                setState(() {

                  Text('sdsd');
                  print('asdad');
                });

              }
            ),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('searched users'),),
      body: ListUsers(),
    );
  }
}