import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_knowledge/models/Reports.dart';
import 'package:common_knowledge/services/database_service.dart';
import 'package:common_knowledge/utilities/vocabulary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

enum ReportMenu {
  DIAGNOSTIC_CARD,
  MAIN_REPORT,
}

enum ReportType {
  MAIN_REPORT,
}

const Map<ReportType, String> reportTypeText = {
  ReportType.MAIN_REPORT: "MAIN_REPORT",
};

class NewReportScreen extends StatefulWidget {
  @override
  _NewReportScreenState createState() => _NewReportScreenState();
}

class _NewReportScreenState extends State<NewReportScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Reports _report;
  String _reportTitle = ReportsScreenMessages.reportDefaultTitleText;
  List _diagnosticCardList = [];
  String _healingStrategiesRefBookId = '';
  List _healingStrategiesRefBookContent = [];
  String _selectedCard = '';
  int _selectedCardIndex;
  List _selectedCardCodes = [];
  List _prayersList = [];
  List _prayersCodes = [];
  List _prayersIndex = [];
  String _warning;

  String _diagnosticTitleText = ReportsScreenMessages.diagnosticDefaultText;
  DateTime _diagnosticDate;
  String _diagnosticClientNameText =
      ReportsScreenMessages.diagnosticClientNameDefaultText;
  String _reportTypeText = ReportsScreenMessages.reportTypeDefaultText;
  String _reportType = '';

  bool _isLoading = false;
  bool _isCardSelected = false;
  bool _isTypeSelected = false;

  void getDiagnosticCardList() async {
    final _uid = Provider.of<String>(context, listen: false);
    final _databaseService = DatabaseService(uid: _uid);
    final result = await _databaseService.getDiagnosticCardList();
    setState(() {
      _diagnosticCardList = result;
    });
  }

  void getHealingStrategiesRefBookId() async {
    final result = await DatabaseService().getHealingStrategiesRefBookId();
    setState(() {
      _healingStrategiesRefBookId = result.substring(1, result.length - 1);
    });
  }

  void getHealingStrategiesRefBookContent() async {
    final result = await DatabaseService()
        .getHealingStrategiesRefBookContent('iE8XwHDPhcJgf7SZyfHF');
    setState(() {
      _healingStrategiesRefBookContent = result;
    });
    for (int i = 0; i < _healingStrategiesRefBookContent.length; i++) {
      _prayersCodes.add(_healingStrategiesRefBookContent[i].codes);
      _prayersIndex.add(false);
    }
  }

  void setPrayersList() {
    for (int i = 0;
        i < _diagnosticCardList[_selectedCardIndex].points.length;
        i++) {
      _selectedCardCodes
          .add(_diagnosticCardList[_selectedCardIndex].points[i]['code']);
    }
    for (int x = 0; x < _prayersCodes.length; x++) {
      for (int y = 0; y < _selectedCardCodes.length; y++) {
        for (int z = 0; z < _prayersCodes[x].length; z++) {
          if (_selectedCardCodes[y] == _prayersCodes[x][z]) {
            _prayersIndex[x] = true;
          }
        }
      }
    }
    _prayersIndex[19] =
        _selectedCardCodes.any((item) => item.contains('16.1')) &&
            _selectedCardCodes.any((item) => item.contains('16.2')) &&
            _selectedCardCodes.any((item) => item.contains('16.3')) &&
            _selectedCardCodes.any((item) => item.contains('16.4')) &&
            _selectedCardCodes.any((item) => item.contains('16.5')) &&
            _selectedCardCodes.any((item) => item.contains('16.6'));

    for (int i = 0; i < _prayersIndex.length; i++) {
      if (_prayersIndex[i]) {
        _prayersList.add(_healingStrategiesRefBookContent[i].prayers);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getHealingStrategiesRefBookId();
    getHealingStrategiesRefBookContent();
    getDiagnosticCardList();
  }

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<String>(context);
    final _databaseService = DatabaseService(uid: uid);
    return Scaffold(
      key: _scaffoldKey,
      drawerEdgeDragWidth: 0,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: _buildReportScreenAppBar(context, _databaseService),
      drawer: _buildDrawer(context, _databaseService),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
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
                padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildReportHeader(),
                    _buildReportContent(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildReportScreenAppBar(
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
        ReportsScreenMessages.newReportTitleText,
        maxLines: 2,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.white,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.save,
          ),
          color: Colors.white,
          onPressed: !(_isCardSelected && _isTypeSelected)
              ? null
              : () async {
                  _report = Reports(
                    title: _reportTitle,
                    diagnosticCardID:
                        _diagnosticCardList[_selectedCardIndex].id,
                    type: _reportType,
                  );
                  try {
                    setState(() {
                      _isLoading = true;
                    });
                    await databaseService.addNewReport(_report);
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.of(context).pop();
                  } catch (e) {
                    _warning = e.message;
                    setState(() {
                      _isLoading = false;
                    });
                    print(e);
                  }
                },
        ),
        _buildPopupMenu(),
      ],
    );
  }

  _buildPopupMenu() {
    return PopupMenuButton<ReportMenu>(
      icon: Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      onSelected: (ReportMenu value) {
        switch (value) {
          case ReportMenu.DIAGNOSTIC_CARD:
            return _scaffoldKey.currentState.openDrawer();
            break;
          case ReportMenu.MAIN_REPORT:
            setState(() {
              _reportType = reportTypeText[ReportType.MAIN_REPORT];
              _reportTypeText = ReportsScreenMessages.reportTypeText;
              _isTypeSelected = true;
            });
            break;
          default:
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ReportMenu>>[
        PopupMenuItem(
          value: ReportMenu.DIAGNOSTIC_CARD,
          child: Row(
            children: <Widget>[
              Icon(Icons.trending_up),
              SizedBox(
                width: 8.0,
              ),
              Text(ReportsScreenMessages.popupMenuCardItemText),
            ],
          ),
        ),
        PopupMenuItem(
          enabled: _isCardSelected,
          value: ReportMenu.MAIN_REPORT,
          child: Row(
            children: <Widget>[
              Icon(Icons.receipt),
              SizedBox(
                width: 8.0,
              ),
              Text(ReportsScreenMessages.popupMenuMainReportItemText),
            ],
          ),
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
                    Flexible(
                      child: AutoSizeText(
                        ReportsScreenMessages.newReportCardSelectText,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 130.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
            child: ListView.builder(
              itemCount: _diagnosticCardList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Icon(
                        Icons.trending_up,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      _diagnosticCardList[index].title,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _isCardSelected = true;
                        _selectedCard = _diagnosticCardList[index].id;
                        _selectedCardIndex = index;
                        _diagnosticTitleText = _diagnosticCardList[index].title;
                        _diagnosticDate =
                            _diagnosticCardList[index].diagnosticDate;
                        _diagnosticClientNameText =
                            _diagnosticCardList[index].clientName;
                      });
                      Navigator.of(context).pop();
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

  _buildReportHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${ReportsScreenMessages.reportHeaderDiagnosticText} $_diagnosticTitleText',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          '${ReportsScreenMessages.reportHeaderDiagnosticDateText} ${_diagnosticDate == null ? ReportsScreenMessages.diagnosticDateDefaultText : DateFormat('dd MMMM yyyy').format(_diagnosticDate)}',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          '${ReportsScreenMessages.reportHeaderDiagnosticClientText} $_diagnosticClientNameText',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          '${ReportsScreenMessages.reportHeaderReportTypeText} $_reportTypeText',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  _buildReportContent() {
    switch (_reportType) {
      case 'MAIN_REPORT':
        List<Widget> _content = [];
        List<Widget> _prayers = [];
        _prayersList = [];
        setPrayersList();
        for (int i = 0;
            i < _diagnosticCardList[_selectedCardIndex].points.length;
            i++) {
          if (_diagnosticCardList[_selectedCardIndex].points[i]['point'] != 0) {
            _content.add(RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black,
                  height: 1.6,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text:
                        '${_diagnosticCardList[_selectedCardIndex].points[i]['code']}',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: ' - ',
                    style: TextStyle(),
                  ),
                  TextSpan(
                    text:
                        '${_diagnosticCardList[_selectedCardIndex].points[i]['point']}, ',
                    style: TextStyle(),
                  ),
                ],
              ),
            ));
          }
        }
        for (int i = 0; i < _prayersList.length; i++) {
          _prayers.add(ListTile(
            contentPadding:
                EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
            title: Text(_prayersList[i]),
          ));
          _prayers.add(Divider(
            height: 16.0,
            color: Theme.of(context).primaryColor.withOpacity(0.25),
          ));
        }
        return Flexible(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Результат диагностики:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Wrap(
                  children: _content,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Стратегии исцеления:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Column(
                  children: _prayers,
                ),
              ],
            ),
          ),
        );
        break;
      default:
        return Container();
        break;
    }
  }
}
