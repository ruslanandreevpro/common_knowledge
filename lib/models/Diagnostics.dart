import 'package:cloud_firestore/cloud_firestore.dart';

class Diagnostics {
  String id;
  String title;
  String clientID;
  String clientName;
  DateTime diagnosticDate;
  String notes;
  List points;

  Diagnostics(
      {this.title,
      this.clientID,
      this.clientName,
      this.diagnosticDate,
      this.notes,
      this.points});

  // Formatting for upload to Firebase when creating the Diagnostic
  Map<String, dynamic> toJson() => {
        'title': title,
        'clientID': clientID,
        'clientName': clientName,
        'diagnosticDate': diagnosticDate,
        'notes': notes,
        'points': points,
      };

  // Creating a Diagnostics object from a firebase snapshot
  Diagnostics.fromSnapshot(DocumentSnapshot snapshot)
      : title = snapshot['title'],
        clientID = snapshot['clientID'],
        clientName = snapshot['clientName'],
        diagnosticDate = snapshot['diagnosticDate'].toDate(),
        notes = snapshot['notes'],
        points = snapshot['points'],
        id = snapshot.documentID;
}
