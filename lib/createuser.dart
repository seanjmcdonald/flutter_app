import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'userobject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'userobject.dart';
import 'home.dart';

class CreateAccountWithEmail{
  Future<FirebaseUser> createSignIn(email,password){
    // final FirebaseUser newUser= await auth.createUserWithEmailAndPassword(email: email, password: password);
  }
}

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPage createState() => _CreateAccountPage();
}


class _CreateAccountPage extends State<CreateAccountPage> {
  String email,password;
  UserData userData;
  static final GlobalKey<FormState> _formKey= new GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  void _submit(){
    //print(_email);
    // print('please meail it is '+_email);
    //return;
    final form=_formKey.currentState;
    if(form.validate()){
      form.save();
      // print('user email to add is '+_email);
      //userData.email=email;
      createSignIn(email,password);
    }
  }

  //not signed in here
  setInitUser() async{
    //check logged in
    Firestore.instance.collection('user').document(userData.uid).setData(userData.toJson()).catchError((e) {
      print(e);
    });
  }

  Future<void> createSignIn(String email,String pass) async{
    final newUser= await auth.createUserWithEmailAndPassword(email: email, password: pass);
    auth.signInWithEmailAndPassword(email: email, password: pass);
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    if(auth!=null && _user!=null){
      print('please');
      setState(() {

        userData.email=email;
        userData.uid=_user.uid;
      });

      setInitUser();
      print('not null');
      Navigator.pushNamed(context, '/');
  }
    /*
    assert(newUser!=null);
    assert(await newUser.getIdToken()!=null);

    await newUser.sendEmailVerification();

    await newUser.reload();
    return newUser;
  */

  }



  @override
  Widget build(BuildContext context) {
    // final Size screenSize=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Create an account'),),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(decoration: InputDecoration(labelText: 'email'),
                onSaved: (val)=>email=val,
                validator: (val)=>val==''?'email can\'t be empty':null,
              ),
              TextFormField(decoration: InputDecoration(labelText: 'password'),
                onSaved: (val)=>password=val,
                validator: (val)=>val==''?'major can\'t be empty':null,
              ),
              TextFormField(decoration: InputDecoration(labelText: 'confirm password'),
                validator: (val)=>val=='' && val!=password?'year can\'t be empty':null,
              ),
              RaisedButton(child: Text('Create account'),onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}