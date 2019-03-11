import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'homescreen.dart';
import 'createuser.dart';
import 'main.dart';

class loginData{
  String email='';
  String password='';
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => new _LoginPage();
}

class _LoginPage extends State<LoginPage> {

  final GlobalKey<FormState> _formKey= new GlobalKey<FormState>();
  final loginData credentials=new loginData();
  final FirebaseAuth auth=FirebaseAuth.instance;


  Future<void> signIn() async{
    final formState=_formKey.currentState;
    if(formState.validate()){
      formState.save();
      try{
        FirebaseUser user=
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: credentials.email, password: credentials.password);
        assert(user!=null);
        assert(await user.getIdToken()!=null);
        assert(FirebaseAuth.instance.currentUser() != null);
        Navigator.pushReplacement(context,new MaterialPageRoute(builder: (context)=> new HomeScreen()));

      } catch(e){
        print(e.message);
        // return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize=MediaQuery.of(context).size;

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('login'),
      ),
      body: new Container(
        width: screenSize.width,
        padding: EdgeInsets.all(20.0),
        //width: screenSize.width,
        child: new Form(
          key: this._formKey,
            child: new ListView(
              children: <Widget>[
                new TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "your email",
                    labelText: "email address",
                  ),
                  onSaved: (val)=>credentials.email=val,
                  validator: (val)=>val==''?val:null,
                ),
                new TextFormField(
                  decoration: InputDecoration(
                    hintText: "your password",
                    labelText: "password",
                  ),
                  onSaved: (val)=>credentials.password=val,
                  validator: (val)=>val==''?val:null,
                ),
                new Container(
                  width: screenSize.width,
                  child: new RaisedButton(
                    child: Text('Sign In'),
                    onPressed: signIn,
                  ),
                ),
                new Container(
                  width: screenSize.width,
                  child: new RaisedButton(
                    child: Text('Create an account'),
                    onPressed: () => Navigator.pushNamed(context, '/createaccount'),
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }
}