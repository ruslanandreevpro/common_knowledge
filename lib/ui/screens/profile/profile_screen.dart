import 'package:common_knowledge/models/User.dart';
import 'package:common_knowledge/ui/widgets/anonymous_profile_widget.dart';
import 'package:common_knowledge/ui/widgets/user_profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    final _currentUser = Provider.of<List<User>>(context)[0];
    final _currentUser = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        width: double.infinity,
        padding:
            EdgeInsets.only(left: 8.0, top: 40.0, right: 8.0, bottom: 32.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
//        child: Provider.of<List<User>>(context).length == 0
        child: Provider.of<User>(context) == null
            ? AnonymousProfile()
            : UserProfile(user: _currentUser),
      ),
    );
  }
}

//final _uid = Provider.of<String>(context);
//final _databaseService = DatabaseService(uid: _uid);
//StreamBuilder(
//stream: _databaseService.getCurrentUserProfile(context),
//builder: (context, snapshot) {
//if (!snapshot.hasData) {
//return SpinKitCircle(
//color: Theme.of(context).primaryColor,
//size: 56.0,
//);
//}
//if (snapshot.data.documents.length == 0) {
//return AnonymousProfile();
//}
//final _currentUser = User.fromSnapshot(snapshot.data.documents[0]);
//return UserProfile(user: _currentUser);
//},
//),
