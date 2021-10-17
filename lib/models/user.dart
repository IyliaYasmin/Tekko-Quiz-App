import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String email;
  Timestamp accountCreated;
  String fullName;
  List<String> groupIdasLeader; //admin of group id
  List<String> memberOfGroup;

   UserModel({
    this.uid,
    this.email,
    this.accountCreated,
    this.fullName,
    this.groupIdasLeader,
    this.memberOfGroup, 
  });

}