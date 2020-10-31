import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_knowledge/models/Reports.dart';
import 'package:common_knowledge/services/database_service.dart';
import 'package:common_knowledge/ui/screens/reports/new_report_screen.dart';
import 'package:common_knowledge/ui/widgets/futures_info.dart';
import 'package:common_knowledge/utilities/vocabulary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

enum ReportsAction {
  VIEW_REPORT,
  EDIT_REPORT,
  PRINT_REPORT,
  DELETE_REPORT,
}

class ReportsScreen extends StatelessWidget {
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
            )),
        child: StreamBuilder(
          stream: _databaseService.getReportsStreamSnapshot(context),
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
                final _report =
                    Reports.fromSnapshot(snapshot.data.documents[index]);
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
                        Icons.receipt,
                        color: Colors.white,
                      ),
                    ),
                    title: AutoSizeText(
                      _report.title ?? '',
                      maxLines: 3,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    subtitle: AutoSizeText(
                      'ID: ${_report.id}' ?? '',
                      maxLines: 1,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    trailing:
                        _buildPopupMenu(context, _report.id, _databaseService),
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
              builder: (context) => NewReportScreen(),
            ),
          );
        },
      ),
    );
  }

  _buildPopupMenu(
      BuildContext context, String reportID, DatabaseService databaseService) {
    return PopupMenuButton<ReportsAction>(
      icon: Icon(
        Icons.more_vert,
        color: Theme.of(context).primaryColor,
      ),
      onSelected: (ReportsAction value) {
        switch (value) {
          case ReportsAction.VIEW_REPORT:
            showFuturesInfo(context);
            break;
          case ReportsAction.EDIT_REPORT:
            showFuturesInfo(context);
            break;
          case ReportsAction.PRINT_REPORT:
            showFuturesInfo(context);
            break;
          case ReportsAction.DELETE_REPORT:
            databaseService.deleteReport(reportID);
            break;
          default:
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ReportsAction>>[
        PopupMenuItem(
          value: ReportsAction.VIEW_REPORT,
          child: Row(
            children: <Widget>[
              Icon(Icons.pageview),
              SizedBox(
                width: 8.0,
              ),
              Text(ReportsScreenMessages.popupMenuViewReportText),
            ],
          ),
        ),
        PopupMenuItem(
          value: ReportsAction.EDIT_REPORT,
          child: Row(
            children: <Widget>[
              Icon(Icons.edit),
              SizedBox(
                width: 8.0,
              ),
              Text(ReportsScreenMessages.popupMenuEditReportText),
            ],
          ),
        ),
        PopupMenuItem(
          value: ReportsAction.PRINT_REPORT,
          child: Row(
            children: <Widget>[
              Icon(Icons.print),
              SizedBox(
                width: 8.0,
              ),
              Text(ReportsScreenMessages.popupMenuPrintReportText),
            ],
          ),
        ),
        PopupMenuItem(
          value: ReportsAction.DELETE_REPORT,
          child: Row(
            children: <Widget>[
              Icon(Icons.delete),
              SizedBox(
                width: 8.0,
              ),
              Text(ReportsScreenMessages.popupMenuDeleteReportText),
            ],
          ),
        ),
      ],
    );
  }
}
