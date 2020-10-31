import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_knowledge/services/database_service.dart';
import 'package:flutter/material.dart';

class DiseasesRefBookScreen extends StatefulWidget {
  final String refBookId, refBookTitle;

  const DiseasesRefBookScreen(
      {Key key, @required this.refBookId, @required this.refBookTitle})
      : super(key: key);

  @override
  _DiseasesRefBookScreenState createState() => _DiseasesRefBookScreenState();
}

class _DiseasesRefBookScreenState extends State<DiseasesRefBookScreen> {
  List _refBook = [];

  void getRefBookContent() async {
    final result =
        await DatabaseService().getDiseasesRefBookContent(widget.refBookId);
    setState(() {
      _refBook = result;
    });
  }

  @override
  void initState() {
    super.initState();
    getRefBookContent();
  }

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
          widget.refBookTitle,
          maxLines: 2,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
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
    );
  }
}

//StreamBuilder(
//stream: _databaseService.getDiseasesRefBook(refBookId),
//builder: (context, snapshot) {
//if (!snapshot.hasData) {
//return SpinKitCircle(
//color: Theme.of(context).primaryColor,
//size: 56.0,
//);
//}
//if (snapshot.data.documents.length == 0) {
//return Center(
//child: AutoSizeText(SharedMessages.emptySnapshot),
//);
//}
//return ListView.builder(
////                  shrinkWrap: true,
//itemCount: snapshot.data.documents.length,
//itemBuilder: (BuildContext context, int index) {
//final _refBook = DiseasesRefBook.fromSnapshot(
//snapshot.data.documents[index]);
//return Column(
//children: _buildRefBookItem(context, _refBook),
//);
//},
//);
//},
//),

//List<Widget> _buildRefBookItem(BuildContext context, _refBook) {
//  List<Widget> codes = [];
//  codes.add(_buildRefBookItemCard(context, _refBook));
//  if (_refBook.content.length > 0) {
//    for (int i = 0; i < _refBook.content.length; i++) {
//      codes.add(_buildRefBookItemCodes(context, _refBook, i));
//    }
//  }
//  return codes;
//}
//
//Widget _buildRefBookItemCard(BuildContext context, _refBook) {
//  return Card(
//    color: Theme.of(context).primaryColor,
//    child: ListTile(
//      leading: Container(
//        padding: EdgeInsets.all(8.0),
//        child: Text(
//          _refBook.id,
//          style: TextStyle(
//            color: Colors.white,
//          ),
//        ),
//      ),
//      title: Text(
//        _refBook.title,
//        style: TextStyle(
//          fontWeight: FontWeight.w500,
//          color: Colors.white,
//        ),
//      ),
//    ),
//  );
//}
//
//Widget _buildRefBookItemCodes(BuildContext context, _refBook, int index) {
//  return Container(
//    padding: EdgeInsets.symmetric(
//      vertical: 0.0,
//      horizontal: 8.0,
//    ),
//    child: ListTile(
//      leading: Text(
//        _refBook.content[index]['code'],
//        style: TextStyle(
//          color: Theme.of(context).primaryColor,
//        ),
//      ),
//      title: Text(
//        _refBook.content[index]['title'],
//        style: TextStyle(
//          color: Theme.of(context).primaryColor,
//        ),
//      ),
//    ),
//  );
//}
