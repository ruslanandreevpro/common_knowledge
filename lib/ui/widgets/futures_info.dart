import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_knowledge/utilities/constants.dart';
import 'package:common_knowledge/utilities/vocabulary.dart';
import 'package:flutter/material.dart';

Future showFuturesInfo(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: <Widget>[
            Icon(
              Icons.info,
              size: 24.0,
              color: Theme.of(context).primaryColorDark,
            ),
            SizedBox(
              width: 8.0,
            ),
            Text(
              SharedMessages.futuresInfoLabelText,
              style: TextStyle(
                fontSize: 20.0,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ],
        ),
        content: AutoSizeText(
          SharedMessages.futuresInfoText,
          maxLines: 3,
          style: TextStyle(
            fontSize: 16.0,
            color: kGreyColor,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
