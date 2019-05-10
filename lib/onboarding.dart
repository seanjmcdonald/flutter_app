import 'package:flutter/material.dart';
import 'camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Onboarding extends StatefulWidget {
  @override
  _Onboarding createState() => _Onboarding();
}



class Data{
  String name='default';
  String email='default';
  String major='default';
  String year='default';
  String uid='default';
  String imgurl='default';
  List<String> classes= List();


  toJson () {
    return {
      "name":name,
      "email":email,
      "major":major,
      "year":year,
      "uid":uid,
      "imgurl":imgurl,
      "classes":classes,
    };
  }

  fromJson(Map<String, dynamic> parsedJson) {
    return {
      name: parsedJson['name'],
      email: parsedJson['email'],
      major: parsedJson['major'],
      year: parsedJson['year'],
      uid: parsedJson['uid'],
      classes: parsedJson['classes'],
    };
  }

}



class _Onboarding extends State<Onboarding> {
  List<DropdownMenuItem<String>> selectYear = [];
  List<DropdownMenuItem<String>> selectMajor = [];
  final GlobalKey<FormState> _formKey= new GlobalKey<FormState>();
  FirebaseUser user;

  getUser() async {
    FirebaseUser _user= await FirebaseAuth.instance.currentUser();
    setState(() {
      user=_user;
    });
    if(user!=null){
      setState(() {
        data.uid=_user.uid.toString();
        data.email=user.email;
        print("uid is = "+_user.uid.toString());
      });
    }
  }

  alterUserData() {
    Firestore.instance.collection('user').document(data.uid).setData(data.toJson());
  }

  String selectedYear='';
  Data data=Data();
  int currentPage;
  String name,major;
  TextEditingController getname= TextEditingController();
  TextEditingController getclass= TextEditingController();

  TextEditingController getmajor= TextEditingController();
  List<String> classes=[];

  @override
  void initState(){
    getUser();
    currentPage=0;
    loadYear();
  }


  void incrementPage(){
    print(currentPage);

    setState(() {
      ++currentPage;
    });
    print(currentPage);
    print("name = "+ data.name);
    alterUserData();
    print(data.toJson());
    if(currentPage==2){
      user.sendEmailVerification();
    }

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
      value: '',
    ));
  }

  Widget getUserName(){
    return  Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child:
        Column(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('What is your name?',style: TextStyle(color: Colors.white,fontSize: 30),),
            Container(
              width: MediaQuery.of(context).size.width/2,
              child: TextField(
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                controller: getname,
                onChanged: (_){
                  setState(() {
                    name=getname.text;
                    data.name=name;
                  });
                },
              ),
            ),
            RaisedButton(child: Text('Submit'),onPressed: incrementPage,color: Colors.white,),
          ],
        ),),
      ],
    );
  }

  Widget getMajorYear(){
    return  Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('What is your major?',style: TextStyle(color: Colors.white,fontSize: 30)),
              Container(
                width: MediaQuery.of(context).size.width/2,
                child: TextField(
                  style: TextStyle(color: Colors.white,fontSize: 25),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                  controller: getmajor,
                  onChanged: (_){
                    setState(() {
                      major=getmajor.text;
                    });
                  },
                ),
              ),
              Text('What is your year?',style: TextStyle(color: Colors.white,fontSize: 30)),
                  DropdownButton(
                    items: selectYear,
                    hint: selectedYear==''?Text('select your year',style: TextStyle(color: Colors.white,fontSize: 25),):Text(selectedYear,style: TextStyle(color: Colors.white,fontSize: 25),),
                    onChanged: (value) {
                      setState(() {
                        selectedYear=value;
                        data.major=major;
                        data.year=selectedYear;
                      });
                    },
                  ),


              (selectedYear!=''&&major!=null)?RaisedButton(child: Text('Submit',style: TextStyle(color: Colors.teal,)),onPressed: incrementPage):Container(),
            ],
          ),),
      ],
    );
  }

  Widget getPicture(){
    return  CameraApp();
  }
  
  addClass(){
//    final formState=_formKey.currentState;
  String classToAdd=getclass.text.toUpperCase();
    RegExp search=RegExp(r'[A-Z]{4}-?[0-9]{3}[A-Z]{0,1}$');
    if(true==search.hasMatch(classToAdd)) {
      print('here');
      if(!classToAdd.contains('-')){
        print('here');
        classToAdd=classToAdd.substring(0,4)+'-'+classToAdd.substring(4,classToAdd.length);
        print(classToAdd);
      }
      setState(() {
        classes.add(classToAdd);

        getclass.clear();
      });
    } else {
      Fluttertoast.showToast(msg: "A class should look like Class-111",
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black,
        textColor: Colors.teal
      );
    }
  }

  Widget getClasses(){
    return  Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child:
          Column(
           // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('what classes are you taking?',style: TextStyle(color: Colors.white,fontSize: 30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
               // crossAxisAlignment: CrossAxisAlignment.,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width/2,
                    child: TextField(
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white))),
                      key: _formKey,
                      controller: getclass,

                    ),
                  ),
                  RaisedButton(
                    child: Text('Add Class',style: TextStyle(color: Colors.teal,)),
                    color: Colors.white,
                    onPressed: addClass,
                  ),
                ],
              ),

              Expanded(child:showWidgets()),

              RaisedButton(child: Text('Submit'),onPressed: incrementPage),
            ],
          ),),
      ],
    );
  }

  Widget showWidgets(){
    List<Widget> list=List<Widget>();
    for(int i=0;i<classes.length;i++){
      list.add(GestureDetector(onTap: () {

        setState(() {
          classes.removeAt(i);

        });
      }
      ,child:(Container(color:Colors.white,child:Text(classes[i],style: TextStyle(fontSize: 20,color: Colors.teal),))))

      );
    }
    return Row(children: list, mainAxisAlignment: MainAxisAlignment.spaceEvenly,);
  }

  /*
    Widget showWidgets(){
    List<Widget> list=List<Widget>();
    for(int i=0;i<classes.length;i++){
      list.add(Container(child:GestureDetector(onTap: null,child: Dismissible(key: Key(classes[i]), child: Text(classes[i]),
      onDismissed: (_){
        print('here');
        classes.removeAt(i);
        }
      ),
      ),
      ));
    }
    return Column(
        children: list,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    );
  }
   */


  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.teal,
     appBar: AppBar(title: Text('Create an Account',style: TextStyle(color: Colors.teal),),backgroundColor: Colors.white,),
     body:
     currentPage==0?getUserName():
     currentPage==1?getMajorYear():
     currentPage==2?getClasses():
     currentPage==3?getPicture():Container(child: Text('UH OH SOMETHING WENT WRONG'),),
   );
  }
}