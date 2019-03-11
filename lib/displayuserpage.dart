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
      appBar: AppBar(
        title: Text('Profile of '+'${widget.userDocument['name']}'),),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height/3,
            child: Image.network('${widget.userDocument['imgurl']}'.toString()),
          ),
          Container(
            alignment: Alignment.center,
            child: Text('${widget.userDocument['name']}',style: TextStyle(fontSize: 40),),
          ),
          Container(
            alignment: Alignment.center,
            child: Text('${widget.userDocument['major']}',style: TextStyle(fontSize: 30),),
          ),
          Container(
            alignment: Alignment.center,
            child: Text('${widget.userDocument['year']}',style: TextStyle(fontSize: 20),),
          ),
          Container(
            alignment: Alignment.center,
            child: Text('Classes Taken: CINS-465 , CSCI-430',style: TextStyle(fontSize: 20),),
          ),
          Container(
            height: MediaQuery.of(context).size.height/5,
            child:
          SingleChildScrollView(
            child: Text('${widget.userDocument['bio']}'),
          ),
          ),
          //Image.network(ss['imgurl']);
        ],
      ),
    );
  }
}