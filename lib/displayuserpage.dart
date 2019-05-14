import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'logout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

/*
https://stackoverflow.com/questions/52547731/tabbarview-with-variable-height-inside-a-listview
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

class DisplayUserPage extends StatefulWidget {
  DocumentSnapshot userDocument;
  DisplayUserPage({Key key,this.userDocument}) :super(key:key);
  @override
  _DisplayUserPage createState() => _DisplayUserPage();
}

class _DisplayUserPage extends State<DisplayUserPage> with SingleTickerProviderStateMixin{
  String ss;
  TabController tabcontroller;
  int currentPage=0;
  FirebaseUser user;
  //FIX change ot init state
  List<bool> toggleCalender= new List(7*12);
  MessageUsers users=MessageUsers();




  @override
  void initState(){
    getUser();
    tabcontroller=TabController(length: 3, vsync: this, initialIndex: 0);
    currentPage=0;
    toggleCalender.fillRange(0, toggleCalender.length, false);
    //getUserExchange();
  }

  Widget showCalender(){
    return availability();
  }

  Widget availability(){
    List<Widget> list=List<Widget>();
    for(int i=0;i<4;i++){
      print("length is "+'${widget.userDocument['availability'][i]}'.toString());
   //   list.add(Text('${widget.userDocument['availability'][0][i]}'.toString()));
    }
    //return Wrap(children: list,);
  }

/*
  Widget showCalender(){
    return Expanded(
      child: Column(
        children: <Widget>[
          daysOfWeek(),
          test('8 am',0),
          test('9 am',1),
          test('10 am',2),
          test('11 am',3),
          test('12 pm',4),
          test('1 pm',5),
          test('2 pm',6),
          test('3 pm',7),
          test('4 pm',8),

        ],
      )
    );
}*/

  Widget test(String hour,int i){
    return Wrap(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width/8,
          child: Text(hour),
        ),        SizedBox(
          width: MediaQuery.of(context).size.width/8,
          child: Text(hour),
        ),
      ],
    );
  }

Widget tests(String hour,int i){
  return Row(
    children: <Widget>[
      SizedBox(
        width: MediaQuery.of(context).size.width/8,
        child: Text(hour),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width/8,
        child: RaisedButton(onPressed: (){
          setState(() {
            toggleCalender[i*7]=!toggleCalender[i*7];
          });
        },color: toggleCalender[i*7]?Colors.red:Colors.blue,),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width/8,
        child: RaisedButton(onPressed: (){
          setState(() {
            toggleCalender[i*7+1]=!toggleCalender[i*7+1];
          });
        },color: toggleCalender[i*7+1]?Colors.red:Colors.blue,),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width/8,
        child: RaisedButton(onPressed: (){
          setState(() {
            toggleCalender[i*7+2]=!toggleCalender[i*7+2];
          });
        },color: toggleCalender[i*7+2]?Colors.red:Colors.blue,),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width/8,
        child: RaisedButton(onPressed: (){
          setState(() {
            toggleCalender[i*7+3]=!toggleCalender[i*7+3];
          });
        },color: toggleCalender[i*7+3]?Colors.red:Colors.blue,),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width/8,
        child: RaisedButton(onPressed: (){
          setState(() {
            toggleCalender[i*7+4]=!toggleCalender[i*7+4];
          });
        },color: toggleCalender[i*7+4]?Colors.red:Colors.blue,),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width/8,
        child: RaisedButton(onPressed: (){
          setState(() {
            toggleCalender[i*7+5]=!toggleCalender[i*7+5];
          });
        },color: toggleCalender[i*7+5]?Colors.red:Colors.blue,),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width/8,
        child: RaisedButton(onPressed: (){
          setState(() {
            toggleCalender[i*7+6]=!toggleCalender[i*7+6];
          });
        },color: toggleCalender[i*7+6]?Colors.red:Colors.blue,),
      ),
    ],
  );
}

  Widget daysOfWeek(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width/8,
          child: Text(''),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width/8,
          child: Text('Mon'),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width/8,
          child: Text('Tue'),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width/8,
          child: Text('Wed'),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width/8,
          child: Text('Thu'),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width/8,
          child: Text('Fri'),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width/8,
          child: Text('Sat'),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width/8,
          child: Text('Sun'),
        ),



      ],
    );
  }

  void setCurrentPage(index){
    setState(() {
      currentPage=index;
    });
  }
  getUser() async {
    FirebaseUser _user= await FirebaseAuth.instance.currentUser();
    setState(() {
      user=_user;
    });
    MessageUsers users=MessageUsers();

  }


  getUserExchange(){
    if (user.email.hashCode<='${widget.userDocument['email']}'.toString().hashCode){
      print('less thatn');
      setState(() {
        users.groupchatid=user.email+' '+'${widget.userDocument['email']}'.toString();
        users.toUser='${widget.userDocument['email']}'.toString();
        users.fromUser=user.email;
      });
    } else {
      setState(() {
        users.groupchatid='${widget.userDocument['email']}'.toString()+' '+user.email;
        users.toUser='${widget.userDocument['email']}'.toString();
        users.fromUser=user.email;
      });
      //Navigator.push(context, MaterialPageRoute(builder: (context) => TwoPersonChat(object: users)));
    }
    print('done with user data');
  }

  Widget chat(){

    //FirebaseUser user;
    String content;
    String message;
    String type;
    String groupchatid;
    MessageUsers users=MessageUsers();


    if (user.email.hashCode<='${widget.userDocument['email']}'.toString().hashCode){
      print('less thatn');
      setState(() {
        users.groupchatid=user.email+' '+'${widget.userDocument['email']}'.toString();
        users.toUser='${widget.userDocument['email']}'.toString();
        users.fromUser=user.email;
      });
    } else {
      setState(() {
        users.groupchatid='${widget.userDocument['email']}'.toString()+' '+user.email;
        users.toUser='${widget.userDocument['email']}'.toString();
        users.fromUser=user.email;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => TwoPersonChat(object: users)));
    }

    return Column(
      children: <Widget>[

      ],
    );
  }

  Widget userPage(){
    return  Column(
      children: <Widget>[
                 Container(
                 padding: EdgeInsets.all(10),
               height: MediaQuery.of(context).size.height/3,
             child: Image.network('${widget.userDocument['imgurl']}'.toString()),
         ),
        Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Text('${widget.userDocument['name']}',style: TextStyle(fontSize: 40,color: Colors.teal),),
        ),
        Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Text('${widget.userDocument['major']}',style: TextStyle(fontSize: 30,color: Colors.teal),),
        ),
        Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Text('${widget.userDocument['year']}',style: TextStyle(fontSize: 20,color: Colors.teal),),
        ),
        Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Text('Classes Taking: ',style: TextStyle(fontSize: 20,color: Colors.teal),),
        ),
        Container(
          height: MediaQuery.of(context).size.height/5,
          child:
          Container(
            alignment: Alignment.center,
            child: Text('${widget.userDocument['classes']}'.replaceAll('[', '').replaceAll(']',''),style: TextStyle(color: Colors.white,fontSize: 25),),
          ),
        )
      ],
    );

  }

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          currentPage==0?userPage():currentPage==1?showCalender():chat(),
        ],
/*              Container(
               // height: 100,
                child:
              TabBar(
                unselectedLabelColor: Colors.black,
                labelColor: Colors.white,
                controller: tabcontroller,
                tabs: <Widget>[
                  Tab(child: Text('User Information'),),
                  Tab(icon: Text('Availability'),),
                  Tab(child:Text(tabcontroller.index.toString()+' hello')),
                ],
              ),
              ),
              */
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.teal,
        currentIndex: currentPage,
        onTap: setCurrentPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('User Information'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            title: Text('Availability'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('message'),
          ),
        ],
      ),
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
          border: Border(top: BorderSide(color: Colors.white,width: 1))
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
    bool fromUser=(user.email!=data['fromUser']);
    return Row(
      children: <Widget>[
        fromUser?Container(child: Image.network(data['imgurl'].toString()),):Container(),
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