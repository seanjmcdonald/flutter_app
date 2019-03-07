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


class CreateQuery extends StatefulWidget {
  @override
  _CreateQuery createState() => _CreateQuery();
}

class _CreateQuery extends State<CreateQuery> {
  List<DropdownMenuItem<String>> selectYear = [];
  List<DropdownMenuItem<String>> selectMajor = [];
  String selectedYear='none';
  bool showSearch=false;

  UserData userData = new UserData();
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
    return await Firestore.instance.collection('user').where('major', isEqualTo:'murderer').getDocuments();
  }

  loadYear(){
    selectYear.add(DropdownMenuItem(
      child: Text('Freshman'),
      value: 'Freshman',
    ));
    selectYear.add(DropdownMenuItem(
      child: Text('Sophmore'),
      value: 'Sophmore',
    ));
    selectYear.add(DropdownMenuItem(
      child: Text('Junior'),
      value: 'Junior',
    ));
    selectYear.add(DropdownMenuItem(
      child: Text('Senior'),
      value: 'Senior',
    ));
    selectYear.add(DropdownMenuItem(
      child: Text('Post-bac'),
      value: 'Post-bac',
    ));
    selectYear.add(DropdownMenuItem(
      child: Text('clear'),
      value: 'none',
    ));
  }

  @override
  void initState() {
    loadYear();
    getData().then((snapshot){
      setState(() {
        ss=snapshot;
      });
    });
    super.initState();
  }

  Widget search(query){
    if(ss==null){
      return Center(child: Column(children: <Widget>[Text('loading...')],mainAxisAlignment: MainAxisAlignment.spaceEvenly,),);
    }
    return ListView.builder(
      itemCount: ss.documents.length,
      itemBuilder: (context,i){
        return ListTileTheme(
          child: Container(
            color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 150.0,
                  child: Image.network(ss.documents[i].data['imgurl'].toString(),height: 250, width: 100.0,),),
                Container(child: Column(children: <Widget>[Text(ss.documents[i].data['name']),Text(ss.documents[i].data['major']),Text(ss.documents[i].data['year'])],),),
              ],
            ),

          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('search for users'),),
      body: ListView(
         // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              children: <Widget>[
                  DropdownButton(
                  items: selectYear,
                  hint: selectedYear=='none'?Text('search for a year'):Text(selectedYear),
                  onChanged: (value) {
                    setState(() {
                      selectedYear=value;
                    });
                  },
                ),
                RaisedButton(
                    onPressed: () {
                      print(showSearch);
                      setState(() {
                        showSearch=!showSearch;
                      });
                    }
                ),

      ],
            ),
            Container(

              child:search('murderer'),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/1.5,
            )
          ],
        ),
    );
  }
}



class FilterUsers extends StatefulWidget {
  @override
  _FilterUsers createState() => _FilterUsers();
}

class _FilterUsers extends State<FilterUsers> {
  UserData userData = new UserData();
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

  initState() {
    getData().then((snapshot){
      setState(() {
        ss=snapshot;
      });
    });
    super.initState();
  }

  getData() async{
    return await Firestore.instance.collection('user').where('major', isEqualTo:'murderer').getDocuments();
  }

  Widget search(query){
    if(ss==null){
      return Center(child: Column(children: <Widget>[Text('loading...')],mainAxisAlignment: MainAxisAlignment.spaceEvenly,),);
    }
          return ListView.builder(
              itemCount: ss.documents.length,
              itemBuilder: (context,i){
                return ListTileTheme(
                  child: Container(
                    color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 100.0,
                          height: 150.0,
                          child: Image.network(ss.documents[i].data['imgurl'].toString(),height: 250, width: 100.0,),),
                        Container(child: Column(children: <Widget>[Text(ss.documents[i].data['name']),Text(ss.documents[i].data['major']),Text(ss.documents[i].data['year'])],),),
                      ],
                    ),

                  ),
                );
              },
          );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('query'),),
      body: ss!=null?search('murderer'):Text('loading'),
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
        print('loading ss');
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