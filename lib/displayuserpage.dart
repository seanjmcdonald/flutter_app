import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'logout.dart';

/*
https://stackoverflow.com/questions/52547731/tabbarview-with-variable-height-inside-a-listview
 */

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
  //FIX change ot init state
  List<bool> toggleCalender= new List(7*12);



  @override
  void initState(){
    tabcontroller=TabController(length: 3, vsync: this, initialIndex: 0);
    currentPage=0;
    toggleCalender.fillRange(0, toggleCalender.length, false);
  }



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
        ],
      )
    );
}

Widget test(String hour,int i){
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
            toggleCalender[i*6]=!toggleCalender[i*6];
          });
        },color: toggleCalender[i*6]?Colors.red:Colors.blue,),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width/8,
        child: RaisedButton(onPressed: (){
          setState(() {
            toggleCalender[i*6+1]=!toggleCalender[i*6+1];
          });
        },color: toggleCalender[i*6+1]?Colors.red:Colors.blue,),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width/8,
        child: RaisedButton(onPressed: (){
          setState(() {
            toggleCalender[i*6+2]=!toggleCalender[i*6+2];
          });
        },color: toggleCalender[i*6+2]?Colors.red:Colors.blue,),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width/8,
        child: RaisedButton(onPressed: null),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width/8,
        child: RaisedButton(onPressed: null),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width/8,
        child: RaisedButton(onPressed: null),
      ),

    ],
  );
}

  Widget daysOfWeek(){
    return Row(
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


Widget availRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
      ],
    );
}



Widget calRow(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          child: Text('   '),
        ),
        Container(child:
        Text('Mon'),
          color: Colors.pink,
        ),
        Container(child:
        Text('Tue'),
        ),
        Text('Wed'),
        Text('Th'),
        Text('Fri'),
        Text('Sat'),
        Text('Sun'),
      ],
    );
}

  void setCurrentPage(index){
    setState(() {
      currentPage=index;
    });
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
          showCalender(),
        ],
 //         Container(
   //         padding: EdgeInsets.all(10),
     //       height: MediaQuery.of(context).size.height/3,
       //     child: Image.network('${widget.userDocument['imgurl']}'.toString()),
         // ),
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

          /*

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
          ),


          */

          //Image.network(ss['imgurl']);
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.teal,
        currentIndex: currentPage,
        onTap: setCurrentPage,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('Message'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
          ),
        ],
      ),
    );
  }
}