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
  List<DropdownMenuItem<String>> selectYear = [];

  UserData userData = new UserData();
  DocumentSnapshot ss=null;
  bool changename=false;
  bool changefield=false;
  bool changemajor=false;
  final GlobalKey<FormState>_formKey= new GlobalKey<FormState>();
  String newMajor,newName,newYear,selectedyear;
 //changefield=false;
  //changename=false;

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

  Future<void> changeData() async{
    //check logged in
    Firestore.instance.collection('user').document(userData.uid).setData(userData.toJson()).catchError((e) {
      print(e+ " in changedata");
    });
  }

  getFromFirebase() async {
    final DocumentReference postRef = Firestore.instance.document("user/"+userData.uid);
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if(postSnapshot!=null && postSnapshot.exists) {

        setState(() {
          ss = postSnapshot;
        });
      } else {
        print('errors');
        changeData();
      }
    }).catchError((e){
      print(userData.uid+' uid');
      print(e.toString()+" was caught while calling getFromFirebase");
    });
  }


  setLocal() {
    setState(() {
    userData.name=ss.data['name'];
    userData.major=ss.data['major'];
    userData.year=ss.data['year'];
    userData.imgurl=ss.data['imgurl'];
    });

  }

  getUserInfo() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    if(_user!=null) {
      setState(() {
        userData.uid = _user.uid;
        userData.email = _user.email;
      });
        //setLocal();
        // changeData();
    }
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
    getUserInfo();
    if(userData.uid!='default'){
      getFromFirebase();
    }

    if(ss!=null) {
      setLocal();
    }
    return Scaffold(
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
      body:(ss==null)?Center(child: Column(children: <Widget>[Text('loading...',style: TextStyle(color: Colors.white),)],mainAxisAlignment: MainAxisAlignment.spaceEvenly,),):Stack(
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
                                setState(() {
                                  userData.name=newName;
                                });
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
                    color: Colors.cyan,
                    onPressed: (){
                      loadList();
                      setState(() {
                        changefield=!changefield;
                      });
                    },
                    child: changefield==false?Text('EDIT',style: TextStyle(color: Colors.white),):DropdownButton(
    //value: selectedYear,
    hint: selectedyear==null?Text('Select your year'):Text(selectedyear),
    items: selectYear,
    onChanged: (value) {
      setState(() {
        selectedyear=value;
      });
    },
                  ),
                  ),
                  RaisedButton(
                    child: Text("Submit",style: TextStyle(color: Colors.orange),),
                    onPressed: () {
                    alterUserData('year',selectedyear);
                    setState(() {
                      userData.year=selectedyear;
                    });
                  },),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('major: '+userData.major,
                    style: TextStyle(color: Colors.white),
                  ),
                  FlatButton(
                    child: changemajor==false?Text('EDIT',style: TextStyle(color: Colors.white)):SizedBox(
                      height: 100.0,
                      width: MediaQuery.of(context).size.width/3,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              style: TextStyle(color: Colors.white),
                              validator: (val)=>val==''?val:null,
                              onSaved: (val)=> newMajor=val,
                            ),
                            RaisedButton(
                              color: Colors.orange,
                              child: Text('Submit',style: TextStyle(color: Colors.white),),
                              onPressed: () {
                                saveForm();
                                alterUserData('major',newMajor);
                                setState(() {
                                  userData.major=newMajor;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        changemajor=!changemajor;
                      });
                      print('going for it');
                    },
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
                        Navigator.of(context).pushNamed('/camera');
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