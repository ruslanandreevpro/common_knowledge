import 'package:common_knowledge/models/User.dart';
import 'package:common_knowledge/services/database_service.dart';
import 'package:common_knowledge/ui/screens/clients/clients_screen.dart';
import 'package:common_knowledge/ui/screens/dashboard/dashboard_screen.dart';
import 'package:common_knowledge/ui/screens/diagnostic/diagnostic_screen.dart';
import 'package:common_knowledge/ui/screens/profile/profile_screen.dart';
import 'package:common_knowledge/ui/screens/refbooks/refbooks_screen.dart';
import 'package:common_knowledge/ui/screens/reports/reports_screen.dart';
import 'package:common_knowledge/utilities/constants.dart';
import 'package:common_knowledge/utilities/vocabulary.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _pages = [
    DiagnosticScreen(),
    RefBooksScreen(),
    ClientsScreen(),
    DashboardScreen(),
    ReportsScreen(),
    ProfileScreen(),
  ];

  int _selectedPage = 3;
  List<String> _pageAppBarTitle = [
    SharedMessages.diagnosticScreenTitle,
    SharedMessages.refbooksScreenTitle,
    SharedMessages.clientsScreenTitle,
    '',
    SharedMessages.reportsScreenTitle,
    SharedMessages.profileScreenTitle,
  ];

  @override
  Widget build(BuildContext context) {
//    final _currentUser = Provider.of<List<User>>(context)[0];
    final _databaseService = DatabaseService();
    final _currentUser = Provider.of<User>(context);
    if (_currentUser?.displayName == null) {
      _pageAppBarTitle[3] = SharedMessages.anonymousUserTextLabel;
    } else {
      _pageAppBarTitle[3] = _currentUser.displayName;
    }
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          _pageAppBarTitle[_selectedPage],
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
      ),
      body: _pages[_selectedPage],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedPage,
        color: Theme.of(context).primaryColor,
        backgroundColor: Colors.white,
        height: kBottomNavbarHeight,
        animationDuration: Duration(milliseconds: 350),
        items: <Widget>[
          Icon(
            Icons.trending_up,
            size: kBottomNavIconSize,
            color: kBottomNavIconColor,
          ),
          Icon(
            Icons.layers,
            size: kBottomNavIconSize,
            color: kBottomNavIconColor,
          ),
          Icon(
            Icons.supervisor_account,
            size: kBottomNavIconSize,
            color: kBottomNavIconColor,
          ),
          Icon(
            Icons.home,
            size: kBottomNavIconSize,
            color: kBottomNavIconColor,
          ),
          Icon(
            Icons.folder_open,
            size: kBottomNavIconSize,
            color: kBottomNavIconColor,
          ),
          Icon(
            Icons.account_circle,
            size: kBottomNavIconSize,
            color: kBottomNavIconColor,
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedPage = index;
          });
        },
      ),
    );
  }
}

//final _uid = Provider.of<String>(context);
//final _databaseService = DatabaseService(uid: _uid);
//return StreamBuilder(
//stream: _databaseService.getCurrentUserProfile(context),
//builder: (context, snapshot) {
//if (!snapshot.hasData) {
//return Container(
//width: double.infinity,
//height: double.infinity,
//color: Colors.white,
//);
//}
//if (snapshot.data.documents.length == 0 ||
//snapshot.data.documents.length == null) {
//_pageAppBarTitle[3] = SharedMessages.anonymousUserTextLabel;
//} else {
//final _currentUser = User.fromSnapshot(snapshot.data.documents[0]);
//_pageAppBarTitle[3] = _currentUser.displayName;
//}
//return Scaffold(
//backgroundColor: Theme.of(context).primaryColor,
//appBar: AppBar(
//title: Text(
//_pageAppBarTitle[_selectedPage],
//style: TextStyle(
//color: Colors.white,
//),
//),
//elevation: 0.0,
//),
//body: _pages[_selectedPage],
//bottomNavigationBar: CurvedNavigationBar(
//index: _selectedPage,
//color: Theme.of(context).primaryColor,
//backgroundColor: Colors.white,
//height: kBottomNavbarHeight,
//animationDuration: Duration(milliseconds: 350),
//items: <Widget>[
//Icon(
//Icons.trending_up,
//size: kBottomNavIconSize,
//color: kBottomNavIconColor,
//),
//Icon(
//Icons.layers,
//size: kBottomNavIconSize,
//color: kBottomNavIconColor,
//),
//Icon(
//Icons.supervisor_account,
//size: kBottomNavIconSize,
//color: kBottomNavIconColor,
//),
//Icon(
//Icons.home,
//size: kBottomNavIconSize,
//color: kBottomNavIconColor,
//),
//Icon(
//Icons.folder_open,
//size: kBottomNavIconSize,
//color: kBottomNavIconColor,
//),
//Icon(
//Icons.account_circle,
//size: kBottomNavIconSize,
//color: kBottomNavIconColor,
//),
//],
//onTap: (index) {
//setState(() {
//_selectedPage = index;
//});
//},
//),
//);
//},
//);
