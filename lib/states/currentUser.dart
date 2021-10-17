import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tekko/models/user.dart';
import 'package:tekko/services/database.dart';

class CurrentUser extends ChangeNotifier{
  UserModel _currentUser = UserModel();
  
  UserModel get getCurrentUser => _currentUser;

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> onStartUp() async{
    
    String retVal = "error";

    try{
      User _firebaseUser = await _auth.currentUser;
      if(_currentUser != null){
     _currentUser = await Database().getUserInfo(_firebaseUser.uid);
      if(_currentUser != null){
        retVal = "success";
      }
     }
    }catch(e){
      print(e);
    }
    return retVal;
  }

  Future<String> signOut() async{
    String retVal = "error";

    try{
     await _auth.signOut();
      _currentUser = UserModel();
      retVal = "success";

    }catch(e){
      print(e);
    }
    return retVal;
  }

  Future<String> signUpUser(String email, String password, String fullName) async{
    String retVal = "error";
    UserModel _user = UserModel();
    try{
      
      UserCredential _authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _user.uid = _authResult.user.uid;
      _user.email = _authResult.user.email;
      _user.fullName = fullName;
      String _returnString = await Database().createUser(_user);
      if(_returnString == "success"){
         retVal = "success";
      }     
    } catch (e) {
      retVal = e.message;
    }
    return retVal;
  }

  Future<String> loginUserWithEmail(String email, String password) async{
    String retVal = "error";

    try{
      UserCredential _authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);

      _currentUser = await Database().getUserInfo(_authResult.user.uid);
      if(_currentUser != null){
        retVal = "success";
      }
    } on PlatformException catch (e) {
      retVal = e.message;
    }  catch (e) {
      print(e);
    }
    return retVal;
  }

  Future<String> loginUserWithGoogle() async{
    String retVal = "error";
    GoogleSignIn _googleSignIn = GoogleSignIn(
     scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
   UserModel _user = UserModel();

    try{
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);
      UserCredential _authResult = await _auth.signInWithCredential(credential);
      if(_authResult.additionalUserInfo.isNewUser){
        _user.uid = _authResult.user.uid;
        _user.email = _authResult.user.email;
        _user.fullName = _authResult.user.displayName;
         Database().createUser(_user);
      }
      _currentUser = await Database().getUserInfo(_authResult.user.uid);
      if(_currentUser != null){
        retVal = "success";
      } 
      
    } on PlatformException catch (e) {
      retVal = e.message;
    } catch(e){
      print(e);
    }
    return retVal;
  }

}