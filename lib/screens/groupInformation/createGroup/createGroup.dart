import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:tekko/screens/groupInformation/createGroup/createGroupQr.dart';
import 'package:tekko/services/database.dart';
import 'package:tekko/states/currentUser.dart';
import 'package:tekko/widgets/container.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  
  //for image from camera/gallery
  File _imageFile;
  final _picker = ImagePicker();
  bool _hasImageUrl = false;
  String groupImage;

   void _createGroup(BuildContext context, String groupName) async {
      
      if (_hasImageUrl) {
      String fileName = basename(_imageFile.path);

      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;

      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      if (downloadUrl != null) {
        groupImage = downloadUrl;
      }

      print("Done: " + groupImage);
    } else {
      String downloadUrl =
          'https://cuteiphonewallpaper.com/wp-content/uploads/2020/03/Aesthetic-iPhone-Wallpaper-in-HD.jpg';

      groupImage = downloadUrl;

      print("Done: " + groupImage);
    }

     //submit new group info to firebase
     CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
     String _returnString = await Database().createGroup(groupName, _currentUser.getCurrentUser.uid, groupImage);

     
       Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(
          builder: (context)=> GroupQRCode(_returnString),
          ),
          (route) => false);
     
    }
    
    //get image from camera
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
  

  //get image from gallery
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

  TextEditingController _groupNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.purple[300],
          elevation: 0.0,
          title: Center(
            child: Text(
              "Create Group",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Expanded(
              child: Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/background.jpg"),
                        fit: BoxFit.cover)),
              child: ListView(
                  children: <Widget>[
                    Image.network(
                      "https://images.squarespace-cdn.com/content/v1/5d7bd675b95d9b3bf482a2e2/1585769822469-DYS3O5LZ0WNN0KYRJTRM/ke17ZwdGBToddI8pDm48kA9rhCjhJUYcQpKsBaLXN1ZZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZamWLI2zvYWH8K3-s_4yszcp2ryTI0HqTOaaUohrI8PIuNo7m1fbtmVsrMSwhfnLpnlKvl4mhbWnjnk_eCNslDM/People+talking",
                      width: 300,
                      height: 300,
                     ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ShadowContainer(
                         child: Column(
                            children: <Widget>[
                            GestureDetector(
                                onTap: () {
                                  _showPicker(context);
                                },
                                child: CircleAvatar(
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
                                )),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              validator: (val) => val.isEmpty
                                  ? "Please enter the group name"
                                  : null,
                              controller: _groupNameController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.group),
                                hintText: "Group Name",
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            RaisedButton(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 80),
                                child: Text(
                                  "Create",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                  _createGroup(
                                      context, _groupNameController.text);
                                }),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
