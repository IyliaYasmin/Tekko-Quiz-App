import 'package:flutter/material.dart';
import 'package:tekko/screens/groupInformation/createGroup/createGroup.dart';
import 'package:tekko/screens/groupInformation/joinGroup/joinGroup.dart';
import 'package:tekko/screens/root/root.dart';
import 'package:tekko/states/currentUser.dart';
import 'package:provider/provider.dart';

//if user have no group yet or first time user
class NoGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _toJoin(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JoinGroup(),
        ),
      );
    }

    void _toCreate(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateGroup(),
        ),
      );
    }

    void _signOut(BuildContext context) async {
      CurrentUser _currentUser =
          Provider.of<CurrentUser>(context, listen: false);
      String _returnString = await _currentUser.signOut();
      if (_returnString == "success") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginRoot(),
          ),
          (route) => false,
        );
      }
    }

    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.purple[300],
          elevation: 0.0,
          title: Center(
            child: Text(
              "Home Page",
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 2.0),
                child: IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () => _signOut(context),
                )),
          ],
        ),
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/background.jpg"),
                  fit: BoxFit.cover)),
          child: Column(children: <Widget>[
            Spacer(
              flex: 1,
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Image.asset(
                "assets/tekkoTitle.png",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Welcome!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                "Start your journey with \"tekko\" now.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Spacer(
              flex: 2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      "Create",
                      style: TextStyle(color: Colors.grey, fontSize: 20.0),
                    ),
                    onPressed: () => _toCreate(context),
                    color: Theme.of(context).canvasColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(
                        color: Theme.of(context).secondaryHeaderColor,
                        width: 2,
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Text(
                      "Join",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    onPressed: () => _toJoin(context),
                  ),
                ],
              ),
            )
          ]),
        ));
  }
}
