import 'package:common_knowledge/utilities/constants.dart';
import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String dividerText;

  const DividerWithText({
    Key key,
    @required this.dividerText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Divider(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
          ),
        ),
        Text(
          dividerText,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Divider(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}
