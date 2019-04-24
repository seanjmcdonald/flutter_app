import 'package:flutter/material.dart';
import 'camera.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  String selectedYear='';
  Data data;
  int currentPage;
  String name,major;
  TextEditingController getname= TextEditingController();
  TextEditingController getclass= TextEditingController();

  TextEditingController getmajor= TextEditingController();
  List<String> classes=[];

  @override
  void initState(){
    currentPage=0;
    loadYear();
  }

  void incrementPage(){
    print(currentPage);

    setState(() {
      ++currentPage;
    });
    print(currentPage);
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
            Text('What is your name?'),
            Container(
              width: MediaQuery.of(context).size.width/2,
              child: TextField(
                controller: getname,
                onChanged: (_){
                  setState(() {
                    name=getname.text;
                  });
                },
              ),
            ),
            RaisedButton(child: Text('Submit'),onPressed: null),
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
              Text('What is your major?'),
              Container(
                width: MediaQuery.of(context).size.width/2,
                child: TextField(
                  controller: getmajor,
                  onChanged: (_){
                    setState(() {
                      major=getmajor.text;
                    });
                  },
                ),
              ),
              Text('What is your year?'),
                  DropdownButton(
                    items: selectYear,
                    hint: selectedYear==''?Text('select your year',style: TextStyle(color: Colors.black),):Text(selectedYear,style: TextStyle(color: Colors.black),),
                    onChanged: (value) {
                      setState(() {
                        selectedYear=value;
                      });
                    },
                  ),


              (selectedYear!=''&&major!=null)?RaisedButton(child: Text('Submit'),onPressed: null):Container(),
            ],
          ),),
      ],
    );
  }

  Widget getPicture(){
    return  Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text('What is your name?'),
              Container(
                width: MediaQuery.of(context).size.width/2,
                child: TextField(
                  controller: getname,
                  onChanged: (_){
                    setState(() {
                      name=getname.text;
                    });
                  },
                ),
              ),
              RaisedButton(child: Text('Submit'),onPressed: null),
            ],
          ),),
      ],
    );
  }
  
  addClass(){
//    final formState=_formKey.currentState;
  String classToAdd=getclass.text.toUpperCase();
    RegExp search=RegExp(r'[A-Z]{4}-{0,1}[0-9]{3}[A-Z]{0,1}$');
    if(true==search.hasMatch(classToAdd)) {
      print('here');
      if(!classToAdd.contains('-')){
        print('here');
        classToAdd=classToAdd.substring(0,3)+'-'+classToAdd.substring(4,classToAdd.length);
        print(classToAdd);
      }
      setState(() {
        classes.add(classToAdd);

        getclass.clear();
      });
    } else {
      Fluttertoast.showToast(msg: "A class should look like SMPL-111",
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
        textColor: Colors.white
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
              Text('what classes are you taking?'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
               // crossAxisAlignment: CrossAxisAlignment.,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width/2,
                    child: TextField(
                      key: _formKey,
                      controller: getclass,

                    ),
                  ),
                  RaisedButton(
                    child: Text('Add Class'),
                    color: Colors.teal,
                    onPressed: addClass,
                  ),
                ],
              ),

              Expanded(child:showWidgets()),

              RaisedButton(child: Text('Submit'),onPressed: null),
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
      ,child:(Container(color:Colors.red,child:Text(classes[i],style: TextStyle(fontSize: 20),))))

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
     appBar: AppBar(title: Text('Create an Account'),),
     body: getClasses(),
   );
  }
}