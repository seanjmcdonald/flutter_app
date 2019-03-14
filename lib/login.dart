import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'homescreen.dart';


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

  Widget loadText(){

    return Container(
      padding: EdgeInsets.all(50),
      child:Form(
      key: this._formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            style: TextStyle(color: Colors.white),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration.collapsed(
              hintText: "your email",
             // labelText: "email address",
            ),
            onSaved: (val)=>credentials.email=val,
            validator: (val)=>val==''?val:null,
          ),
          TextFormField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration.collapsed(
              hintText: "your password",
             // labelText: "password",
            ),
            onSaved: (val)=>credentials.password=val,
            validator: (val)=>val==''?val:null,
          ),
        ],
      ),
    ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final Size screenSize=MediaQuery.of(context).size;

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: Text('Login'),
      ),
      backgroundColor: Colors.teal,
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              loadText(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.white,width: 1)
                ),
                width: MediaQuery.of(context).size.width/2,
                height: 50,
                child: new RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40),),
                  child: Text('Sign In',style: TextStyle(color: Colors.white),),
                  color: Colors.teal,
                  onPressed: signIn,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.white,width: 1),
                ),
                width: MediaQuery.of(context).size.width/2,
                height: 50,
                child: new RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  color: Colors.teal,
                  child: Text('Create an account',style: TextStyle(color: Colors.white),),
                  onPressed: () => Navigator.pushNamed(context, '/createaccount'),
                ),
              ),
            ],
          ),
        ],
      ),

      /*
      new Container(
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
                  width: MediaQuery.of(context).size.width/2,
                  child: new RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    child: Text('Sign In'),
                    color: Colors.teal,
                    onPressed: signIn,
                  ),
                ),
                new Container(
                  width: MediaQuery.of(context).size.width*2/3,
                  child: new RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    color: Colors.teal,
                    child: Text('Create an account'),
                    onPressed: () => Navigator.pushNamed(context, '/createaccount'),
                  ),
                ),
              ],
            ),
        ),
      ),
      */
    );
  }
}