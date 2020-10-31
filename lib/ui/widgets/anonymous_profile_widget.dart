import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_knowledge/services/auth_service.dart';
import 'package:common_knowledge/ui/screens/authenticate/sign_up_screen.dart';
import 'package:common_knowledge/utilities/vocabulary.dart';
import 'package:flutter/material.dart';

class AnonymousProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 60.0,
          child: Icon(
            Icons.face,
            color: Colors.white,
            size: 100.0,
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        AutoSizeText(
          SharedMessages.anonymousUserTextLabel,
          maxLines: 1,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpScreen(
                  userConvert: true,
                ),
              ),
            );
          },
          child: AutoSizeText(
            ProfileScreenMessages.convertProfileButtonText.toUpperCase(),
            maxLines: 2,
            textAlign: TextAlign.center,
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
