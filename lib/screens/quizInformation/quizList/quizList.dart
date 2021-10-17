import 'package:flutter/material.dart';
import 'package:tekko/screens/groupInformation/createGroup/createGroupQr.dart';
import 'package:tekko/screens/quizInformation/playQuiz/quizPlay.dart';
import 'package:tekko/screens/quizInformation/quizList/createQuiz.dart';
import 'package:tekko/services/database.dart';
import 'package:tekko/states/currentUser.dart';
import 'package:provider/provider.dart';

//to display list of quizzes under certain group
class QuizList extends StatefulWidget {
  final String groupIdFromGroupList;
  QuizList(this.groupIdFromGroupList);

  @override
  _QuizListState createState() => _QuizListState();
}

class _QuizListState extends State<QuizList> {
  
  Stream quizStream;
  Database databaseService = new Database();
  List<String> groupLeader;

  Widget quizList(String groupIdFromGroupList) {
    return Container(
      child: StreamBuilder(
        stream: quizStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.data == null
              ? Container(
                  padding: EdgeInsets.all(100),
                  child: Text(
                    "You have no quizzes! Create one today!",
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
                    return QuizTile(
                      noOfQuestions: snapshot.data.docs.length,
                      imageUrl: snapshot.data.docs[index].data()['quizImgUrl'],
                      title: snapshot.data.docs[index].data()['quizTitle'],
                      description: snapshot.data.docs[index].data()['quizDesc'],
                      id: snapshot.data.docs[index].data()['id'],
                      groupID: groupIdFromGroupList,
                    );
                  });
        },
      ),
    );
  }

  @override
  void initState() {

    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    groupLeader = _currentUser.getCurrentUser.groupIdasLeader;
    databaseService.getQuizData(widget.groupIdFromGroupList).then((value) {
      setState(() {
        quizStream = value;
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
                  "Quiz List",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),     
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
                    new FloatingActionButton(
                      heroTag: "btn1",
                    child: Icon(Icons.qr_code_scanner),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  GroupQRCode(widget.groupIdFromGroupList)));}),
                    Expanded(
                      child: ListView(
                          children: <Widget>[
                            quizList(widget.groupIdFromGroupList),
                          ]),
                    ),
                  ],
                )  
                    ),
                     
                 floatingActionButton: Container(
                   child: (groupLeader.contains(widget.groupIdFromGroupList) ) ?  new FloatingActionButton(
                     heroTag: "btn2",
                    child: Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CreateQuiz(widget.groupIdFromGroupList)));
                    },
                    )  : Container()
                 ),
                );
  }
}

class QuizTile extends StatelessWidget {
  final String imageUrl, title, id, description, groupID;
  final int noOfQuestions;



  QuizTile({
    @required this.title,
    @required this.imageUrl,
    @required this.description,
    @required this.id,
    @required this.noOfQuestions,
    @required this.groupID,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizPlay(id, groupID),
            ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        margin: EdgeInsets.all(10),
        height: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                color: Colors.black26,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        description,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
