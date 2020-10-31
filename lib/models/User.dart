import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_knowledge/services/auth_service.dart';
import 'package:flutter/cupertino.dart';

class User {
  String uid;
  String email;
  String displayName;
  String photoURL;
  String phoneNumber;
  DateTime creationTime;
  String userRole;

  User({
    @required this.email,
    @required this.displayName,
    this.photoURL,
    this.phoneNumber,
    this.creationTime,
    this.userRole,
  });

  // Create User object from Firebase snapshot
  User.fromSnapshot(DocumentSnapshot snapshot)
      : uid = snapshot.documentID,
        email = snapshot['email'],
        displayName = snapshot['displayName'],
        photoURL = snapshot['photoURL'],
        phoneNumber = snapshot['phoneNumber'],
        creationTime = snapshot['creationTime'].toDate(),
        userRole = snapshot['userRole'];

  // Formatting for upload to Firebase when creating the User
  Map<String, dynamic> toJson() => {
        'email': email,
        'displayName': displayName,
        'photoURL': photoURL,
        'phoneNumber': phoneNumber,
        'creationTime': creationTime,
        'userRole': userRole,
      };
}
