import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_knowledge/models/Clients.dart';
import 'package:common_knowledge/services/database_service.dart';
import 'package:common_knowledge/services/validate_service.dart';
import 'package:common_knowledge/ui/widgets/raised_gradient_button_widget.dart';
import 'package:common_knowledge/utilities/constants.dart';
import 'package:common_knowledge/utilities/vocabulary.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class NewClientScreen extends StatefulWidget {
  @override
  _NewClientScreenState createState() => _NewClientScreenState();
}

class _NewClientScreenState extends State<NewClientScreen> {
  final _formKey = GlobalKey<FormState>();

  String _clientName,
      _clientEmail,
      _clientBirthPlace,
      _clientPhoneNumber,
      _clientPhotoReference,
      _warning;
  DateTime _clientBirthDate;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          iconSize: 16.0,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: AutoSizeText(
          ClientsScreenMessages.newClientTextTitle,
          maxLines: 2,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        opacity: 0.5,
        color: Colors.black,
        progressIndicator: SpinKitCircle(
          color: Colors.white,
          size: 60.0,
        ),
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                height:
                    MediaQuery.of(context).size.height - kToolbarHeight - 28.0,
                padding: EdgeInsets.all(24.0),
                child: Column(
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              validator: NameValidator.validate,
                              maxLines: 1,
                              decoration: kInputDecoration.copyWith(
                                prefixIcon: Icon(Icons.account_circle),
                                hintText:
                                    ClientsScreenMessages.clientNameHintText,
                              ),
                              onSaved: (value) => _clientName = value,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: EmailValidator.validate,
                              maxLines: 1,
                              decoration: kInputDecoration.copyWith(
                                prefixIcon: Icon(Icons.email),
                                hintText:
                                    ClientsScreenMessages.clientEmailHintText,
                              ),
                              onSaved: (value) => _clientEmail = value,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: DateTimeField(
                              format: DateFormat("dd MMMM yyyy, HH:mm"),
                              decoration: kInputDecoration.copyWith(
                                prefixIcon: Icon(Icons.calendar_today),
                                hintText: ClientsScreenMessages
                                    .clientBirthDateHintText,
                              ),
                              onShowPicker: (context, value) async {
                                final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(DateTime.now().year - 50),
                                  initialDate: value ?? DateTime.now(),
                                  lastDate: DateTime.now(),
                                );
                                if (date != null) {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(
                                        value ?? DateTime.now()),
                                  );
                                  setState(() {
                                    _clientBirthDate =
                                        DateTimeField.combine(date, time);
                                  });
                                  return DateTimeField.combine(date, time);
                                } else {
                                  return value;
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              decoration: kInputDecoration.copyWith(
                                prefixIcon: Icon(Icons.place),
                                hintText: ClientsScreenMessages
                                    .clientBirthPlaceHintText,
                              ),
                              onSaved: (value) => _clientBirthPlace = value,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              decoration: kInputDecoration.copyWith(
                                prefixIcon: Icon(Icons.phone_android),
                                hintText: ClientsScreenMessages
                                    .clientPhoneNumberHintText,
                              ),
                              onSaved: (value) => _clientPhoneNumber = value,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: TextFormField(
                              enabled: false,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              decoration: kInputDecoration.copyWith(
                                prefixIcon: Icon(Icons.image),
                                hintText:
                                    ClientsScreenMessages.clientPhotoHintText,
                              ),
                              onSaved: (value) => _clientPhotoReference = value,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          _addClientButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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

  Widget _addClientButton() {
    return RaisedGradientButton(
      child: Text(
        ClientsScreenMessages.clientAddButtonText,
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
            final uid = Provider.of<String>(context, listen: false);
            final _databaseService = DatabaseService(uid: uid);
            final _client = Client(
              name: _clientName,
              email: _clientEmail,
              birthDate: _clientBirthDate,
              birthPlace: _clientBirthPlace,
              phoneNumber: _clientPhoneNumber,
              photoReference: _clientPhotoReference,
            );
            await _databaseService.addNewClient(_client);
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pop();
          } catch (e) {
            setState(() {
              _warning = e.message;
              isLoading = false;
            });
          }
        }
      },
    );
  }
}
