import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_knowledge/models/Clients.dart';
import 'package:common_knowledge/models/Diagnostics.dart';
import 'package:common_knowledge/services/database_service.dart';
import 'package:common_knowledge/ui/screens/diagnostic/edit_diagnostic_screen.dart';
import 'package:common_knowledge/ui/screens/diagnostic/new_diagnostic_screen.dart';
import 'package:common_knowledge/utilities/vocabulary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class DiagnosticScreen extends StatefulWidget {
  @override
  _DiagnosticScreenState createState() => _DiagnosticScreenState();
}

class _DiagnosticScreenState extends State<DiagnosticScreen> {
  String _clientName = '';
  String _clientEmail = '';

  Future<Client> getClientByID(
      String clientID, DatabaseService databaseService) async {
    final result = await databaseService.getClientByID(clientID);
    return Client.fromSnapshot(result);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<String>(context);
    final _databaseService = DatabaseService(uid: uid);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        child: StreamBuilder(
          stream: _databaseService.getDiagnosticsStreamSnapshot(context),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SpinKitCircle(
                color: Theme.of(context).primaryColor,
                size: 56.0,
              );
            }
            if (snapshot.data.documents.length == 0) {
              return Center(
                child: AutoSizeText(SharedMessages.emptySnapshot),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                final _diagnostic =
                    Diagnostics.fromSnapshot(snapshot.data.documents[index]);
                getClientByID(_diagnostic.clientID, _databaseService)
                    .then((client) {
                  setState(() {
                    _clientName = client.name;
                    _clientEmail = client.email;
                  });
                }).toString();
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 24.0,
                      child: Icon(
                        Icons.trending_up,
                        color: Colors.white,
                      ),
                    ),
                    title: AutoSizeText(
                      _diagnostic.title ?? '',
                      maxLines: 3,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 5.0,
                        ),
                        AutoSizeText(
                          '$_clientName' ?? '',
                          maxLines: 1,
                        ),
                        AutoSizeText(
                          '$_clientEmail' ?? '',
                          maxLines: 1,
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).primaryColor,
                      ),
                      iconSize: 24.0,
                      onPressed: () {
                        _databaseService.deleteDiagnosticCard(_diagnostic.id);
                      },
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditDiagnosticScreen(
                            diagnosticCard: _diagnostic,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NewDiagnosticScreen(),
            ),
          );
        },
      ),
    );
  }
}
