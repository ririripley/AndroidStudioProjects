import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  GlobalKey<NavigatorState> _key = GlobalKey();
  DateTime _lastPressedAt; //上次点击时间
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: WillPopScope(
          // onWillPop: () async => showDialog(
          //     context: context,
          //     builder: (context) =>
          //         AlertDialog(title: Text('Are you sure you want to quit?'), actions: <Widget>[
          //           RaisedButton(
          //               child: Text('sign out'),
          //               onPressed: () => Navigator.of(context).pop(true)),
          //           RaisedButton(
          //               child: Text('cancel'),
          //               onPressed: () => Navigator.of(context).pop(false)),
          //         ])),
          // child: Container(
          //   alignment: Alignment.center,
          //   child: Text('Click the back button to ask if you want to exit.'),
          // )),

      body:
      WillPopScope(
          // onWillPop: () async {
          //   if (_key.currentState.canPop()) {
          //     _key.currentState.pop();
          //     return false;
          //   }
          //   return true;
          // },
          onWillPop: () async => showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(title: Text('Are you sure you want to quit?'), actions: <Widget>[
                    RaisedButton(
                        child: Text('sign out'),
                        onPressed: () => Navigator.of(context).pop(true)),
                    RaisedButton(
                        child: Text('cancel'),
                        onPressed: () => Navigator.of(context).pop(false)),
                  ])),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Navigator(
                  key: _key,
                  onGenerateRoute: (RouteSettings settings) =>
                      MaterialPageRoute(builder: (context) {
                        return OnePage();
                      }),
                ),
              ),
              Container(
                height: 50,
                color: Colors.blue,
                alignment: Alignment.center,
                child: Text('bottom Bar'),
              )
            ],
          )),
    );
  }
}



class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) :super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Home Page"),
        ),
        body: new Center(
          child: new Text("Home Page"),
        ),
      ),
    );
  }

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
      home: MyHomePage(title: 'Ripley Home Page'),
    );
  }
}



class OnePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      WillPopScope(
        // onWillPop: () async {
        //   if (_key.currentState.canPop()) {
        //     _key.currentState.pop();
        //     return false;
        //   }
        //   return true;
        // },
          onWillPop: () async => showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(title: Text('Are you sure you want to quit?'), actions: <Widget>[
                    RaisedButton(
                        child: Text('sign out'),
                        onPressed: () => Navigator.of(context).pop(false)),
                    RaisedButton(
                        child: Text('cancel'),
                        onPressed: () => Navigator.of(context).pop(false)),
                  ])),
          child:
          Center(
            child: Container(
              child: RaisedButton(
                child: Text('Go to the next page'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TwoPage();
                  }));
                },
              ),
            ),
          ),
      ),


    );
  }
}


class TwoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      WillPopScope(
        // onWillPop: () async {
        //   if (_key.currentState.canPop()) {
        //     _key.currentState.pop();
        //     return false;
        //   }
        //   return true;
        // },
        onWillPop: () async => showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(title: Text('Are you sure you want to quit?'), actions: <Widget>[
                  RaisedButton(
                      child: Text('sign out'),
                      onPressed: () => Navigator.of(context).pop(false)),
                  RaisedButton(
                      child: Text('cancel'),
                      onPressed: () => Navigator.of(context).pop(false)),
                ])),
        child:
        Center(
          child: Container(
            child: Text('This is the second page'),
          ),
        ),
      ),




    );
  }
}
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
