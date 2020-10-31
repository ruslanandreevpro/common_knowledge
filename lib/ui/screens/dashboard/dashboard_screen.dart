import 'package:common_knowledge/models/User.dart';
import 'package:common_knowledge/services/database_service.dart';
import 'package:common_knowledge/ui/screens/clients/new_client_screen.dart';
import 'package:common_knowledge/ui/screens/diagnostic/new_diagnostic_screen.dart';
import 'package:common_knowledge/ui/widgets/custom_icon_button_widget.dart';
import 'package:common_knowledge/ui/widgets/dashboard_card_widget.dart';
import 'package:common_knowledge/ui/widgets/futures_info.dart';
import 'package:common_knowledge/ui/widgets/user_role_warning.dart';
import 'package:common_knowledge/utilities/vocabulary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<String>(context);
    final _currentUser = Provider.of<User>(context);
    final _databaseService = DatabaseService(uid: _currentUser?.uid);
    return Stack(
      children: <Widget>[
        Container(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CustomIconButton(
                    icon: Icons.queue,
                    buttonTitle:
                        DashboardScreenMessages.iconButtonTextTitleNewRecord,
                    onPress: () {
                      showUserRoleWarning(context);
                    },
                  ),
                  CustomIconButton(
                    icon: Icons.person_add,
                    buttonTitle:
                        DashboardScreenMessages.iconButtonTextTitleNewClient,
                    onPress: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NewClientScreen(),
                        ),
                      );
                    },
                  ),
                  CustomIconButton(
                    icon: Icons.score,
                    buttonTitle: DashboardScreenMessages
                        .iconButtonTextTitleNewDiagnostic,
                    onPress: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NewDiagnosticScreen(),
                        ),
                      );
                    },
                  ),
                  CustomIconButton(
                    icon: Icons.create_new_folder,
                    buttonTitle:
                        DashboardScreenMessages.iconButtonTextTitleNewReport,
                    onPress: () {
                      showFuturesInfo(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 130.0),
          padding: EdgeInsets.only(
            left: 16.0,
            top: 16.0,
            right: 16.0,
            bottom: 32.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            ),
          ),
          child: ListView(
            children: <Widget>[
              Text(
                '${DashboardScreenMessages.dateTitle} ${DateFormat('dd MMMM yyyy').format(DateTime.now())}',
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                children: <Widget>[
                  StreamBuilder(
                    stream: _databaseService.getRefBooksStreamSnapshot(context),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return DashboardCard(
                          icon: Icons.layers,
                          child: SpinKitCircle(
                            color: Theme.of(context).primaryColor,
                            size: 40.0,
                          ),
                          cardTitle: DashboardScreenMessages.recordsCardTitle,
                        );
                      }
                      return DashboardCard(
                        icon: Icons.layers,
                        child: Text(
                          snapshot.data.documents.length.toString(),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        cardTitle: DashboardScreenMessages.recordsCardTitle,
                      );
                    },
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  StreamBuilder(
                    stream: _databaseService
                        .getClientsRecordsStreamSnapshot(context),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return DashboardCard(
                          icon: Icons.supervisor_account,
                          child: SpinKitCircle(
                            color: Theme.of(context).primaryColor,
                            size: 40.0,
                          ),
                          cardTitle: DashboardScreenMessages.recordsCardTitle,
                        );
                      }
                      return DashboardCard(
                        icon: Icons.supervisor_account,
                        child: Text(
                          snapshot.data.documents.length.toString(),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        cardTitle: DashboardScreenMessages.clientsCardTitle,
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                children: <Widget>[
                  StreamBuilder(
                    stream:
                        _databaseService.getDiagnosticsStreamSnapshot(context),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return DashboardCard(
                          icon: Icons.trending_up,
                          child: SpinKitCircle(
                            color: Theme.of(context).primaryColor,
                            size: 40.0,
                          ),
                          cardTitle: DashboardScreenMessages.recordsCardTitle,
                        );
                      }
                      return DashboardCard(
                        icon: Icons.trending_up,
                        child: Text(
                          snapshot.data.documents.length.toString(),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        cardTitle: DashboardScreenMessages.diagnosticCardTitle,
                      );
                    },
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  StreamBuilder(
                    stream: _databaseService.getReportsStreamSnapshot(context),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return DashboardCard(
                          icon: Icons.receipt,
                          child: SpinKitCircle(
                            color: Theme.of(context).primaryColor,
                            size: 40.0,
                          ),
                          cardTitle: DashboardScreenMessages.reportsCardTitle,
                        );
                      }
                      return DashboardCard(
                        icon: Icons.receipt,
                        child: Text(
                          snapshot.data.documents.length.toString(),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        cardTitle: DashboardScreenMessages.reportsCardTitle,
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 16.0,
              ),
              SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
