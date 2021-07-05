import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondaryCard extends StatelessWidget {

  String text1;
  String text2;
  String time;

  SecondaryCard(String text1,String text2,String time){
    this.text1 = text1;
    this.text2 = text2;
    this.time = time;

  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child:  Container(
      margin: EdgeInsets.only(top: 15.0),

      height: 120,
      child: Card(

          color: Colors.blue[700],
          elevation: 8.0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: EdgeInsets.only(top: 5.0,left: 8,right: 8),
                alignment: Alignment.topCenter,
                child: Text(
                  "$text2",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
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
                margin: EdgeInsets.only(bottom: 5.0),
                child:  Text(
                  "Time $time",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
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
