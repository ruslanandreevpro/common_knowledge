import 'package:cloud_firestore/cloud_firestore.dart';

class Reports {
  String id;
  String title;
  String diagnosticCardID;
  String type;

  Reports({this.title, this.diagnosticCardID, this.type});

  // Formatting for upload to Firebase when creating the Report
  Map<String, dynamic> toJson() => {
        'title': title,
        'diagnosticCardID': diagnosticCardID,
        'type': type,
      };

  // Creating a Text Reports object from a firebase snapshot
  Reports.fromSnapshot(DocumentSnapshot snapshot)
      : title = snapshot['title'],
        diagnosticCardID = snapshot['diagnosticCardID'],
        type = snapshot['type'],
        id = snapshot.documentID;
}
