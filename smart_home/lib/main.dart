import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/core/adapter_android_mp.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_line_data_set.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/legend_form.dart';
import 'package:mp_chart/mp/core/enums/limit_label_postion.dart';
import 'package:mp_chart/mp/core/highlight/highlight.dart';
import 'package:mp_chart/mp/core/limit_line.dart';
import 'package:mp_chart/mp/core/marker/i_marker.dart';
import 'package:mp_chart/mp/core/marker/i_marker.dart';
import 'package:mp_chart/mp/core/marker/i_marker.dart';
import 'package:mp_chart/mp/core/marker/i_marker.dart';
import 'package:mp_chart/mp/core/marker/i_marker.dart';
import 'package:mp_chart/mp/core/marker/i_marker.dart';
import 'package:mp_chart/mp/core/marker/line_chart_marker.dart';
import 'package:mp_chart/mp/core/poolable/point.dart';
import 'package:mp_chart/mp/core/utils/color_utils.dart';
import 'package:mp_chart/mp/core/utils/painter_utils.dart';
import 'package:mp_chart/mp/core/value_formatter/value_formatter.dart';
import 'package:mp_chart/mp/core/marker/i_marker.dart';
import 'package:mp_chart/mp/core/view_port.dart';
import 'package:smart_home/main_card.dart';

import 'SecondaryCard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseOptions firebaseOptions = FirebaseOptions(
    appId: '1:19218219107:android:72ff1602d2306ef4163856',
    apiKey: 'AIzaSyCzsdLJV0FLRdX6SH0jzwbcNav8Ec7Uvbc',
    projectId: 'smart-home-c4ea7',
    messagingSenderId: '19218219107',
    databaseURL: 'https://smart-home-c4ea7.firebaseio.com/',
  );

  FirebaseApp firebaseApp;

  if (Firebase.apps.length == false) {
    firebaseApp = await Firebase.initializeApp(
      name: 'smart-home-c4ea7',
      options: firebaseOptions,
    );
  }

  runApp(MaterialApp(
    title: 'Flutter Database Example',
    home: MyHomePage(app: firebaseApp, title: "Smart Home 2"),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        home: Container(
          child: MyHomePage(title: 'Smart Home'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.app, this.title});
  final FirebaseApp app;

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _temperatureStreet = 0.0;
  double _temperatureWater = 0.0;

  double _maxValueTemperatureStreet = 0.0;
  double _minValueTemperatureStreet = 0.0;
  String _minValueTemperatureStreetTime = "";
  String _maxValueTemperatureStreetTime = "";

  List<int> valuesTimes = List<int>();
  List<double> valuesTemperatures = List<double>();

  String _time = "";

  Query _temperatureStreetQuery;
  Query _temperatureStreetArrayQuery;
  Query _temperatureWaterQuery;

  LineChartController controller;

  @override
  void initState() {
    super.initState();


    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);

    _temperatureStreetQuery = database
        .reference()
        .child("Temperatures")
        .child("TemperatureStreet")
        .limitToLast(1);

    _temperatureStreetArrayQuery = database
        .reference()
        .child("Temperatures")
        .child("TemperatureStreet")
        .limitToLast(500);

    _temperatureWaterQuery = database
        .reference()
        .child("Temperatures")
        .child("TemperatureWater")
        .limitToLast(1);

    _temperatureStreetQuery.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      print("_temperatureStreetQuery size " + values.length.toString());
      print("last time " + values.keys.toList().first.toString());


      values.values.toList().forEach((element) {
        print("_temperatureStreetQuery element " + element.toString());

        if(element is double){
          setState(() {
            print("last temp " + element.toString());
            _temperatureStreet = element;
          });
        }
      });

    });

    _temperatureWaterQuery.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      print("_temperatureWaterQuery size " + values.length.toString());

      print("last time " + values.keys.toList().first.toString());

      setState(() {

        values.values.toList().forEach((element) {
          print("_temperatureWaterQuery element " + element.toString());

          if(element is double){
            setState(() {
              print("last temp " + element.toString());
              _temperatureWater = element;
            });
          }
        });

        var date = DateTime.fromMillisecondsSinceEpoch(
            int.parse(values.keys.toList().last) * 1000,
            isUtc: true);

        String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(date);
        _time = formattedDate;
      });
    });

    _temperatureStreetArrayQuery.once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;

      setState(() {

        values.forEach((key, value) {
          valuesTimes.add(int.parse(key));
          valuesTemperatures.add(double.parse(value.toString()));
        });

        _maxValueTemperatureStreet = valuesTemperatures.reduce(max);
        _minValueTemperatureStreet = valuesTemperatures.reduce(min);

        valuesTimes.sort((a, b) => a.compareTo(b));

        var timestampMaxTemp = values.keys.firstWhere((k) => values[k] == _maxValueTemperatureStreet, orElse: () => null);
        var timestampMinTemp = values.keys.firstWhere((k) => values[k] == _minValueTemperatureStreet, orElse: () => null);

        _maxValueTemperatureStreetTime = timestampToDateTime(int.parse(timestampMaxTemp));
        _minValueTemperatureStreetTime = timestampToDateTime(int.parse(timestampMinTemp));

        _initLineData(values);
      });

    });

    _initController();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.blue,
      body: Container(
          constraints: BoxConstraints.expand(),
              child: Column(
                children: [
                  Container(
                        margin: EdgeInsets.only(top: 10.0),
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width * 1,
                        child: _initLineChart(),
                      ),

                  Container(
                    margin: EdgeInsets.only(bottom: 75.0,left: 18,right: 18),
                        child: Column(
                          children: [
                            Row(
                            children: [
                              MainCard(_temperatureWater.toStringAsFixed(2),"Temperature Water"),
                              MainCard(_temperatureStreet.toStringAsFixed(2),"Temperature Street"),
                            ],
                          ),
                            Row(
                              children: [
                                SecondaryCard(_minValueTemperatureStreet.toStringAsFixed(2),"Minimum Temperature Street",_minValueTemperatureStreetTime),
                                SecondaryCard(_maxValueTemperatureStreet.toStringAsFixed(2),"Maximum Temperature Street",_maxValueTemperatureStreetTime),
                              ],
                            ),
                          ],
                        ),

                  ),
                  Container(
                      alignment: Alignment.bottomRight,

                      margin: EdgeInsets.only(bottom: 15.0,right: 18),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,

                          children:[
                            Container(
                              child: Text(
                                'Last time at updated    ',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.normal
                                ),
                              ),
                            ),
                            Container(
                                child: Text(
                                  '$_time',
                                  style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.normal
                                  ),
                                ),
                            )
                          ]
                      )
                  )
                ],
              ),
        )
    );
  }

  void _initController() {
    var desc = Description()..enabled = false;

    TimeFormatter timeFormatter =  TimeFormatter();
    timeFormatter.valuesTimes = valuesTimes;

    MyMarker myMarker = MyMarker();
    myMarker._timeFormatter = timeFormatter;

    controller = LineChartController(
        axisRightSettingFunction: (axisRight, controller) {
          axisRight.enabled = false;

        },
        legendSettingFunction: (legend, controller) {
        },
        xAxisSettingFunction: (xAxis, controller) {
          xAxis.enabled = false;
        },
        axisLeftSettingFunction: (axisLeft, controller) {
          axisLeft
            ..setAxisMaximum(_maxValueTemperatureStreet + 5.0)
            ..setAxisMinimum(_minValueTemperatureStreet + -5.0);
        },
        drawGridBackground: false,
        backgroundColor: Colors.transparent,
        gridBackColor: Colors.transparent,
        marker: myMarker,
        dragXEnabled: false,
        dragYEnabled: false,
        scaleXEnabled: false,
        scaleYEnabled: false,
        pinchZoomEnabled: false,
        description: desc);
  }

  void _initLineData(Map<dynamic, dynamic> valuesMap) async {

    List<Entry> values = List();

    valuesTimes.asMap().forEach((index,time) {
      var value = valuesMap[time.toString()];

      var val = 0.0;

      if(value is double){
        val = value;
      }
      else if(value is int){
        val = value.toDouble();
      }

      values.add(Entry(x: index.toDouble(), y: val));
    });

    LineDataSet set1;

    set1 = LineDataSet(values, "DataSet 1");

    set1.setDrawIcons(false);

    set1.setColor1(ColorUtils.WHITE);
    set1.setCircleColor(ColorUtils.WHITE);
    set1.setLineWidth(3);
    set1.setDrawCircles(false);
    set1.setFormLineWidth(3);
    set1.setValueTextSize(0);

    List<ILineDataSet> dataSets = List();
    dataSets.add(set1);
    controller.data = LineData.fromList(dataSets);

    setState(() {});
  }

  Widget _initLineChart() {
    var lineChart = LineChart(controller);
    controller.animator
      ..reset()
      ..animateX1(1500);
    return lineChart;
  }
}

class MyMarker extends LineChartMarker {
  Entry _entry;
  TimeFormatter _timeFormatter;
  DegreesFormatter degreesFormatter = DegreesFormatter();
  @override
  void draw(Canvas canvas, double posX, double posY) {
    TextPainter painter = PainterUtils.create(
        null,
        "${_timeFormatter.getFormattedValue1(_entry.x)} ${degreesFormatter.getFormattedValue1(_entry.y)}",
        Colors.black,
        14);
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    MPPointF offset = getOffsetForDrawingAtPoint(posX, posY);

    canvas.save();
    painter.layout();
    Offset pos = calculatePos(posX + offset.x, posY + offset.y, painter.width, painter.height);
    canvas.drawRRect(RRect.fromLTRBR(pos.dx - 5, pos.dy - 5, pos.dx + painter.width + 5, pos.dy + painter.height + 5, Radius.circular(5)), paint);
    painter.paint(canvas, pos);
    canvas.restore();
  }

  @override
  void refreshContent(Entry e, Highlight highlight) {
    _entry = e;
    highlight = highlight;
  }
}

class DegreesFormatter extends ValueFormatter {

  DegreesFormatter() : super();

  @override
  String getFormattedValue1(double value) {
    return "$value ℃";
  }
}

class TimeFormatter extends ValueFormatter {
  List<int> valuesTimes = List<int>();

  TimeFormatter() : super();

  @override
  String getFormattedValue1(double value) {

    int index = value.toInt();
    return timestampToDateTime(valuesTimes[index]);
  }
}

String timestampToDateTime(int value){
  var date = DateTime.fromMillisecondsSinceEpoch(
      value * 1000 ,
      isUtc: true);

  return DateFormat('yyyy-MM-dd HH:mm').format(date);
}
