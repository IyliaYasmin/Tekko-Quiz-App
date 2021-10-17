import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tekko/screens/quizInformation/createQuestion/addQuestion.dart';
import 'package:tekko/services/database.dart';
import 'package:random_string/random_string.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//create quiz under certain group 
class CreateQuiz extends StatefulWidget {
  final String groupIdFromGroupList;
  CreateQuiz(this.groupIdFromGroupList);

  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  Database databaseService = new Database();
  final _formKey = GlobalKey<FormState>();

  String quizTitle, quizDesc;

  bool isLoading = false;
  String quizId;

  //for image from camera/gallery
  File _imageFile;
  final _picker = ImagePicker();
  String quizImgUrl = "";
  bool _hasImageUrl = false;

  createQuiz(BuildContext context) {
    quizId = randomAlphaNumeric(16);
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      uploadPic();

      setState(() {
        isLoading = false;
      });

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AddQuestion(quizId, widget.groupIdFromGroupList)));
    }
  }

  Future<String> uploadPic() async {
    if (_hasImageUrl) {
      String fileName = basename(_imageFile.path);

      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;

      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection("groups")
          .doc(widget.groupIdFromGroupList)
          .collection("groupQuiz")
          .doc(quizId)
          .set({
        "id": quizId,
        "quizTitle": quizTitle,
        "quizDesc": quizDesc,
        "quizImgUrl": downloadUrl,
        "imageName": fileName
      });

      print("Done: " + downloadUrl);

      return downloadUrl;
    } else {
      String downloadUrl =
          'https://cuteiphonewallpaper.com/wp-content/uploads/2020/03/Aesthetic-iPhone-Wallpaper-in-HD.jpg';
      String name = "default";

      await FirebaseFirestore.instance
          .collection("groups")
          .doc(widget.groupIdFromGroupList)
          .collection("groupQuiz")
          .doc(quizId)
          .set({
        "id": quizId,
        "quizTitle": quizTitle,
        "quizDesc": quizDesc,
        "quizImgUrl": downloadUrl,
        "imageName": name
      });

      print("Done: " + downloadUrl);

      return downloadUrl;
    }
  }

  _imgFromCamera() async {
    final pickedFile = await _picker.getImage(
        source: ImageSource.camera, imageQuality: 50, maxWidth: 400);

    File imageFile = File(pickedFile.path);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
        _hasImageUrl = true;
      });
    }
  }

  _imgFromGallery() async {
    final pickedFile = await _picker.getImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

    File imageFile = File(pickedFile.path);

    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
        _hasImageUrl = true;
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
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
              "Create Quiz",
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
                  child: CircularProgressIndicator(),
                )
              : Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              _showPicker(context);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.indigo,
                                  child: _imageFile != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.file(
                                            _imageFile,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                          width: 100,
                                          height: 100,
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          validator: (val) => val.isEmpty
                              ? "Please enter the quiz title"
                              : null,
                          decoration: InputDecoration(
                              labelText: "Enter quiz title",
                              hintText: "Quiz Title"),
                          onChanged: (val) {
                            quizTitle = val;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          validator: (val) => val.isEmpty
                              ? "Please enter the quiz description"
                              : null,
                          decoration: InputDecoration(
                              labelText: "Enter quiz description",
                              hintText: "Quiz Description"),
                          onChanged: (val) {
                            quizDesc = val;
                          },
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            createQuiz(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 20),
                            decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              "Create Quiz",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                ),
        ));
  }
}
