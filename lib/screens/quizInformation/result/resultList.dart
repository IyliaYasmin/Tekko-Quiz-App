import 'package:flutter/material.dart';
import 'package:tekko/screens/groupInformation/groupList/groupBottomNavigation.dart';
import 'package:tekko/services/database.dart';

class ResultList extends StatefulWidget {
  String groupId, quizId;
  ResultList(this.groupId, this.quizId);

  @override
  _ResultListState createState() => _ResultListState();
}

class _ResultListState extends State<ResultList> {

    
  Stream resultStream;
  Database databaseService = new Database();

  Widget resultList(String groupId, String quizId) {
    return Container(
      child: StreamBuilder(
        stream: resultStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.data == null
              ? Container(
                  padding: EdgeInsets.all(100),
                  child: Text(
                    "No submission made for this quiz",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.black54,
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return ResultTile(
                      totalMarks: snapshot.data.docs[index].data()['totalMarks'],
                      userEmail: snapshot.data.docs[index].data()['userEmail'],
                      userName: snapshot.data.docs[index].data()['userName'],
                    );
                  });
        },
      ),
    );
  }

  @override
  void initState() {

    databaseService.getResultData(widget.groupId, widget.quizId).then((value) {
      setState(() {
        resultStream = value;
      });
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    
        return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.purple[300],
              elevation: 0.0,
              title: Center(
                child: Text(
                  "Result List",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ), 
                      actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 2.0),
                child: IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                  Navigator.pushReplacement(
                  context,
                   MaterialPageRoute(
                     builder: (context) => GroupNavigation()
        ),
      );
                  },
                )),
          ],    
            ),
            body: Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/background.jpg"),
                        fit: BoxFit.cover)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.values[0],
                  children: [
                    Expanded(
                      child: ListView(
                          children: <Widget>[
                            resultList(widget.groupId, widget.quizId),
                          ]),
                    ),
                  ],
                )  
                    ),
                );
  }
}

class ResultTile extends StatelessWidget {
  final String totalMarks, userEmail, userName;



  ResultTile({
    @required this.totalMarks,
    @required this.userEmail,
    @required this.userName
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
        padding: EdgeInsets.symmetric(horizontal: 2),
        margin: EdgeInsets.symmetric(horizontal: 10),
        height: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Stack(
            children: [
              Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text( "Email: " +
                        userEmail,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      Text( "Name: " +
                        userName,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      Text( "Total Marks: " +
                        totalMarks,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
    );
  }
}