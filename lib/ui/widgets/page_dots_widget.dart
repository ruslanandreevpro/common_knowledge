import 'package:flutter/material.dart';

class PageDots extends StatelessWidget {
  final bool isActive;

  PageDots({this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      height: isActive ? 10 : 8,
      width: isActive ? 10 : 8,
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColorDark : Colors.white,
        border: isActive
            ? Border.all(
                color: Colors.transparent,
                width: 2.0,
              )
            : Border.all(
                color: Theme.of(context).primaryColorDark,
                width: 1,
              ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
