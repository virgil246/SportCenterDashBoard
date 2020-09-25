import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

import 'Indicator.dart';

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
      title: '國民運動中心在館人數',
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
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
  List<PieChartSectionData> showingSections(List<dynamic> data) {
    final double radius = 30;
    List<double> doubledata = (data.map((e) => double.parse(e)).toList());
    return List.generate(2, (index) {
      switch (index) {
        case 0:
          return PieChartSectionData(
              radius: radius,
              value: doubledata[0],
              color: Colors.red,
              title: data[0].toString());
        case 1:
          return PieChartSectionData(
              radius: radius,
              value: doubledata[1] - doubledata[0],
              color: Colors.green,
              title: (doubledata[1] - doubledata[0]).toString());
        default:
          return null;
      }
    });
  }

  List<Widget> createPie(dynamic data) {
    double centerSpaceRadius = 50;
    return List.generate(data.length, (index) {
      switch (index) {
        case 0:
          return Expanded(
            child: Stack(children: [
              Center(
                child: Text("健身房",style: TextStyle(fontSize: 22),),
              ),
              PieChart(
                PieChartData(
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: centerSpaceRadius,
                    sections: showingSections(
                        data["gym"] != null ? data["gym"] : null)),
              ),
            ]),
          );
        case 1:
          return Expanded(
            child: Stack(children: [
              Center(child: Text("游泳池",style: TextStyle(fontSize: 22))),
              PieChart(
                PieChartData(
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: centerSpaceRadius,
                    sections: showingSections(
                        data["swim"] != null ? data["swim"] : null)),
              ),
            ]),
          );
        case 2:
          return Expanded(
            child: Stack(children: [
              Center(child: Text("溜冰場",style: TextStyle(fontSize: 22))),
              PieChart(
                PieChartData(
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: centerSpaceRadius,
                    sections: showingSections(
                        data["ice"] != null ? data["ice"] : null)),
              ),
            ]),
          );
        default:
          return null;
      }
    });
  }

  Future<dynamic> getData() async {
    var r = await Dio().get("https://cors-anywhere.herokuapp.com/" +
        widget.sportcenter.uri +
        "api");

    // print(json.decode(r.data)["gym"]);

    return json.decode(r.data);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Expanded(
          flex: 1,
          child: Text(
            widget.sportcenter.zHname,
            style: TextStyle(fontSize: 30),
          ),
        ),
        Expanded(
          flex: 4,
          child: FutureBuilder(
            future: getData(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.done) {
                {
                  return Row(
                      children: createPie(snap.data) +
                          [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                Indicator(
                                  color: Colors.green,
                                  text: '剩餘可容納人數',
                                  isSquare: false,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Indicator(
                                  color: Colors.red,
                                  text: '在館人數',
                                  isSquare: false,
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            )
                          ]);
                }
              }
              return Center(child: CircularProgressIndicator());
            },
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
