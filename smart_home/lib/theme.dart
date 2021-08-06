import 'package:flutter/material.dart';


class ThemeProvider{
  ThemeData get theme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue, //Changing this will change the color of the TabBar
    accentColor: Colors.blue[700],
  );
}