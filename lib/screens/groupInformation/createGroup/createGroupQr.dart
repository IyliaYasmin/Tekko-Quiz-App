import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tekko/screens/groupInformation/groupList/groupBottomNavigation.dart';

//This file is to create QR Code for created group
class GroupQRCode extends StatefulWidget {
  final String groupId;
  GroupQRCode(this.groupId);

  @override
  _GroupQRCodeState createState() => _GroupQRCodeState();
}

class _GroupQRCodeState extends State<GroupQRCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background.jpg"),
                    fit: BoxFit.cover)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(100.0),
            child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                children:  <Widget>[
                          QrImage(
                                data: widget.groupId,
                                version: QrVersions.auto,
                                size: 200.0,
                                embeddedImage: AssetImage('assets/Tekko transparent.png'),
                                ),
                                 Text("Group ID:"),
                                 Text(widget.groupId),
                                SizedBox(height: 30),
                                RaisedButton(
                                  onPressed: () {       
                                     Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => GroupNavigation()),
                                 );
                         },
                        child: Text("Exit",
                        style: TextStyle(color: Colors.white),
                        ),
                      ),             
                    ]
                  ),
              ),
            ),
          ),
      ),
     
    );
  }
}
