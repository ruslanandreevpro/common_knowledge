import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_knowledge/services/auth_service.dart';
import 'package:common_knowledge/services/validate_service.dart';
import 'package:common_knowledge/shared/wrapper.dart';
import 'package:common_knowledge/ui/screens/authenticate/forgot_password_screen.dart';
import 'package:common_knowledge/ui/screens/authenticate/sign_up_screen.dart';
import 'package:common_knowledge/ui/widgets/bezier_widget.dart';
import 'package:common_knowledge/ui/widgets/divider_with_text_widget.dart';
import 'package:common_knowledge/ui/widgets/futures_info.dart';
import 'package:common_knowledge/ui/widgets/raised_gradient_button_widget.dart';
import 'package:common_knowledge/utilities/constants.dart';
import 'package:common_knowledge/utilities/vocabulary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  String _userEmail, _userPassword, _warning;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.5,
        color: Colors.black,
        progressIndicator: SpinKitCircle(
          color: Colors.white,
          size: 60.0,
        ),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: SizedBox(),
                      ),
                      AutoSizeText(
                        AuthenticateScreensMessages.signInTitle,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                validator: EmailValidator.validate,
                                maxLines: 1,
                                decoration: kInputDecoration.copyWith(
                                  prefixIcon: Icon(Icons.account_circle),
                                  hintText: AuthenticateScreensMessages
                                      .userEmailHintText,
                                ),
                                onSaved: (value) => _userEmail = value,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
                                obscureText: true,
                                keyboardType: TextInputType.text,
                                validator: PasswordValidator.validate,
                                maxLines: 1,
                                decoration: kInputDecoration.copyWith(
                                  prefixIcon: Icon(Icons.lock),
                                  hintText: AuthenticateScreensMessages
                                      .userPasswordHintText,
                                  suffixIcon: Icon(Icons.visibility_off),
                                ),
                                onSaved: (value) => _userPassword = value,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  AuthenticateScreensMessages
                                      .forgotPasswordText,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            _signInButton(),
                            SizedBox(
                              height: 30.0,
                            ),
                            DividerWithText(
                              dividerText:
                                  AuthenticateScreensMessages.dividerText,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                RawMaterialButton(
                                  constraints: BoxConstraints(
                                    minWidth: 48.0,
                                    minHeight: 48.0,
                                  ),
                                  elevation: 5.0,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(48.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'assets/images/google.png',
                                      width: 40.0,
                                      height: 40.0,
                                    ),
                                  ),
                                  onPressed: () {
                                    showFuturesInfo(context);
                                  },
                                ),
                                RawMaterialButton(
                                  constraints: BoxConstraints(
                                    minWidth: 48.0,
                                    minHeight: 48.0,
                                  ),
                                  elevation: 5.0,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(48.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'assets/images/facebook.png',
                                      width: 40.0,
                                      height: 40.0,
                                    ),
                                  ),
                                  onPressed: () {
                                    showFuturesInfo(context);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(),
                      )
                    ],
                  ),
                ),
                _warning == null
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: _signUpAccountLabel(),
                      )
                    : Align(
                        alignment: Alignment.bottomCenter,
                        child: _showAlert(),
                      ),
                Positioned(
                    top: -MediaQuery.of(context).size.height * .15,
                    right: -MediaQuery.of(context).size.width * .4,
                    child: BezierContainer())
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _showAlert() {
    if (_warning != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                FirebaseValidator.validate(_warning),
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _warning = null;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox(
      height: 0.0,
    );
  }

  Widget _signInButton() {
    return RaisedGradientButton(
      child: Text(
        AuthenticateScreensMessages.signInButtonText,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Theme.of(context).primaryColor,
          Theme.of(context).accentColor.withOpacity(0.5),
        ],
      ),
      onPressed: () async {
        if (FormValidator.validate(_formKey.currentState)) {
          try {
            setState(() {
              isLoading = true;
            });
            final _authService = AuthService();
            await _authService.signInWithEmailAndPassword(
                _userEmail, _userPassword);
            setState(() {
              isLoading = false;
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Wrapper(),
              ),
            );
          } catch (e) {
            setState(() {
              _warning = e.code;
              isLoading = false;
            });
            print(e);
          }
        }
      },
    );
  }

  Widget _signUpAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            AuthenticateScreensMessages.createAccountText,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()));
            },
            child: Text(
              AuthenticateScreensMessages.signUpButtonText,
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}
