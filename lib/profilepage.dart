import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'userobject.dart';
import 'main.dart';
import 'camera.dart';

class Profile extends StatefulWidget{

  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  //FirebaseUser user;
  UserData userData = new UserData();
  DocumentSnapshot ss;
  bool changename;
  final GlobalKey<FormState> _formKey= new GlobalKey<FormState>();
  String newName;

  @override
  initState(){
    //fix to not get all data
    changename=false;
    getUserInfo();
    super.initState();
  }


  Future<void> changeData() async{
    //check logged in
    Firestore.instance.collection('user').document(userData.uid).setData(userData.toJson()).catchError((e) {
      print(e);
    });
  }



  getFromFirebase() async {
    final DocumentReference postRef = Firestore.instance.document("user/"+userData.uid);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if(postSnapshot.exists) {
//        if(postSnapshot!=null) {
        setState(() {
          ss = postSnapshot;
        });
      } else {
        print('no data');
        print(userData.uid);
        changeData();
      }
    });
  }


  setLocal() {
    userData.name=ss.data['name'];
    userData.major=ss.data['major'];
    userData.year=ss.data['year'];
    userData.imgurl=ss.data['imgurl'];
  }

  getUserInfo() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    if(_user!=null) {
      setState(() {
        userData.uid = _user.uid;
        userData.email = _user.email;
        print(_user.uid);
        getFromFirebase();
        //setLocal();
        // changeData();
      });
    }
  }

  changeName() {
    Firestore.instance.collection('user').document(userData.uid).updateData({"name": 'NEW NAME BOYS'});
  }

  alterUserData(name,newName) {
    Firestore.instance.collection('user').document(userData.uid).updateData({name:newName});
  }

  saveForm(){
    final formState=_formKey.currentState;
    //FIX validate
    if(formState.validate()) {
      formState.save();
      print('saved form');
    }

  }


  @override
  Widget build(BuildContext context) {
    //fix??
    setLocal();
    return new Scaffold(
      resizeToAvoidBottomPadding: false,

      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.account_circle),
            onPressed: () {
            print('pressed edit');
              Navigator.pushNamed(context, '/EditProfile');
            },
          ),

        ],
        title: Text('user profile'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(400.0),
                bottomLeft: Radius.circular(400.0),
              )
            ),
          ),
          Center(



            child: ListView(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('email: '+userData.email,
                    style: TextStyle(color: Colors.white),
                  ),
                  FlatButton(
                    onPressed: null,
                    child: Text('EDIT',style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('name: '+userData.name,
                    style: TextStyle(color: Colors.white),
                  ),
                  FlatButton(
                    child: changename==false?Text('EDIT',style: TextStyle(color: Colors.white)):SizedBox(
                      height: 100.0,
                      width: MediaQuery.of(context).size.width/3,
                      child: Form(
                        key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            style: TextStyle(color: Colors.white),
                            validator: (val)=>val==''?val:null,
                            onSaved: (val)=> newName=val,
                          ),
                          RaisedButton(
                            color: Colors.orange,
                              child: Text('Submit',style: TextStyle(color: Colors.white),),
                              onPressed: () {
                                saveForm();
                                alterUserData('name',newName);  
                              },
                          ),
                        ],
                      ),
                    ),
                    ),
                    onPressed: () {
                      setState(() {
                       changename=!changename;
                      });
                      print('going for it');
                  changeName();
                  },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('year: '+userData.year,
                    style: TextStyle(color: Colors.white),
                  ),
                  FlatButton(
                    onPressed: null,
                    child: Text('EDIT',style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('major: '+userData.major,
                    style: TextStyle(color: Colors.white),
                  ),
                  FlatButton(
                    onPressed: null,
                    child: Text('EDIT',style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.network(userData.imgurl,height: MediaQuery.of(context).size.height/4, width: MediaQuery.of(context).size.width/3*2),
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        Navigator.of(context).pushNamedAndRemoveUntil('/camera', (Route<dynamic> route)=> false);

                      });
            },
                    child: Text('EDIT',style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ],
          ),
            ),
        ],
      ),
    );
  }
}

class EditProfile extends StatefulWidget {
  @override
  _EditProfile createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  List<DropdownMenuItem<String>> selectYear = [];
  String selectedYear;

  loadList(){
    selectYear.add(DropdownMenuItem(
      child: Text('Freshman'),
      value: 'freshman',
    ));
    selectYear.add(DropdownMenuItem(
      child: Text('Sophmore'),
      value: 'sophmore',
    ));
    selectYear.add(DropdownMenuItem(
      child: Text('Junior'),
      value: 'junior',
    ));
    selectYear.add(DropdownMenuItem(
      child: Text('Senior'),
      value: 'senior',
    ));
    selectYear.add(DropdownMenuItem(
      child: Text('Post-bac'),
      value: 'postbac',
    ));
  }

  @override
  void initState() {
    loadList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile'),
      backgroundColor: Colors.blue,),
      body: Form(
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width-20,
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Name'),
                  SizedBox(
                    height: 23.0,
                    width: MediaQuery.of(context).size.width/3,
                    child: TextFormField(
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Year'),
              DropdownButton(
                //value: selectedYear,
                hint: selectedYear==null?Text('Select your year'):Text(selectedYear),
                  items: selectYear,
                  onChanged: (value) {
                    setState(() {
                      selectedYear=value;
                    });
              }
              ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Major'),
                  Text('new name'),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}