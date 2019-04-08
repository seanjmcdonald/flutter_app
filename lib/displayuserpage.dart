import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'logout.dart';

class DisplayUserPage extends StatefulWidget {
  DocumentSnapshot userDocument;
  DisplayUserPage({Key key,this.userDocument}) :super(key:key);
  @override
  _DisplayUserPage createState() => _DisplayUserPage();
}

class _DisplayUserPage extends State<DisplayUserPage> {
  String ss;

  @override
  Widget build(BuildContext context) {
    setState(() {
      ss='${widget.userDocument}';
    });
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.teal
        ),
        backgroundColor: Colors.white,
        title: Text('Profile of '+'${widget.userDocument['name']}',style: TextStyle(color: Colors.teal),),),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height/3,
            child: Image.network('${widget.userDocument['imgurl']}'.toString()),
          ),
          Container(
            alignment: Alignment.center,
            child: Text('${widget.userDocument['name']}',style: TextStyle(fontSize: 40,color: Colors.white),),
          ),
          Container(
            alignment: Alignment.center,
            child: Text('${widget.userDocument['major']}',style: TextStyle(fontSize: 30,color: Colors.white),),
          ),
          Container(
            alignment: Alignment.center,
            child: Text('${widget.userDocument['year']}',style: TextStyle(fontSize: 20,color: Colors.white),),
          ),
          Container(
            alignment: Alignment.center,
            child: Text('Classes Taking: ',style: TextStyle(fontSize: 20,color: Colors.white),),
          ),
          Container(
            height: MediaQuery.of(context).size.height/5,
            child:
          SingleChildScrollView(
            child: Text('${widget.userDocument['classes']}'.replaceAll('[', '').replaceAll(']',''),style: TextStyle(color: Colors.white),),
          ),
          ),
          //Image.network(ss['imgurl']);
        ],
      ),
    );
  }
}