import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_knowledge/services/auth_service.dart';
import 'package:common_knowledge/shared/wrapper.dart';
import 'package:common_knowledge/ui/screens/authenticate/sign_in_screen.dart';
import 'package:common_knowledge/ui/screens/authenticate/sign_up_screen.dart';
import 'package:common_knowledge/utilities/constants.dart';
import 'package:common_knowledge/utilities/vocabulary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final AuthService _authService = AuthService();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.5,
        color: Colors.black,
        progressIndicator: SpinKitCircle(
          color: Colors.white,
          size: 60.0,
        ),
        child: Container(
          width: _width,
          height: _height,
          color: Theme.of(context).primaryColor,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AutoSizeText(
                    WelcomeScreenMessages.title,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 44.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.2,
                  ),
                  AutoSizeText(
                    WelcomeScreenMessages.message,
                    maxLines: 4,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 40.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.025,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        WelcomeScreenMessages.author,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        WelcomeScreenMessages.authorDegree,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        WelcomeScreenMessages.authorGrade,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: _height * 0.075,
                  ),
                  RaisedButton(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      WelcomeScreenMessages.startButtonText,
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: AutoSizeText(
                            WelcomeScreenMessages.alertDialogTitleText,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 24.0,
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              AutoSizeText(
                                WelcomeScreenMessages.alertDialogContentText,
                                maxLines: 4,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: kGreyColor,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(
                                height: 24.0,
                              ),
                              RaisedButton(
                                color: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: AutoSizeText(
                                  WelcomeScreenMessages
                                      .alertDialogPrimaryButtonText,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w200,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => SignUpScreen(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 12.0,
                              ),
                              FlatButton(
                                child: AutoSizeText(
                                  WelcomeScreenMessages
                                      .alertDialogSecondaryButtonText,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Navigator.of(context).pop();
                                  await _authService.signInAnonymously();
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => Wrapper(),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: _height * 0.025,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => SignInScreen(),
                        ),
                      );
                    },
                    child: Text(
                      WelcomeScreenMessages.signInButtonText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
