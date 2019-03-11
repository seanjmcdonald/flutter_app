import 'userobject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:async/async.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'displayuserpage.dart';
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
  String selectedYear='';
  String selectedMajor='';
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

  Future<LoginPage>_logOut() async{
    await FirebaseAuth.instance.signOut().then((_){
      Navigator.of(context).pushNamedAndRemoveUntil('/login',(Route<dynamic> route) => false);
    });
    return LoginPage();
  }

  getData() async{
    return await Firestore.instance.collection('user').where('major', isEqualTo:'murderer').getDocuments();
  }

  filterUsers(selectedYear,selectedMajor){
    getFilteredData(selectedYear, selectedMajor).then((snapshot){
      setState(() {
        ss=snapshot;
      });
    });
  }

  getFilteredData(selectedYear,selectedMajor) async{
    if(selectedMajor!='' && selectedYear!=''){
      return await Firestore.instance.collection('user').where('year', isEqualTo:selectedYear).where('major',isEqualTo: selectedMajor).getDocuments();

    }
    if(selectedYear!='') {
      return await Firestore.instance.collection('user').where('year', isEqualTo: selectedYear).getDocuments();
    }
    if(selectedMajor!='') {
      return await Firestore.instance.collection('user').where('major', isEqualTo: selectedMajor).getDocuments();
    }

    else {
      return await Firestore.instance.collection('user').getDocuments();

    }

  }

  //getFilteredData(category,value) async{
  //  return await Firestore.instance.collection('user').where(category, isEqualTo:value).getDocuments();
//  }

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
      value: '',
    ));
  }

  loadMajor(){
    selectMajor.add(DropdownMenuItem(
      child: Text('Computer Science'),
      value: 'Computer Science',
    ));
    selectMajor.add(DropdownMenuItem(
      child: Text('Math'),
      value: 'Math',
    ));
    selectMajor.add(DropdownMenuItem(
      child: Text('Murderer'),
      value: 'Murderer',
    ));
    selectMajor.add(DropdownMenuItem(
      child: Text('Princess'),
      value: 'Princess',
    ));
    selectMajor.add(DropdownMenuItem(
      child: Text('Computer Information Systems'),
      value: 'Computer Information Systems',
    ));
    selectMajor.add(DropdownMenuItem(
      child: Text('Math'),
      value: 'Math',
    ));
    selectMajor.add(DropdownMenuItem(
      child: Text('clear'),
      value: '',
    ));
  }

  @override
  void initState() {
    loadYear();
    loadMajor();
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
            width: MediaQuery.of(context).size.width,
            color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0),
            child: GestureDetector(
              onTap: () {
                print('tapped');
                Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayUserPage(userDocument: ss.documents[i])));
              },
              behavior: HitTestBehavior.opaque,
            child: Row(
             // crossAxisAlignment: CrossAxisAlignment.center,

              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 150.0,
                  child: Image.network(ss.documents[i].data['imgurl'].toString(),height: 250, width: 100.0,),),
                Container(
                  width: MediaQuery.of(context).size.width-100,
                  alignment: Alignment.center,
                  child: Column(children: <Widget>[
                    Text(ss.documents[i].data['name'],textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 35),),
                    Text(ss.documents[i].data['major'],textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 25),),
                    Text(ss.documents[i].data['year'],textAlign: TextAlign.center,style: TextStyle(color: Colors.grey,fontSize: 25),)],),),
              ],
            ),
          ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(onPressed: _logOut, child: Text('sign out',style: TextStyle(color: Colors.black),)),
        ],
        title: Text('search for users',style: TextStyle(color: Colors.lightBlue),),
      backgroundColor: Colors.white,),
      body: ListView(
         // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              children: <Widget>[
                DropdownButton(
                  items: selectMajor,
                  hint: selectedMajor==''?Text('search for a major',style: TextStyle(color: Colors.white),):Text(selectedMajor,style: TextStyle(color: Colors.white),),
                  onChanged: (value) {
                    setState(() {
                      selectedMajor=value;
                    });
                  },
                ),

              ],
            ),
            Row(
              children: <Widget>[
                DropdownButton(
                  items: selectYear,
                  hint: selectedYear==''?Text('search for a year',style: TextStyle(color: Colors.white),):Text(selectedYear,style: TextStyle(color: Colors.white),),
                  onChanged: (value) {
                    setState(() {
                      selectedYear=value;
                    });
                  },
                ),

              ],
            ),
            RaisedButton(

              color: Colors.black,
                child: Text('Search',style: TextStyle(color: Colors.white),),
                onPressed: () {
                  filterUsers(selectedYear, selectedMajor);
                  print('the year is '+selectedMajor);
                  setState(() {
                    showSearch=!showSearch;
                  });
                }
            ),
            Container(
              alignment: Alignment.topCenter,
              child:search(selectedYear),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/1.85,
//              height: MediaQuery.of(context).size.height-36-2*24-24-,
            )
          ],
        ),
    );
  }
}

