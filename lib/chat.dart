import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login.dart';


/*
https://medium.com/flutter-community/building-a-chat-app-with-flutter-and-firebase-from-scratch-9eaa7f41782e
 */


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
       // margin: EdgeInsets.fromLTRB(32,0,0,0),
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
           // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                //padding: EdgeInsets.only(left: 5),
                child: Image.network(data['imgurl'].toString(),width: 100, height: 150,),
              ),
      Padding(padding: EdgeInsets.only(left: 50),
        child:
              Center(
                child: Text(data['name'],style: TextStyle(color: Colors.white,fontSize: 20),),
              ),
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
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.teal)),
          );
        } else {
          return Container(
            color: Colors.teal,
          child: ListView.separated(
            separatorBuilder: (context,index)=> Divider(
              height: 4,
              color: Colors.white,
            ),
            padding: EdgeInsets.all(0),
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index) => buildItem(index,snapshot.data.documents[index]),
          ),
          );
        }
      },
    );
  }

  Future<LoginPage>_logOut() async{
    await FirebaseAuth.instance.signOut().then((_){
      Navigator.of(context).pushNamedAndRemoveUntil('/login',(Route<dynamic> route) => false);
    });
    return LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    return Scaffold(
      appBar: AppBar(title: Text('Message Users',style: TextStyle(color: Colors.teal)),centerTitle: true,backgroundColor: Colors.white,
      actions: <Widget>[
        IconButton(color: Colors.teal,icon: Icon(Icons.exit_to_app), onPressed: ()=> _logOut()),
      ],
      ),
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


  void sendMessage(data) {

    if (data.trim()!='') {
      textController.clear();

      Firestore.instance.runTransaction((transaction) async {
        print('in message');
        var documentReference = Firestore.instance.collection('messages')
            .document('${widget.object.groupchatid}').collection(
            '${widget.object.groupchatid}')
            .document();
        await transaction.set(
            documentReference,
            {
              'fromUser': '${widget.object.fromUser}',
              'toUser': '${widget.object.toUser}',
              'time': DateTime
                  .now()
                  .millisecondsSinceEpoch
                  .toString(),
              'content': data.toString(),
            }
        );
        print('message send');
      });
    } else {
      Fluttertoast.showToast(msg: 'Enter a Message!');
    }
  }

  getUser() async {
    FirebaseUser _user= await FirebaseAuth.instance.currentUser();
    setState(() {
      user=_user;
    });
  }

  Widget chat_bar(){
    return Container(
      height: 50,
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(

        color: Colors.teal,
        border: Border(top: BorderSide(color: Colors.blueGrey,width: 1))
      ),
      child: Row(
        children: <Widget>[
          Material(
            child: Container(
              height: 50,
              color: Colors.red,
              child: IconButton(icon: Icon(Icons.image), onPressed: null),
            ),
          ),
          Flexible(
            child: Container(
              height: 50,
              alignment: Alignment.center,
              child: TextField(
                controller: textController,
                decoration: InputDecoration.collapsed(
                  border: InputBorder.none,
                  hintText: 'Type a message here',
                ),
              ),
            ),
          ),
          Material(
            child: Container(
              color: Colors.red,
              child: IconButton(icon: Icon(Icons.send), onPressed: () =>sendMessage(textController.text)),
            ),
          ),
        ],
      ),
    );
  }

  Widget get_chat(){
    return Flexible(child:StreamBuilder(
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
    ),);
  }


  Widget buildList(index,data){
    bool fromUser=(user.email==data['fromUser']);
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(0),color:fromUser?Colors.teal:Colors.black),
          child: (fromUser)
              ?Container(padding: EdgeInsets.only(left: 15),child: Text(data['content'],textAlign: TextAlign.left,style
              :TextStyle(color: Colors.white,fontSize: 20),),):Container(padding: EdgeInsets.only(right:5),child: Text(data['content'],textAlign: TextAlign.right,style: TextStyle(color: Colors.teal,fontSize: 20),),),
        ),
      ],
   //     padding: EdgeInsets.all(5),
     //   width: 20,
       // decoration: BoxDecoration(borderRadius: BorderRadius.circular(70),color: Colors.yellow),
        //child: (user.email==data['fromUser'])?Container(padding: EdgeInsets.only(left: 15),child: Text(data['content'],textAlign: TextAlign.left,style: TextStyle(color: Colors.white,fontSize: 20),),):Container(padding: EdgeInsets.only(right:5),child: Text(data['content'],textAlign: TextAlign.right,style: TextStyle(color: Colors.yellow,fontSize: 20),),),
    );
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: Text('${widget.object.toUser}',style: TextStyle(color: Colors.teal),),
        backgroundColor: Colors.white,
        iconTheme:IconThemeData(color: Colors.teal),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              get_chat(),
              chat_bar(),

            ],
          ),
        ],
      ),
    );
  }
}