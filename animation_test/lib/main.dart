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
      home: FlutterAnimationWidget(),
    );
  }
}

class FlutterAnimationWidget extends StatefulWidget {
  @override
  _FlutterAnimationWidgetState createState() => _FlutterAnimationWidgetState();
}

class _FlutterAnimationWidgetState extends State<FlutterAnimationWidget> with TickerProviderStateMixin {
  AnimationController _animationController;
  double _marginTop;

  @override
  void initState() {
    super.initState();
    _marginTop = 0;
    _animationController = AnimationController(duration: Duration(milliseconds: 300), lowerBound: 0, upperBound: 50, vsync: this)..addListener(() {
      setState(() {
        _marginTop = _animationController.value;
      });
    });
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) print("动画完成");
    });
  }

  void startEasyAnimation() {
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 200,
              height: 50,
              color: Colors.orangeAccent,
              margin: EdgeInsets.only(top: _marginTop),
            ),
            FlatButton(
              onPressed: startEasyAnimation,
              child: Text(
                "点击执行最简单动画",
                style: TextStyle(color: Colors.black38),
              ),
            ),
          ],
        ),
      ),
    );
  }
}