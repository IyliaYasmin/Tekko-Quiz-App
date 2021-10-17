import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tekko/models/user.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');
  final String uid;
  Database({this.uid});

  Future<String> createUser(UserModel user) async {
    String retVal = "error";
    List<String> groupIdasLeader = List();
    List<String> memberOfGroup = List();

    try {

      await _firestore.collection("users").doc(user.uid).set({
        'fullName': user.fullName,
        'email': user.email,
        'accountCreated': Timestamp.now(),
        'groupIdasLeader' : groupIdasLeader,
        'memberOfGroup' : memberOfGroup,
      });
      return retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<UserModel> getUserInfo(String uid) async {
    UserModel retVal = UserModel();

    try{
      DocumentSnapshot _docSnapshot = await _firestore.collection("users").doc(uid).get();
      retVal.uid = uid;
      retVal.fullName = _docSnapshot.data()["fullName"];
      retVal.email = _docSnapshot.data()["email"];
      retVal.accountCreated = _docSnapshot.data()["accountCreated"];
      retVal.groupIdasLeader = List.from(_docSnapshot.data()["groupIdasLeader"]);
      retVal.memberOfGroup = List.from(_docSnapshot.data()["memberOfGroup"]);

    }catch(e) {
      print(e);
    }

    return retVal;
  }

    Future<String> createGroup(String groupName, String userUid, String groupImg) async {
    String retVal = "error";
    List<String> members = List();
    List<String> groupIdasLeader = List();
    List<String> memberOfGroup = List();


    try{
      members.add(userUid);
      DocumentReference _docRef = await _firestore.collection("groups").add({
        'groupImg' : groupImg,
        'name' : groupName,
        'leader' : userUid,
        'members' : members,
        'groupCreated' : Timestamp.now(),
      });
      groupIdasLeader.add(_docRef.id);
      memberOfGroup.add(_docRef.id);
      await _firestore.collection("users").doc(userUid).update({
        'groupIdasLeader' : groupIdasLeader,
        'memberOfGroup' : memberOfGroup, //baru tambah 
      });
      // to add to group document under users document
      DocumentReference _ref2 = _docRef;
      _ref2 = await _firestore.collection("users").doc(userUid).collection("userGroups").add({
        'groupImg' : groupImg,
        'name' : groupName,
        'leader' : userUid,
        'members' : members,
        'groupCreated' : Timestamp.now(),
        'groupId' : _ref2.id,
      });

        DocumentReference _ref3 = _docRef;
      _ref3 = await _firestore.collection("users").doc(userUid).collection("userCreatedGroups").add({
        'groupImg' : groupImg,
        'name' : groupName,
        'leader' : userUid,
        'members' : members,
        'groupCreated' : Timestamp.now(),
        'groupId' : _ref3.id,
      });

      return retVal = _docRef.id; //return group id for Qr code

    }catch(e){
      print(e);
    }


    return retVal;
  }

    Future<String> joinGroup(String groupId, String userUid, String groupName, String groupImg) async {
    String retVal = "error";
    List<String> members = List();
    List<String> memberOfGroup = List();

    try{
      members.add(userUid);
      await _firestore.collection("groups").doc(groupId).update({
        'members' : FieldValue.arrayUnion(members),
      });
      members.add(userUid);
       await _firestore.collection("users").doc(userUid).collection("userGroups").add({
        'name' : groupName,
        'leader' : "You join this group!",
        'groupImg' : groupImg,
        'members' : members,
        'groupCreated' : Timestamp.now(),
        'groupId' : groupId,
      });
       memberOfGroup.add(groupId);
       await _firestore.collection("users").doc(userUid).update({
        
        'memberOfGroup' :memberOfGroup,
      });
      return retVal = "success";

    }catch(e){
      print(e);
    }


    return retVal;
  }

  //get group list
  getGroupData(String userUid) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userUid)
        .collection("userGroups")
        .snapshots();
  }
  //get Group created by user
  getCreatedGroupData(String userUid) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userUid)
        .collection("userCreatedGroups")
        .snapshots();
  }

  //get quiz list
  getQuizData(String groupId) async {
    return await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("groupQuiz")
        .snapshots();
  }

    getResultData(String groupId, String quizId) async {
    return await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("groupQuiz")
        .doc(quizId)
        .collection("marks")
        .snapshots();
  }

  Future<void> addQuizData(Map quizData, String quizId, String groupId) async {
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("groupQuiz")
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> addQuestionData(quizData, String quizId, String groupId) async {
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("groupQuiz")
        .doc(quizId)
        .collection("QNA")
        .add(quizData)
        .catchError((e) {
      print(e);
    });
  }

  getQuestionData(String quizId, String groupId) {
    return FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("groupQuiz")
        // .doc("jsM91053i98ttj68")
        .doc(quizId)
        .collection("QNA")
        .get();
  }

  Future<void> addMarksData(marksData, String quizId, String groupId) async {
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("groupQuiz")
        .doc(quizId)
        .collection("marks")
        .add(marksData)
        .catchError((e) {
      print(e);
    });
  }


}
