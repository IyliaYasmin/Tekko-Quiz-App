import 'package:flutter/material.dart';
import 'package:tekko/screens/groupInformation/createGroup/createGroup.dart';
import 'package:tekko/screens/groupInformation/joinGroup/joinGroup.dart';

//to give options to users either they want to craete group or join other group

class AddGroup extends StatelessWidget {

    void _toJoin(BuildContext context){
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context)=> JoinGroup(),
          ),
          );
    }
    void _toCreate(BuildContext context){
       Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context)=> CreateGroup(),
          ),
          );

    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                padding: const EdgeInsets.symmetric(vertical: 100.0),
                  child: Column(
                    children: <Widget>[
                    RaisedButton(
                      child: Text("Create",
                      style: TextStyle(color: Colors.grey),
                      ),
                      onPressed: ()=> _toCreate(context),
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
                      child: Text("Join",
                      style: TextStyle(color: Colors.white),
                      ),
                      onPressed: ()=> _toJoin(context),
                      
                      ),
                  ],
                  ),
                    )
                  ],              
              ),
            ),
          ],
        ),
      ));
  }
}