import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'userobject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homescreen.dart';
import 'onboarding.dart';

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
  bool showPassword=true;
  bool confirmPassword=true;

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
      //setInitUser();
      print('not null');
      Navigator.pushReplacement(context,new MaterialPageRoute(builder: (context)=> Onboarding()));

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
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.teal,
      appBar: AppBar(title: Text('Create An Account'),
      backgroundColor: Colors.teal,),
      body: Stack(
        children: <Widget>[
          Form(
          key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.symmetric(vertical: 40)),
                Padding(

                  padding: EdgeInsets.symmetric(vertical: 5),
                  child:
                TextFormField(decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white)
                  ),
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white,),
                ),
                  style: TextStyle(color: Colors.white),
                  onSaved: (val)=>email=val,
                  validator: (val)=>val==''?'Email can\'t be empty':null,
                ),
                ),
Row(children: <Widget> [
                Flexible(
                  child:
                TextFormField(decoration: InputDecoration(
                    labelText: 'Password',
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    labelStyle: TextStyle(
                        color: Colors.white
                    ),
                ),
                  style: TextStyle(color: Colors.white),
                  obscureText: showPassword,
                  onSaved: (val)=>password=val,
                  validator: (val)=>val==''?'Password can\'t be empty':null,
                ),
    ),
                IconButton(icon: Icon(Icons.remove_red_eye,color: Colors.white,),onPressed: (){
                  setState(() {
                    showPassword=!showPassword;
                  });
                },)
                ],
),
                Row(
                 children: <Widget> [
                  Flexible(child:
                  TextFormField(decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),),
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(
                        color: Colors.white
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                  obscureText: confirmPassword,
                  validator: (val)=>val=='' && val!=password?'Passwords must match':null,
                  ),
                  ),
                   IconButton(icon: Icon(Icons.remove_red_eye,color: Colors.white,),onPressed: (){
                     setState(() {
                       confirmPassword=!confirmPassword;
                     });
                   },)
                  ],
                  



    ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child:
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.white,
                  ),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  child: Text('Create Account'),onPressed: _submit,color: Colors.teal,
                ),
    ),
    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}