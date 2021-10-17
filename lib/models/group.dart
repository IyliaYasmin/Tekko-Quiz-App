import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String id;
  final String name;
  final String leader;
  final List<String> members;
  final Timestamp groupCreated;


  GroupModel({
    this.id,
    this.name,
    this.leader,
    this.members,
    this.groupCreated,
  });

}