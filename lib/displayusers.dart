import 'userobject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:async/async.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String selectedClass='';
  bool showSearch=false;
  TextEditingController searchClass;
  final GlobalKey<FormState> _formKey= new GlobalKey<FormState>();


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
    // return await Firestore.instance.collection('user').where('major', isEqualTo:'murderer').getDocuments();
    return await Firestore.instance.collection('user').getDocuments();
  }

  filterUsers(selectedMajor,selectedClass){
    print(selectedClass);

    getFilteredData( selectedMajor,selectedClass.toString().toUpperCase()).then((snapshot){
      setState(() {
        ss=snapshot;
      });
    });
  }
  getFilteredData(selectedMajor,selectedClass) async{
    if(selectedClass!='' && selectedMajor!=''){
      return await Firestore.instance.collection('user')
          .where('class', isEqualTo: selectedClass)
          .where('major', isEqualTo: selectedMajor).getDocuments();
    }

    if(selectedClass!=''){
      print(selectedClass);
      return await Firestore.instance.collection('user')
          .where('classes',arrayContains: selectedClass.toUpperCase()).getDocuments();
    }

    if(selectedMajor!='') {
      return await Firestore.instance.collection('user').
      where('major', isEqualTo: selectedMajor).getDocuments();
    }
    return await Firestore.instance.collection('user').getDocuments();
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
    return ListView.separated(
      separatorBuilder: (context,index)=> Divider(
        height: 4,
        color: Colors.white,
      ),
      itemCount: ss.documents.length,
      itemBuilder: (context,i){
        return ListTileTheme(
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.teal,


            //           color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0),
            child: GestureDetector(
              onTap: () {
                print('tapped');
                Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayUserPage(userDocument: ss.documents[i])));
              },
              behavior: HitTestBehavior.opaque,
            child: Row(
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 120.0,
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
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.teal,
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(onPressed: _logOut, child: IconButton(color: Colors.teal,icon: Icon(Icons.exit_to_app), onPressed: ()=> _logOut()),),
        ],
        title: Text('Search For Users',style: TextStyle(color: Colors.teal),
        
        ),
      backgroundColor: Colors.white,),
      body: Form(
        key: _formKey,
        child: ListView(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Search For a Course',style: TextStyle(color: Colors.white),),
                Container(
                  alignment: Alignment.centerRight,
                  width: MediaQuery.of(context).size.width/2*1.2,
                  child: TextFormField(
                    controller: searchClass,
                    validator: (val){
                      if(val!=null)
                        print("not null");
                    },
                    onSaved: (val) {
                      setState(() {
                        print('here val is '+val);
                        selectedClass=val;
                      });
                    },
                    decoration: InputDecoration(focusedBorder: UnderlineInputBorder(borderSide:BorderSide(color: Colors.white))),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            RaisedButton(
              color: Colors.white,
                child: Text('Search',style: TextStyle(color: Colors.teal),),
                onPressed: () {
                  //print('the year is '+ searchClass.text);
                 // filterUsers(selectedMajor,selectedClass);
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                     filterUsers(selectedMajor,selectedClass);

                  }
                 // setState(() {
                   // print(searchClass.text);

               //     if(_formKey.currentState.validate()) {
                 //     print('valid');
                   //   _formKey.currentState.save();
                    //}
                    showSearch=!showSearch;
                 // });
                }
            ),
            Container(
              alignment: Alignment.topCenter,
              child:search(selectedClass),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/1.85,
//              height: MediaQuery.of(context).size.height-36-2*24-24-,
            )
          ],
        ),
    ),
    );
  }
}

