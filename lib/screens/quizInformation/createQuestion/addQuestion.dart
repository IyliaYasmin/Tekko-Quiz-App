import 'package:flutter/material.dart';
import 'package:tekko/screens/quizInformation/quizList/quizList.dart';
import 'package:tekko/services/database.dart';

//add question the quiz
class AddQuestion extends StatefulWidget {
  final String quizId;
  final String groupIdFromGroupList;
  AddQuestion(this.quizId, this.groupIdFromGroupList);

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  Database databaseService = new Database();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String question = "",
      option1 = "",
      option2 = "",
      option3 = "",
      option4 = "",
      correctAnswer = "";

  uploadQuizData() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, String> questionMap = {
        "question": question,
        "option1": option1,
        "option2": option2,
        "option3": option3,
        "option4": option4
      };
      print("${widget.quizId}");
      databaseService
          .addQuestionData(
              questionMap, widget.quizId, widget.groupIdFromGroupList)
          .then((value) {
        question = "";
        option1 = "";
        option2 = "";
        option3 = "";
        option4 = "";
        setState(() {
          isLoading = false;
        });
      }).catchError((e) {
        print(e);
      });
    } else {
      print("error is happening ");
    }
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
              "Create Question",
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
          child: isLoading
              ? Container(
                  child: Center(child: CircularProgressIndicator()),
                )
              : Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Expanded(
                            child: ListView(
                              children: [
                                SizedBox(height: 70),
                                TextFormField(
                                  validator: (val) =>
                                      val.isEmpty ? "Please enter your question" : null,
                                  decoration: InputDecoration(
                                      labelText: "Enter your question",
                                      hintText: "Question"),
                                  onChanged: (val) {
                                    question = val;
                                  },
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Column(children: [
                                  TextFormField(
                                    onChanged: (val) {
                                      option1 = val;
                                    },
                                    validator: (val) => val.isEmpty ? "Option1 " : null,
                                    decoration: InputDecoration(
                                        hintText: "Option1 (Correct Answer)"),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    validator: (val) => val.isEmpty ? "Option2 " : null,
                                    decoration: InputDecoration(hintText: "Option2"),
                                    onChanged: (val) {
                                      option2 = val;
                                    },
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    validator: (val) => val.isEmpty ? "Option3 " : null,
                                    decoration: InputDecoration(hintText: "Option3"),
                                    onChanged: (val) {
                                      option3 = val;
                                    },
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    validator: (val) => val.isEmpty ? "Option4 " : null,
                                    decoration: InputDecoration(hintText: "Option4"),
                                    onChanged: (val) {
                                      option4 = val;
                                    },
                                  )
                                ]),
                                SizedBox(
                                  height: 8,
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        uploadQuizData();
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width / 2 - 40,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 20),
                                        decoration: BoxDecoration(
                                            color: Colors.indigo,
                                            borderRadius: BorderRadius.circular(30)),
                                        child: Text(
                                          "Save Question",
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => QuizList(
                                                  widget.groupIdFromGroupList)),
                                        );
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width:
                                            MediaQuery.of(context).size.width / 2 - 20,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 20),
                                        decoration: BoxDecoration(
                                            color: Colors.indigo,
                                            borderRadius: BorderRadius.circular(30)),
                                        child: Text(
                                          "Submit All",
                                          style: TextStyle(
                                              fontSize: 16, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 60,
                                ),
                              ],
                            ),
                          
                        ),
                      ],
                    ),
                  ),
                ),
        ));
  }

}
