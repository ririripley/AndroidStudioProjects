import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:html';
import 'dart:async';

Future printDailyNewsDigest() async {
  print('printDailyNewsDigest 1');//1
  String news = await gatherNewsReports();
  print('printDailyNewsDigest 2');//7
  print(news);//8
}

int main() {
  printDailyNewsDigest();
  printWinningLotteryNumbers();//3
  printWeatherForecast();//4
  printBaseballScore();//5
  return 0;
}

void printWinningLotteryNumbers() {
  print('Winning lotto numbers: [23, 63, 87, 26, 2]');
}

void printWeatherForecast() {
  print('Tomorrow\'s forecast: 70F, sunny.');
}

void printBaseballScore() {
  print('Baseball score: Red Sox 10, Yankees 0');
}

// Imagine that this function is more complex and slow. :)
Future gatherNewsReports() async {
  print('gatherNewsReports1');//2
  String path = 'https://www.dartlang.org/f/dailyNewsDigest.txt';
  var result = await HttpRequest.getString(path);
  print('gatherNewsReports2');//6
  return result;
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
    return Visibility(
      visible: true,
      maintainState: true,
      child: Container(
          color: Colors.black.withOpacity(0.05),
          child: Row(
            children: <Widget>[
              Container(
                width: 10,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 20,
                  )),
              Expanded(
                flex: 9,
                child:Padding(
                  padding: EdgeInsets.only(left: 3),
                  child: Text(
                      '已开启企业外查看，7天后到期ffwefwefwefefe',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white
                              .withOpacity(0.6)),
                      maxLines: 1),
                ),),
              // Container(
              //   width: 30,
              // ),
              //docAdvSettingModuleEditable
              Expanded(
                flex:3,
                child: Visibility(
                    visible: true,
                    maintainState: true,
                    child: CupertinoButton(
                        child: Padding(
                            padding: EdgeInsets.only(right: 2),
                            child: Text('修改',
                                style: TextStyle(fontSize: 15, color: Colors.blue),
                                maxLines: 1)),
                        onPressed: () {return null;}
                    )),
              ),
            ],
          )),
    );


  }
}