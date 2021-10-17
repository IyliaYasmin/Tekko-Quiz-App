import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tekko/services/database.dart';
import 'package:tekko/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tekko/states/currentUser.dart';
import 'package:provider/provider.dart';

class Results extends StatefulWidget {
  final int correct, incorrect, total;
  final String quizId, groupId;
  Results({
    @required this.correct,
    @required this.incorrect,
    @required this.total,
    @required this.groupId,
    @required this.quizId,
  });

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  Database databaseService = new Database();

  uploadMarksData() {
    // String userEmail;
    // String userId;

    // User user = FirebaseAuth.instance.currentUser;

    // if (user != null) {
    //   // Name, email address, and profile photo Url
    //   userEmail = user.email;
    //   userId = user.uid.toString();
    // }

    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String userName = _currentUser.getCurrentUser.fullName;
    String userId = _currentUser.getCurrentUser.uid;
    String userEmail = _currentUser.getCurrentUser.email;

    String correctMarks = "${widget.correct}";
    String incorrectMarks = "${widget.incorrect}";
    String totalQuestion = "${widget.total}";
    String totalMarks = "${widget.correct}/${widget.total}";
    DateTime dateTime = DateTime.now();
    String updatedMarksAt = dateTime.toString();

    Map<String, String> marksMap = {
      "correctMarks": correctMarks,
      "incorrectMarks": incorrectMarks,
      "totalQuestion": totalQuestion,
      "totalMarks": totalMarks,
      "updatedMarksAt": updatedMarksAt,
      "userEmail": userEmail,
      "userId": userId,
      "userName": userName
    };
    print("${widget.quizId}");


    databaseService
        .addMarksData(marksMap, widget.quizId, widget.groupId)
        .then((value) {
      correctMarks = "";
      incorrectMarks = "";
      totalQuestion = "";
      totalMarks = "";
      updatedMarksAt = "";
      userEmail = "";
      userId = "";
      userName = "";
      // setState(() {
      //   isLoading = false;
      // });
    }).catchError((e) {
      print(e);
    });
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
            "End Quiz",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background.jpg"), fit: BoxFit.cover)),
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                "https://i.pinimg.com/originals/a5/e2/8f/a5e28ff43877ba3e823f85be03d908fa.gif",
                height: 250,
                width: 250,
                fit: BoxFit.fitWidth,
              ),
              // SizedBox(height: 2),
              Text(
                "${widget.correct}/${widget.total}",
                style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "You have answered ${widget.correct} answer(s) correctly "
                "and "
                "${widget.incorrect} answer(s) incorrectly!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              FlatButton(
                child: Text("Submit Result"),
                color: Colors.indigo,
                textColor: Colors.white,
                onPressed: () {
                  uploadMarksData();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
