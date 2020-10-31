import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF75A2EA);
const kGreyColor = const Color(0xFF939393);

const kBottomNavIconSize = 24.0;
const kBottomNavbarHeight = 60.0;
const kBottomNavIconColor = Colors.white;

const kInputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(30.0),
    ),
    borderSide: BorderSide(
      color: kPrimaryColor,
      width: 2.0,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(30.0),
    ),
    borderSide: BorderSide(
      color: kPrimaryColor,
      width: 2.0,
    ),
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 8.0),
);
