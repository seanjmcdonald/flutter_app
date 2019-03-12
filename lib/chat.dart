import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:async/async.dart';



class  MessageUsers {
  String groupchatid;
  String toUser;
  String fromUser;

  toJson() {
    return {
      'groupchatid': groupchatid,
      'touser': toUser,
      'fromuser': fromUser,
    };
  }
}

class Chat extends StatefulWidget{

  _Chat createState() => _Chat();
}

class _Chat extends State<Chat> {
  FirebaseUser user;
  String toUser;
  String content;
  String message;
  String type;
  String groupchatid;
  MessageUsers users=MessageUsers();

  /*
  void sendMessage() {
    Firestore.instance.runTransaction((transaction) async {
      var documentReference = Firestore.instance.collection('messages').document(groupchatid).collection(groupchatid).document();
      await transaction.set(
        documentReference,
        {
          'fromUser':user.uid,
          'toUser':toUser,
          'time':DateTime.now().millisecondsSinceEpoch.toString(),
          'content':message,
          'type':type,
        }
      );
    });
  }
  */
  getUser() async {
    FirebaseUser _user= await FirebaseAuth.instance.currentUser();
    setState(() {
      user=_user;
    });
  }


  Widget buildItem(index, data){
    return ListTileTheme(
      child: Container(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            if(user!=null &&data!=null) {
              print('not null');
              if (user.email.hashCode<=data['email'].hashCode){
                print('less thatn');
                setState(() {
                  users.groupchatid=user.email+' '+data['email'];
                  users.toUser=data['email'];
                  users.fromUser=user.email;
                });

              } else {
                setState(() {
                  users.groupchatid=data['email']+' '+user.email;
                  users.toUser=data['email'];
                  users.fromUser=user.email;
                });

              }
            } else {
              print('errer');
            }
            Navigator.push(context, MaterialPageRoute(builder: (context) => TwoPersonChat(object: users)));

          },
          child: Row(
            children: <Widget>[
              Container(
                child: Image.network(data['imgurl'].toString(),width: 75, height: 150,),
              ),
              Container(
                child: Text(data['name']),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget chat(){
    return StreamBuilder(
      stream: Firestore.instance.collection('user').snapshots(),
//      stream: Firestore.instance.collection('messags').document('groupchatid').collection('groupchatid').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)),
          );
        } else {
          return ListView.builder(
            padding: EdgeInsets.all(23.0),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index) => buildItem(index,snapshot.data.documents[index]),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    return Scaffold(
        body: chat(),
    );
  }
}

class TwoPersonChat extends StatefulWidget{
  MessageUsers object;
  TwoPersonChat({Key key, this.object}): super(key:key);
  @override
  _TwoPersonChat createState() => _TwoPersonChat();
}

class _TwoPersonChat extends State<TwoPersonChat> {
  TextEditingController textController= TextEditingController();
  FirebaseUser user;
  FocusNode _focusNode=FocusNode();


  void sendMessage(data) {
    Firestore.instance.runTransaction((transaction) async {
      print('in message');
      var documentReference = Firestore.instance.collection('messages').document('${widget.object.groupchatid}').collection('${widget.object.groupchatid}').document();
      await transaction.set(
          documentReference,
          {
            'fromUser':'${widget.object.fromUser}',
            'toUser':'${widget.object.toUser}',
            'time':DateTime.now().millisecondsSinceEpoch.toString(),
            'content':data.toString(),
          }
      );
      print('message send');
    });
  }

  getUser() async {
    FirebaseUser _user= await FirebaseAuth.instance.currentUser();
    setState(() {
      user=_user;
    });
  }

  Widget get_chat(){
    return StreamBuilder(
      stream: Firestore.instance.collection('messages').document('${widget.object.groupchatid}').collection('${widget.object.groupchatid}').
      orderBy('time',descending: true).limit(100).snapshots(),
//      stream: Firestore.instance.collection('messags').document('groupchatid').collection('groupchatid').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.green)),
          );
        } else {
          var listmessage =snapshot.data.documents;
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index) => buildList(index,snapshot.data.documents[index]),
            reverse: true,
          );
        }
      },
    );
  }

  Widget buildList(index,data){
    return ListTileTheme(
      child: Container(
        padding: EdgeInsets.all(5),
        child: (user.email==data['fromUser'])?Container(padding: EdgeInsets.only(left: 15),child: Text(data['content'],textAlign: TextAlign.left,style: TextStyle(color: Colors.white,fontSize: 20),),):Container(padding: EdgeInsets.only(right: 15),child: Text(data['content'],textAlign: TextAlign.right,style: TextStyle(color: Colors.yellow,fontSize: 20),),),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    return Scaffold(
      //backgroundColor: Colors.blue,
      appBar: AppBar(title: Text('${widget.object.toUser}'),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[

            Flexible(
              flex: 30,
              child:
              Container(
                height: MediaQuery.of(context).size.height/10*10,
                color: Colors.blue,
                child: get_chat(),
              ),
            ),
              Flexible(
                flex: 3,
                child: Row(
                children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height*4/23,
                      width: MediaQuery.of(context).size.width*9/11,
                      color: Colors.red,

                    child: TextField(
                      onTap: ()=> _focusNode.hasFocus,
                        style: TextStyle(fontSize: 20),
                        controller: textController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'type here...',
                        ),
                      ),
                    ),

                      Expanded(
                        child: Container(
                      color: Colors.red,
                      height: MediaQuery.of(context).size.height*4/23,
                      child: IconButton(icon: Icon(Icons.send), onPressed: ()=>sendMessage(textController.text)),
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