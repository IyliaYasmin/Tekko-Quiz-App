import 'package:flutter/material.dart';
import 'package:tekko/models/question.dart';
import 'package:tekko/screens/quizInformation/quizPlayWidgets.dart';
import 'package:tekko/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizPlay2 extends StatefulWidget {

  final String quizId, groupId;
  QuizPlay2(this.quizId, this.groupId);

  @override
  _QuizPlay2State createState() => _QuizPlay2State();
}

int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;
int total = 0;

class _QuizPlay2State extends State<QuizPlay2> {
  
  Database databaseService = new Database(); 
  QuerySnapshot questionsSnapshot; 

  QuestionModel getQuestionModelFromDatasnapshot(
      DocumentSnapshot questionSnapshot) {
    QuestionModel questionModel = new QuestionModel();

    questionModel.question = questionSnapshot.data()["question"];

    /// shuffling the options  
    List<String> options = [
      questionSnapshot.data()["option1"],
      questionSnapshot.data()["option2"],
      questionSnapshot.data()["option3"],
      questionSnapshot.data()["option4"]
    ];
    options.shuffle();

    questionModel.option1 = options[0];
    questionModel.option2 = options[1];
    questionModel.option3 = options[2];
    questionModel.option4 = options[3];
    questionModel.correctOption = questionSnapshot.data()["option1"];
    questionModel.answered = false;

    print(questionModel.correctOption.toLowerCase());

    return questionModel;
  }

  @override
  void initState() {
    print("${widget.quizId}");
    databaseService.getQuestionData(widget.quizId, widget.groupId).then((value){
      questionsSnapshot = value;
      _notAttempted = 0;
      _correct = 0;
      _incorrect = 0;
      total = questionsSnapshot.docs.length;

      print("$total this is total");

      setState((){

      });
    });
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Questions"),
      ),
      body: Container(
        child: Column(children: [
           questionsSnapshot.docs == null ?
               Container(
                 child: Text("No Data"),
               ):
               ListView.builder(
                 shrinkWrap: true,
                 physics: ClampingScrollPhysics(),
                 itemCount: questionsSnapshot.docs.length,
                 itemBuilder: (context, index){
                   return QuizPlayTile(
                     questionModel: getQuestionModelFromDatasnapshot(
                                    questionsSnapshot.docs[index]),
                      index: index,
                   );   
                 }
               )
        ],)
      )
    );
  }
}

class QuizPlayTile extends StatefulWidget {
  final QuestionModel questionModel;
  final int index;
  QuizPlayTile({this.questionModel, this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {

  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        Text(widget.questionModel.question),
        SizedBox(height: 4),
        OptionTile(
          correctAnswer: widget.questionModel.option1,
          description: widget.questionModel.option1,
          option: "A",
          optionSelected: optionSelected,
        ),
        SizedBox(height: 4),
        OptionTile(
          correctAnswer: widget.questionModel.option1,
          description: widget.questionModel.option2,
          option: "B",
          optionSelected: optionSelected,
        ),
        SizedBox(height: 4),
        OptionTile(
          correctAnswer: widget.questionModel.option1,
          description: widget.questionModel.option3,
          option: "C",
          optionSelected: optionSelected,
        ),
        SizedBox(height: 4),
        OptionTile(
          correctAnswer: widget.questionModel.option1,
          description: widget.questionModel.option4,
          option: "D",
          optionSelected: optionSelected,
        ),
      ])
    );
  }
}