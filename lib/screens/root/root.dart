import 'package:flutter/material.dart';
import 'package:tekko/screens/groupInformation/groupList/groupBottomNavigation.dart';
import 'package:tekko/screens/groupInformation/noGroup/noGroup.dart';
import 'package:tekko/screens/login.dart';
import 'package:tekko/screens/splashScreen/splashScreen.dart';
import 'package:tekko/states/currentUser.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

enum AuthStatus{
  notLoggedIn,
  noGroup,
  unknown,
  loggedIn,
}

class LoginRoot extends StatefulWidget {
  @override

  _LoginRootState createState() => _LoginRootState();
  
}

class _LoginRootState extends State<LoginRoot> {
  
  AuthStatus _authStatus = AuthStatus.unknown;
  
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    //get the state, check current User, set AuthStatus based on state
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _returnString = await _currentUser.onStartUp();
    if(_returnString == "success"){
      if((_currentUser.getCurrentUser.memberOfGroup.isEmpty ) && (_currentUser.getCurrentUser.groupIdasLeader.isEmpty ) ) {
       setState((){
         _authStatus = AuthStatus.noGroup;
      });
      }else{
         setState((){
        _authStatus = AuthStatus.loggedIn;
      });
      }
     
    } else {
       setState((){
        _authStatus = AuthStatus.notLoggedIn;
      });
    }
 
  }

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
     
    Widget retVal;

    switch (_authStatus) {
      case AuthStatus.unknown:
        retVal = SplashScreen();
        break;
      case AuthStatus.notLoggedIn:
        retVal = Login();
        break;
      case AuthStatus.loggedIn:
        retVal = GroupNavigation();
        break;
        case AuthStatus.noGroup:
        retVal = NoGroup();
        break;
      default:
    }
    
    return retVal;
  }
}