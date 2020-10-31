import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_knowledge/models/Diagnostics.dart';
import 'package:common_knowledge/services/database_service.dart';
import 'package:common_knowledge/services/validate_service.dart';
import 'package:common_knowledge/utilities/constants.dart';
import 'package:common_knowledge/utilities/vocabulary.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

enum DiagnosticCardMenu {
  CLIENT,
  CARD_TITLE,
  CARD_DATE,
  CARD_NOTES,
  RANDOM_VALUE
}

class EditDiagnosticScreen extends StatefulWidget {
  final Diagnostics diagnosticCard;

  const EditDiagnosticScreen({Key key, @required this.diagnosticCard})
      : super(key: key);

  @override
  _EditDiagnosticScreenState createState() => _EditDiagnosticScreenState();
}

class _EditDiagnosticScreenState extends State<EditDiagnosticScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List _clientList = [];
  List _refBook = [];
  String _refBookId = '';
  List _refBookPoints = [];
  List _sectionPoints = [];
  int _codePoints;
  List _selectedClient = [];

  Diagnostics _diagnosticCard;
  String _title;
  String _clientID;
  String _clientName;
  List _points;
  String _notes;
  DateTime _diagnosticDate;

  String _warning;

  bool isLoading = false;
  bool isDiagnosticSettings = true;

  void getRefBookId() async {
    final result = await DatabaseService().getDiseasesRefBookId();
    setState(() {
      _refBookId = result.substring(1, result.length - 1);
    });
  }

  void getRefBookContent() async {
    final result = await DatabaseService()
        .getDiseasesRefBookContent('UiWZsgOwxyHgI5eOxpoW');
    setState(() {
      _refBook = result;
    });
    initRefBookPoints(_refBook);
  }

  void getClientsList() async {
    final _uid = Provider.of<String>(context, listen: false);
    final _databaseService = DatabaseService(uid: _uid);
    final result = await _databaseService.getClientsList();
    setState(() {
      _clientList = result;
    });
    for (int i = 0; i < result.length; i++) {
      _selectedClient.add(false);
    }
    final String _code = widget.diagnosticCard.clientID;
    final int _index = _clientList.indexWhere((item) => item.id == _code);
    _selectedClient[_index] = true;
  }

  void initRefBookPoints(List refBook) {
//    for (int index = 0; index < refBook.length; index++) {
//      if (refBook[index].content.length > 0) {
//        _refBookPoints.add({'section': _refBook[index].id, 'point': 0});
//        for (int idx = 0; idx < refBook[index].content.length; idx++) {
//          _refBookPoints
//              .add({'code': _refBook[index].content[idx]['code'], 'point': 0});
//        }
//      } else {
//        _refBookPoints.add({'code': _refBook[index].id, 'point': 0});
//      }
//    }
    _sectionPoints = widget.diagnosticCard.points;
  }

  void generateRefBookPoints(List refBook) {
    List _generatedRefBookPoints = [];
    for (int index = 0; index < refBook.length; index++) {
      if (refBook[index].content.length > 0) {
        _generatedRefBookPoints
            .add({'section': _refBook[index].id, 'point': 0});
        for (int idx = 0; idx < refBook[index].content.length; idx++) {
          _generatedRefBookPoints.add({
            'code': _refBook[index].content[idx]['code'],
            'point': Random().nextInt(50),
          });
        }
      } else {
        _generatedRefBookPoints
            .add({'code': _refBook[index].id, 'point': Random().nextInt(100)});
      }
    }
    setState(() {
      _refBookPoints = _generatedRefBookPoints;
    });
    setState(() {
      _sectionPoints =
          _refBookPoints.where((item) => item.containsKey('code')).toList();
    });
  }

  int getSectionPoints(int index) {
    int _sumOfSectionPoints = 0;

    if (_refBook[index].content.length > 0) {
      for (int i = 0; i < _refBook[index].content.length; i++) {
        final String _code = _refBook[index].content[i]['code'];
        final int _index =
            _sectionPoints.indexWhere((item) => item['code'] == _code);
        _sumOfSectionPoints += _sectionPoints[_index]['point'];
      }
    } else {
      final String _code = _refBook[index].id;
      final int _index =
          _sectionPoints.indexWhere((item) => item['code'] == _code);
      _sumOfSectionPoints += _sectionPoints[_index]['point'];
    }
    return _sumOfSectionPoints;
  }

  void setSelectedClientIcon(String clientID) {
    final int _index = _clientList.indexWhere((item) => item.id == clientID);
    for (int i = 0; i < _selectedClient.length; i++) {
      _selectedClient[i] = false;
    }
    _selectedClient[_index] = true;
  }

  @override
  void initState() {
    super.initState();
    getRefBookId();
    getRefBookContent();
    getClientsList();

    _title = widget.diagnosticCard.title;
    _clientID = widget.diagnosticCard.clientID;
    _clientName = widget.diagnosticCard.clientName;
    _diagnosticDate = widget.diagnosticCard.diagnosticDate;
    _notes = widget.diagnosticCard.notes;
    _points = widget.diagnosticCard.points;
  }

  @override
  Widget build(BuildContext context) {
    final _uid = Provider.of<String>(context);
    final _databaseService = DatabaseService(uid: _uid);
    return Scaffold(
      key: _scaffoldKey,
      drawerEdgeDragWidth: 0,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: _buildDiagnosticScreenAppBar(context, _databaseService),
      drawer: _buildDrawer(context, _databaseService),
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
                height:
                    MediaQuery.of(context).size.height - kToolbarHeight - 28.0,
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: ListView.builder(
                  itemCount: _refBook.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        Card(
                          color: Theme.of(context).primaryColor,
                          elevation: 3.0,
                          child: ListTile(
                            leading: Text(
                              _refBook[index].id,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            title: AutoSizeText(
                              _refBook[index].title,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            trailing: Text(
                              getSectionPoints(index).toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            onLongPress: _refBook[index].content.length > 0
                                ? null
                                : () {
                                    final String _code = _refBook[index].id;
                                    final int _index =
                                        _sectionPoints.indexWhere(
                                            (item) => item['code'] == _code);
                                    return showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            '${DiagnosticScreenMessages.diagnosticCardInputPointTextTitle}',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                            ),
                                          ),
                                          content: Form(
                                            key: _formKey,
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                WhitelistingTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              decoration:
                                                  kInputDecoration.copyWith(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 4.0,
                                                              horizontal:
                                                                  24.0)),
                                              onSaved: (value) {
                                                setState(() {
                                                  _codePoints =
                                                      int.parse(value);
                                                });
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  _codePoints =
                                                      int.parse(value);
                                                });
                                              },
                                              onFieldSubmitted: (value) {
                                                setState(() {
                                                  _codePoints =
                                                      int.parse(value);
                                                });
                                                _sectionPoints[_index]
                                                    ['point'] = _codePoints;
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text(SharedMessages
                                                  .alertSecondaryButtonText),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            FlatButton(
                                              child: Text(SharedMessages
                                                  .alertPrimaryButtonText),
                                              onPressed: () {
                                                _sectionPoints[_index]
                                                    ['point'] = _codePoints;
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: _refBook[index].content.length,
                          itemBuilder: (BuildContext ctx, int idx) {
                            final String _code =
                                _refBook[index].content[idx]['code'];
                            final String _title =
                                _refBook[index].content[idx]['title'];
                            final int _index = _sectionPoints
                                .indexWhere((item) => item['code'] == _code);
                            return ListTile(
                              leading: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Text(
                                  _code,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              title: Text(
                                _title,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              trailing: Text(
                                _sectionPoints[_index]['point'].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                              onLongPress: () {
                                return showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                        '${DiagnosticScreenMessages.diagnosticCardInputPointTextTitle}',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                        ),
                                      ),
                                      content: Form(
                                        key: _formKey,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            WhitelistingTextInputFormatter
                                                .digitsOnly
                                          ],
                                          decoration: kInputDecoration.copyWith(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 4.0,
                                                      horizontal: 24.0)),
                                          onSaved: (value) {
                                            setState(() {
                                              _codePoints = int.parse(value);
                                            });
                                          },
                                          onChanged: (value) {
                                            setState(() {
                                              _codePoints = int.parse(value);
                                            });
                                          },
                                          onFieldSubmitted: (value) {
                                            setState(() {
                                              _codePoints = int.parse(value);
                                            });
                                            _sectionPoints[_index]['point'] =
                                                _codePoints;
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text(SharedMessages
                                              .alertSecondaryButtonText),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FlatButton(
                                          child: Text(SharedMessages
                                              .alertPrimaryButtonText),
                                          onPressed: () {
                                            _sectionPoints[_index]['point'] =
                                                _codePoints;
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildDiagnosticScreenAppBar(
      BuildContext context, DatabaseService databaseService) {
    return AppBar(
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
        DiagnosticScreenMessages.editDiagnosticTextTitle,
        maxLines: 2,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.white,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.save),
          iconSize: 24.0,
          color: Colors.white,
          onPressed: !isDiagnosticSettings
              ? null
              : () async {
                  _diagnosticCard = Diagnostics(
                    title: _title,
                    clientID: _clientID,
                    clientName: _clientName,
                    diagnosticDate: _diagnosticDate,
                    points: _sectionPoints,
                    notes: _notes,
                  );
                  try {
                    setState(() {
                      isLoading = true;
                    });
                    await databaseService.editDiagnosticCard(
                        widget.diagnosticCard.id, _diagnosticCard);
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.of(context).pop();
                  } catch (e) {
                    setState(() {
                      _warning = e.message;
                      isLoading = false;
                    });
                    print(e);
                  }
                },
        ),
        _buildPopupMenu(),
//        SizedBox(
//          width: 8.0,
//        ),
      ],
    );
  }

  _buildPopupMenu() {
    return PopupMenuButton<DiagnosticCardMenu>(
      icon: Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      onSelected: (DiagnosticCardMenu value) {
        switch (value) {
          case DiagnosticCardMenu.CLIENT:
            return _scaffoldKey.currentState.openDrawer();
            break;
          case DiagnosticCardMenu.CARD_TITLE:
            final String _oldTitle = _title;
            _buildOptionSetupDialog(
              context,
              DiagnosticScreenMessages.diagnosticCardTitleHintText,
              TextFormField(
                initialValue: _title,
                validator: NameValidator.validate,
                decoration: kInputDecoration.copyWith(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                ),
                onChanged: (value) {
                  setState(
                    () {
                      _title = value;
                    },
                  );
                },
                onFieldSubmitted: (value) {
                  setState(
                    () {
                      _title = value;
                    },
                  );
                  Navigator.of(context).pop();
                },
              ),
              SharedMessages.alertPrimaryButtonText,
              () {
                Navigator.of(context).pop();
              },
              SharedMessages.alertSecondaryButtonText,
              () {
                setState(() {
                  _title = _oldTitle;
                });
                Navigator.of(context).pop();
              },
            );
            break;
          case DiagnosticCardMenu.CARD_DATE:
            final DateTime _oldDate = _diagnosticDate;
            _buildOptionSetupDialog(
              context,
              DiagnosticScreenMessages.diagnosticCardDateHintText,
              DateTimeField(
                format: DateFormat("dd MMMM yyyy, HH:mm"),
                decoration: kInputDecoration.copyWith(
                  contentPadding: EdgeInsets.fromLTRB(16.0, 4.0, 8.0, 4.0),
                ),
                initialValue: _diagnosticDate,
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
                      initialTime:
                          TimeOfDay.fromDateTime(value ?? DateTime.now()),
                    );
                    setState(() {
                      _diagnosticDate = DateTimeField.combine(date, time);
                    });
                    return DateTimeField.combine(date, time);
                  } else {
                    return value;
                  }
                },
              ),
              SharedMessages.alertPrimaryButtonText,
              () {
                Navigator.of(context).pop();
              },
              SharedMessages.alertSecondaryButtonText,
              () {
                setState(() {
                  _diagnosticDate = _oldDate;
                });
                Navigator.of(context).pop();
              },
            );
            break;
          case DiagnosticCardMenu.CARD_NOTES:
            final String _oldNotes = _notes;
            _buildOptionSetupDialog(
              context,
              DiagnosticScreenMessages.diagnosticCardNotesHintText,
              TextFormField(
                initialValue: _notes,
                maxLines: 3,
                textInputAction: TextInputAction.done,
                decoration: kInputDecoration.copyWith(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                ),
                onChanged: (value) {
                  setState(
                    () {
                      _notes = value;
                    },
                  );
                },
                onFieldSubmitted: (value) {
                  setState(
                    () {
                      _notes = value;
                    },
                  );
                  Navigator.of(context).pop();
                },
              ),
              SharedMessages.alertPrimaryButtonText,
              () {
                Navigator.of(context).pop();
              },
              SharedMessages.alertSecondaryButtonText,
              () {
                setState(() {
                  _notes = _oldNotes;
                });
                Navigator.of(context).pop();
              },
            );
            break;
          case DiagnosticCardMenu.RANDOM_VALUE:
            generateRefBookPoints(_refBook);
            break;
          default:
            break;
        }
      },
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<DiagnosticCardMenu>>[
        PopupMenuItem(
          value: DiagnosticCardMenu.CLIENT,
          child: Text(DiagnosticScreenMessages.popupMenuClientsItemText),
        ),
        PopupMenuItem(
          value: DiagnosticCardMenu.CARD_TITLE,
          child: Text(DiagnosticScreenMessages.popupMenuCardTitleItemText),
        ),
        PopupMenuItem(
          value: DiagnosticCardMenu.CARD_DATE,
          child: Text(DiagnosticScreenMessages.popupMenuCardDateItemText),
        ),
        PopupMenuItem(
          value: DiagnosticCardMenu.CARD_NOTES,
          child: Text(DiagnosticScreenMessages.popupMenuCardNotesItemText),
        ),
        PopupMenuItem(
          value: DiagnosticCardMenu.RANDOM_VALUE,
          child: Text(DiagnosticScreenMessages.popupMenuRandomDataItemText),
        ),
      ],
    );
  }

  _buildDrawer(BuildContext context, DatabaseService databaseService) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 48.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    AutoSizeText(
                      DiagnosticScreenMessages.drawerHeaderText,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 100.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
            child: ListView.builder(
              itemCount: _clientList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      _clientList[index].name,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    trailing: _selectedClient[index]
                        ? Icon(
                            Icons.check,
                            color: Colors.green.shade700,
                          )
                        : null,
                    onTap: () {
                      setSelectedClientIcon(_clientList[index].id);
                      setState(() {
                        _clientID = _clientList[index].id;
                        _clientName = _clientList[index].name;
                        isDiagnosticSettings = true;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildOptionSetupDialog(
    BuildContext context,
    String dialogTitle,
    Widget content,
    String primaryButtonText,
    Function primaryAction,
    String secondaryButtonText,
    Function secondaryAction,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: AutoSizeText(
            dialogTitle,
            maxLines: 2,
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          content: content,
          actions: <Widget>[
            secondaryButtonText == null
                ? null
                : FlatButton(
                    child: Text(
                      secondaryButtonText.toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    onPressed: secondaryAction,
                  ),
            FlatButton(
              child: Text(
                primaryButtonText.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
              onPressed: primaryAction,
            ),
          ],
        );
      },
    );
  }
}
