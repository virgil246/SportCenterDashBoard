import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

List<SportCenterList> sportCenterListFromJson(String str) =>
    List<SportCenterList>.from(
        json.decode(str).map((x) => SportCenterList.fromJson(x)));

String sportCenterListToJson(List<SportCenterList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SportCenterList {
  SportCenterList({
    this.zHname,
    this.uri,
  });

  String zHname;
  String uri;

  factory SportCenterList.fromJson(Map<String, dynamic> json) =>
      SportCenterList(
        zHname: json["ZHname"],
        uri: json["Uri"],
      );

  Map<String, dynamic> toJson() => {
        "ZHname": zHname,
        "Uri": uri,
      };
}

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getData,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class PeoplePieChart extends StatefulWidget {
  SportCenterList sportcenter;
  PeoplePieChart({this.sportcenter});

  @override
  _PeoplePieChartState createState() => _PeoplePieChartState();
}

class _PeoplePieChartState extends State<PeoplePieChart> {
  List<int> touchedIndex = new List(2);
  // PeoplePieChart({})
  

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        PieChart(
          PieChartData(
            pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
              setState(() {
                if (pieTouchResponse.touchInput is FlLongPressEnd ||
                    pieTouchResponse.touchInput is FlPanEnd) {
                  touchedIndex[0] = -1;
                } else {
                  touchedIndex[0] = pieTouchResponse.touchedSectionIndex;
                }
              });
            }),
            borderData: FlBorderData(show: false),
            sectionsSpace: 0,
            centerSpaceRadius: 40,
            // read about it in the below section
          ),
        ),
      ],
    ));
  }
}

Future<List> getData() async {
  // var response = await http
  // .get("https://virgil246.github.io/TWSportCenterList/AllSportCenter.json");
  Response response = await Dio().get<String>(
      "https://virgil246.github.io/TWSportCenterList/AllSportCenter.json");
  var sportCenterList = sportCenterListFromJson(response.data);
  print(sportCenterList[0].uri);
  // List<Response> resList = await Future.wait(sportCenterList.map((e) =>
  //     Dio().get("https://cors-anywhere.herokuapp.com/" + e.uri + "api")));
  // print((resList[0].data));
}
