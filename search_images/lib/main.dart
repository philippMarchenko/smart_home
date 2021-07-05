import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.blueGrey,
        child: Center(

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 60.0,
                backgroundImage: NetworkImage("https://pixabay.com/get/g7cdc49d62f7c1f6b8dc42126580894fe5accdd08a2d3e3975426e1eeeff36e43f666860b7c35a67977e10d1b0e8e642e99db38d6a04a9d4ca489635031c05ccf_640.jpg"),
              ),
              SizedBox(
                height: 20.0,
                width: 150.0,
                child: Divider(
                  color: Colors.tealAccent,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red[500],
                    ),
                    color: Colors.yellow,
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                alignment: Alignment.center,
                margin:  EdgeInsets.symmetric(vertical: 20.0,horizontal: 25.0),
                padding: EdgeInsets.all(15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone,
                      size: 20.0 ,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),

                    Text("+44 545 64 6469",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Source Sans Pro",
                        fontSize: 20.0
                      ),
                    )
                  ]
                ),
              ),
              Container(
                height: 60.0,
                margin:  EdgeInsets.symmetric(vertical: 0.0,horizontal: 25.0),

                child: Card(
                    color: Colors.yellow,
                    shadowColor: Colors.green,
                    elevation: 20.0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.red, width: 1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(0.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.email,
                          size: 20.0 ,
                          color: Colors.red,
                        ),
                        title: Text("ffff@wge.weg",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Source Sans Pro",
                              fontSize: 20.0
                          ),
                        ),
                      )
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
