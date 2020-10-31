import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_knowledge/services/auth_service.dart';
import 'package:common_knowledge/services/validate_service.dart';
import 'package:common_knowledge/ui/screens/authenticate/sign_in_screen.dart';
import 'package:common_knowledge/ui/widgets/bezier_widget.dart';
import 'package:common_knowledge/ui/widgets/raised_gradient_button_widget.dart';
import 'package:common_knowledge/utilities/constants.dart';
import 'package:common_knowledge/utilities/vocabulary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  String _userEmail, _warning;
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
                        AuthenticateScreensMessages.forgotPasswordTitle,
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
                                  prefixIcon: Icon(Icons.email),
                                  hintText: AuthenticateScreensMessages
                                      .userEmailHintText,
                                ),
                                onSaved: (value) => _userEmail = value,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            _resetPasswordButton(),
                            SizedBox(
                              height: 30.0,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: SizedBox(),
                      )
                    ],
                  ),
                ),
                _warning == null
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: _cancelResetPasswordAccountLabel(),
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

  Widget _resetPasswordButton() {
    return RaisedGradientButton(
      child: Text(
        AuthenticateScreensMessages.forgotPasswordButtonText,
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
            await _authService.sendPasswordResetEmail(_userEmail);
            setState(() {
              isLoading = false;
              _warning = null;
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SignInScreen(),
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

  Widget _cancelResetPasswordAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            AuthenticateScreensMessages.cancelResetPasswordText,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SignInScreen()));
            },
            child: Text(
              AuthenticateScreensMessages.signInButtonText,
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
