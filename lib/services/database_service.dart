import 'package:common_knowledge/models/Diagnostics.dart';
import 'package:common_knowledge/models/Reports.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_knowledge/models/Clients.dart';
import 'package:common_knowledge/models/RefBooks.dart';
import 'package:common_knowledge/models/User.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference refBooksCollection =
      Firestore.instance.collection('common');
  final CollectionReference usersCollection =
      Firestore.instance.collection('users');

  // Set User data on Sign up
  Future updateUserProfile(User user) async {
    return await usersCollection
        .document(uid)
        .collection('profile')
        .document(uid)
        .setData(user.toJson());
  }

  // Get current User Profile
  Stream<User> getUserProfile() {
    return usersCollection.document(uid).collection('profile').snapshots().map(
        (snapshot) => snapshot.documents
            .map((profile) => User.fromSnapshot(profile))
            .single);
  }

  // Get current User Profile
//  Stream<List<User>> getUserProfile() {
//    return usersCollection.document(uid).collection('profile').snapshots().map(
//        (snapshot) => snapshot.documents
//            .map((profile) => User.fromSnapshot(profile))
//            .toList());
//  }

  // Get current User profile Stream snapshot
  Stream<QuerySnapshot> getCurrentUserProfile(BuildContext context) async* {
    yield* usersCollection.document(uid).collection('profile').snapshots();
  }

  // Get Common records Stream snapshot
  Stream<QuerySnapshot> getRefBooksStreamSnapshot(BuildContext context) async* {
    yield* refBooksCollection.snapshots();
  }

  // Get Client records Stream snapshot
  Stream<QuerySnapshot> getClientsRecordsStreamSnapshot(
      BuildContext context) async* {
    yield* usersCollection.document(uid).collection('clients').snapshots();
  }

  // Get Clients List
  Future getClientsList() async {
    final result = await usersCollection
        .document(uid)
        .collection('clients')
        .getDocuments();
    return result.documents
        .map((client) => Client.fromSnapshot(client))
        .toList();
  }

  // Get Client by ID
  Future<DocumentSnapshot> getClientByID(String clientID) async {
    final result = await usersCollection
        .document(uid)
        .collection('clients')
        .document(clientID)
        .get();
    return result;
  }

  // Get Text reports Stream snapshot
  Stream<QuerySnapshot> getReportsStreamSnapshot(BuildContext context) async* {
    yield* usersCollection.document(uid).collection('reports').snapshots();
  }

  // Add new Report
  Future addNewReport(Reports newReport) async {
    return await usersCollection
        .document(uid)
        .collection('reports')
        .add(newReport.toJson());
  }

  // Edit Report
  Future editReport(String reportID, Reports reportData) async {
    return await usersCollection
        .document(uid)
        .collection('reports')
        .document(reportID)
        .updateData(reportData.toJson());
  }

  // Delete Report
  Future deleteReport(String reportID) async {
    return await usersCollection
        .document(uid)
        .collection('reports')
        .document(reportID)
        .delete();
  }

  // Get Diagnostics Stream snapshot
  Stream<QuerySnapshot> getDiagnosticsStreamSnapshot(
      BuildContext context) async* {
    yield* usersCollection.document(uid).collection('diagnostics').snapshots();
  }

  // Get DiagnosticCard List
  Future getDiagnosticCardList() async {
    final result = await usersCollection
        .document(uid)
        .collection('diagnostics')
        .getDocuments();
    return result.documents
        .map((diagnosticCard) => Diagnostics.fromSnapshot(diagnosticCard))
        .toList();
  }

  // Get Diseases RefBook Stream
  Stream<QuerySnapshot> getDiseasesRefBookStream(refBookId) async* {
    yield* refBooksCollection
        .document(refBookId)
        .collection('sections')
        .orderBy('id')
        .snapshots();
  }

  // Get Diseases RefBook Id
  Future getDiseasesRefBookId() async {
    final result = await refBooksCollection
        .where('id', isEqualTo: 'diseases')
        .getDocuments();
    return result.documents.map((refBook) => refBook.documentID).toString();
  }

  // Get Diseases RefBook Content
  Future getDiseasesRefBookContent(refBookId) async {
    final result = await refBooksCollection
        .document(refBookId)
        .collection('sections')
        .orderBy('id')
        .getDocuments();
    return result.documents
        .map((refBook) => DiseasesRefBook.fromSnapshot(refBook))
        .toList();
  }

  // Get Diseases RefBook Stream
  Stream<QuerySnapshot> getHealingStrategiesRefBookStream(refBookId) async* {
    yield* refBooksCollection
        .document(refBookId)
        .collection('packages')
        .snapshots();
  }

  // Get HealingStrategies RefBook Id
  Future getHealingStrategiesRefBookId() async {
    final result = await refBooksCollection
        .where('id', isEqualTo: 'healing_strategies')
        .getDocuments();
    return result.documents.map((refBook) => refBook.documentID).toString();
  }

  // Get HealingStrategies RefBook Content
  Future getHealingStrategiesRefBookContent(refBookId) async {
    final result = await refBooksCollection
        .document(refBookId)
        .collection('packages')
        .orderBy('id')
        .getDocuments();
    return result.documents
        .map((refBook) => HealingStrategiesRefBook.fromSnapshot(refBook))
        .toList();
  }

  // Add new DiagnosticCard
  Future addNewDiagnosticCard(Diagnostics newDiagnosticCard) async {
    return await usersCollection
        .document(uid)
        .collection('diagnostics')
        .add(newDiagnosticCard.toJson());
  }

  // Edit DiagnosticCard
  Future editDiagnosticCard(
      String diagnosticID, Diagnostics diagnosticCardData) async {
    return await usersCollection
        .document(uid)
        .collection('diagnostics')
        .document(diagnosticID)
        .updateData(diagnosticCardData.toJson());
  }

  // Delete DiagnosticCard
  Future deleteDiagnosticCard(String diagnosticID) async {
    return await usersCollection
        .document(uid)
        .collection('diagnostics')
        .document(diagnosticID)
        .delete();
  }

  // Add new Client
  Future addNewClient(Client newClient) async {
    return await usersCollection
        .document(uid)
        .collection('clients')
        .add(newClient.toJson());
  }

  // Edit Client info
  Future editClientInfo(String clientId, Client clientData) async {
    return await usersCollection
        .document(uid)
        .collection('clients')
        .document(clientId)
        .updateData(clientData.toJson());
  }

  // Delete Client
  Future deleteClient(clientID) async {
    return await usersCollection
        .document(uid)
        .collection('clients')
        .document(clientID)
        .delete();
  }
}
