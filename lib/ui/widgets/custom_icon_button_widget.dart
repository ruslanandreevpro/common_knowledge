import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final Function onPress;
  final String buttonTitle;

  const CustomIconButton(
      {Key key,
      @required this.icon,
      @required this.onPress,
      @required this.buttonTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: IconButton(
            icon: Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: onPress,
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          buttonTitle,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.0,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
