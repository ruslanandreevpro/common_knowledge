import 'package:cloud_firestore/cloud_firestore.dart';

class RefBook {
  String id;
  String uid;
  String title;

  RefBook({this.id, this.title});

  // Creating a RefBook object from a firebase snapshot
  RefBook.fromSnapshot(DocumentSnapshot snapshot)
      : title = snapshot['title'],
        id = snapshot['id'],
        uid = snapshot.documentID;
}

class DiseasesRefBook {
  String uid;
  String id;
  String title;
  List content;

  DiseasesRefBook({this.id, this.title, this.content});

  // Creating a Diseases RefBook object from a firebase snapshot
  DiseasesRefBook.fromSnapshot(DocumentSnapshot snapshot)
      : uid = snapshot.documentID,
        id = snapshot['id'],
        title = snapshot['title'],
        content = snapshot['content'];
}

class HealingStrategiesRefBook {
  String uid;
  String id;
  List codes;
  List sections;
  String prayers;

  HealingStrategiesRefBook({this.id, this.codes, this.sections, this.prayers});

  // Creating a HealingStrategies RefBook object from firebase snapshot
  HealingStrategiesRefBook.fromSnapshot(DocumentSnapshot snapshot)
      : uid = snapshot.documentID,
        id = snapshot['id'],
        codes = snapshot['codes'],
        sections = snapshot['sections'],
        prayers = snapshot['prayers'];
}
