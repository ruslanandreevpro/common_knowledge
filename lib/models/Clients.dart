import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  String id;
  String name;
  String email;
  DateTime birthDate;
  String birthPlace;
  String phoneNumber;
  String photoReference;

  Client({
    this.name,
    this.email,
    this.birthDate,
    this.birthPlace,
    this.phoneNumber,
    this.photoReference,
  });

  // Formatting for upload to Firebase when creating the Client
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'birthDate': birthDate,
        'birthPlace': birthPlace,
        'phoneNumber': phoneNumber,
        'photoReference': photoReference,
      };

  // Creating a Clients object from a firebase snapshot
  Client.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.documentID,
        name = snapshot['name'],
        email = snapshot['email'],
        birthDate = snapshot['birthDate'].toDate(),
        birthPlace = snapshot['birthPlace'],
        phoneNumber = snapshot['phoneNumber'],
        photoReference = snapshot['photoReference'];
}
