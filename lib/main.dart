import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

import 'test.dart';

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
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // return Center(child: PieChartSample2());
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 2 / 1),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return PeoplePieChart(sportcenter: snapshot.data[index]);
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
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
    return Card(
        color: Colors.red,
        child: Row(
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                    borderData: FlBorderData(show: true),
                    sectionsSpace: 0,
                    centerSpaceRadius: 20,
                    sections: [
                      PieChartSectionData(
                          color: Colors.amber,
                          value: 50,
                          title: "40%",
                          radius: 20),
                      PieChartSectionData(
                          color: Colors.green,
                          value: 40,
                          title: "40%",
                          radius: 20)
                    ]),
              ),
            ),
            Expanded(
              child: PieChart(
                PieChartData(
                    borderData: FlBorderData(show: true),
                    sectionsSpace: 0,
                    centerSpaceRadius: 20,
                    sections: [
                      PieChartSectionData(
                          color: Colors.amber,
                          value: 50,
                          title: "40%",
                          radius: 20),
                      PieChartSectionData(
                          color: Colors.green,
                          value: 40,
                          title: "40%",
                          radius: 20)
                    ]),
              ),
            ),
            Expanded(
              child: PieChart(
                PieChartData(
                    borderData: FlBorderData(show: true),
                    sectionsSpace: 0,
                    centerSpaceRadius: 20,
                    sections: [
                      PieChartSectionData(
                          color: Colors.amber,
                          value: 50,
                          title: "40%",
                          radius: 20),
                      PieChartSectionData(
                          color: Colors.green,
                          value: 40,
                          title: "40%",
                          radius: 20)
                    ]),
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
  return sportCenterList;
  // List<Response> resList = await Future.wait(sportCenterList.map((e) =>
  //     Dio().get("https://cors-anywhere.herokuapp.com/" + e.uri + "api")));
  // print((resList[0].data));
}
