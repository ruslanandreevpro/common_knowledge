import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_knowledge/models/RefBooks.dart';
import 'package:common_knowledge/services/database_service.dart';
import 'package:common_knowledge/ui/screens/refbooks/diseases_refbook_screen.dart';
import 'package:common_knowledge/ui/widgets/futures_info.dart';
import 'package:common_knowledge/utilities/vocabulary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RefBooksScreen extends StatelessWidget {
  final _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
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
          stream: _databaseService.getRefBooksStreamSnapshot(context),
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
                final _refBook =
                    RefBook.fromSnapshot(snapshot.data.documents[index]);
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
                        Icons.layers,
                        color: Colors.white,
                      ),
                    ),
                    title: AutoSizeText(
                      _refBook.title ?? '',
                      maxLines: 3,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    subtitle: AutoSizeText(
                      'ID: ${_refBook.id}' ?? '',
                      maxLines: 1,
                    ),
                    onTap: () {
                      switch (_refBook.id) {
                        case 'diseases':
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DiseasesRefBookScreen(
                                refBookId: _refBook.uid,
                                refBookTitle: _refBook.title,
                              ),
                            ),
                          );
                          break;
                        case 'healing_strategies':
                          showFuturesInfo(context);
                          break;
                        default:
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
