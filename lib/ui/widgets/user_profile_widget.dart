import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_knowledge/models/User.dart';
import 'package:common_knowledge/services/auth_service.dart';
import 'package:common_knowledge/ui/widgets/futures_info.dart';
import 'package:common_knowledge/utilities/vocabulary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserProfile extends StatelessWidget {
  final User user;

  UserProfile({@required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 60.0,
          child: user.photoURL == null
              ? Icon(
                  Icons.face,
                  color: Colors.white,
                  size: 100.0,
                )
              : Image.network(user.photoURL),
        ),
        SizedBox(
          height: 30.0,
        ),
        AutoSizeText(
          user.displayName,
          maxLines: 2,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 0.0,
        ),
        AutoSizeText(
          user.email,
          maxLines: 1,
          style: TextStyle(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            fontSize: 16.0,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          '${ProfileScreenMessages.userRoleLabelText} ${user.userRole == 'user' ? '${ProfileScreenMessages.userRoleUserText}' : '${ProfileScreenMessages.userRoleAdminText}'}',
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor.withOpacity(0.5)),
        ),
        SizedBox(
          height: 20.0,
        ),
        AutoSizeText(
          (user.phoneNumber == null)
              ? ProfileScreenMessages.noPhoneNumberText
              : '${ProfileScreenMessages.phoneNumberTitleText} ${user.phoneNumber}',
          maxLines: 1,
          style: TextStyle(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            fontSize: 16.0,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        AutoSizeText(
          '${ProfileScreenMessages.registerDateTitleText} ${DateFormat('dd MMMM yyyy').format(user.creationTime)}',
          maxLines: 1,
          style: TextStyle(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            fontSize: 16.0,
          ),
        ),
        Divider(
          height: 60.0,
          color: Theme.of(context).primaryColor.withOpacity(0.25),
          indent: 16.0,
          endIndent: 16.0,
        ),
        Expanded(
          child: Container(),
        ),
        FlatButton(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(40.0),
            side: BorderSide(color: Theme.of(context).primaryColor),
          ),
          color: Colors.white,
          textColor: Theme.of(context).primaryColor,
          padding: EdgeInsets.all(20.0),
          onPressed: () {
            showFuturesInfo(context);
          },
          child: Text(
            ProfileScreenMessages.editProfileButtonText.toUpperCase(),
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        FlatButton(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(40.0),
          ),
          color: Colors.white,
          textColor: Theme.of(context).primaryColor,
          padding: EdgeInsets.all(20.0),
          onPressed: () async {
            try {
              await AuthService().signOut();
            } catch (e) {
              print(e);
            }
          },
          child: Text(
            ProfileScreenMessages.signOutButtonText.toUpperCase(),
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}
