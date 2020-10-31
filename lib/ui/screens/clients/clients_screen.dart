import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_knowledge/models/Clients.dart';
import 'package:common_knowledge/services/database_service.dart';
import 'package:common_knowledge/ui/screens/clients/edit_client_screen.dart';
import 'package:common_knowledge/ui/screens/clients/new_client_screen.dart';
import 'package:common_knowledge/utilities/vocabulary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ClientsScreen extends StatelessWidget {
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
          stream: _databaseService.getClientsRecordsStreamSnapshot(context),
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
                final _client =
                    Client.fromSnapshot(snapshot.data.documents[index]);
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
                        Icons.account_circle,
                        color: Colors.white,
                      ),
                    ),
                    title: AutoSizeText(
                      _client.name ?? '',
                      maxLines: 3,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    subtitle: AutoSizeText(
                      'Email: ${_client.email}' ?? '',
                      maxLines: 1,
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).primaryColor,
                      ),
                      iconSize: 24.0,
                      onPressed: () {
                        _databaseService.deleteClient(_client.id);
                      },
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              EditClientScreen(currentClient: _client),
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
            MaterialPageRoute(builder: (context) => NewClientScreen()),
          );
        },
      ),
    );
  }
}
