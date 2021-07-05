import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {

  String text1;
  String text2;

  MainCard(String text1,String text2){
    this.text1 = text1;
    this.text2 = text2;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child:  Container(

      height: 140.0,
      child: Card(
          color: Colors.blue[700],
          elevation: 8.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                child: Text(
                  '$text1 ℃',
                  style: TextStyle(
                      color: Colors.white54,
                      fontSize: 38.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
                alignment: Alignment.center,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: 15.0, left: 15.0, right: 15.0),
                child: Text(
                  "$text2",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal
                  ),
                ),
              )
            ],
          )
      ),
    )
    );
  }
}
