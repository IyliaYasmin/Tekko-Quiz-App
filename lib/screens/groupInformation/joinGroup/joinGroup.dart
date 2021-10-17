import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:tekko/screens/groupInformation/joinGroup/QrScan.dart';
import 'package:tekko/screens/root/root.dart';
import 'package:tekko/services/database.dart';
import 'package:tekko/states/currentUser.dart';
import 'package:tekko/widgets/container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


//user join group with group id or scan the QR code
class JoinGroup extends StatefulWidget {
  @override
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  void _joinGroup(BuildContext context, String groupId) async {
     CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

      String groupName, groupImg;
      await FirebaseFirestore.instance.collection("groups").doc(groupId).get().then((addGroupId) => groupName = addGroupId.data()['name'] );  
      await FirebaseFirestore.instance.collection("groups").doc(groupId).get().then((addGroupId) => groupImg = addGroupId.data()['groupImg'] );  
      

     String _returnString = await Database().joinGroup(groupId, _currentUser.getCurrentUser.uid, groupName, groupImg);
     
     if( _returnString == "success"){
       Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(
          builder: (context)=> LoginRoot(),
          ),
          (route) => false);
     }
    }

  TextEditingController _groupIdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.purple[300],
          elevation: 0.0,
          title: Center(
            child: Text(
              "Join Group",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: 
                Container(
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/background.jpg"),
                          fit: BoxFit.cover)),
                  child: ListView(
                    children: <Widget>[
                      Image.network(
                        "https://institute.careerguide.com/wp-content/uploads/2020/10/source.gif",
                        width: 300,
                        height: 300,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ShadowContainer(
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _groupIdController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.group),
                                  hintText: "Group Id",
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              RaisedButton(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 95),
                                  child: Text(
                                    "Join",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                onPressed: () =>
                                    _joinGroup(context, _groupIdController.text), // join using group id
                              ),
                              Text("or"),
                          RaisedButton(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              child: Text(
                                "Scan QR Code",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            onPressed: () {  
                        Navigator.push(
                               context,
                               MaterialPageRoute(builder: (context) => QrScan(), //to scan QR code
                           ), );}
                          ),
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
