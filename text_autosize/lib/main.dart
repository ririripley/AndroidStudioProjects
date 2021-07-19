import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;


void main() {
  runApp(MyApp());
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
    var data = "abcdsassaasdooo.PNG";
    var fileName = "abcdaddfddsbsfwsssshij";
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Text(
                    data.split(path.extension(data))[0],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 40),
                    // style: Theme.of(context).textTheme.caption,
                  ),
                ),

                Text(
                  path.extension(data),
                  style: TextStyle(fontSize: 40),
                  // style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
            autoSizeWidget(fileName),
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
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}


Widget autoSizeWidget(String fileName) {
  return Container(
    child:
    Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: Text(
            fileName.length > 8 ? fileName.substring(0, fileName.length - 8) : fileName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 40),
            // style: Theme.of(context).textTheme.caption,
          ),
        ),

        Text(
          fileName.length > 8 ? fileName.substring(fileName.length - 8) : '',
          style: TextStyle(fontSize: 40),
          // style: Theme.of(context).textTheme.caption,
        ),
      ],
    ),
    // Row(
    //   children: <Widget>[
    //     Flexible(
    //       child: Text(
    //         fileName.length > 8 ? fileName.substring(0, fileName.length - 8) : fileName,
    //         maxLines: 1,
    //         textAlign: TextAlign.left,
    //         overflow: TextOverflow.ellipsis,
    //         style: TextStyle(fontSize: 40),
    //       ),
    //     ),
    //     Flexible(
    //       child:
    //     Text(
    //         fileName.length > 8 ? fileName.substring(fileName.length - 8) : '',
    //         maxLines: 1,
    //         textAlign: TextAlign.left,
    //         style: TextStyle(fontSize: 40),
    //       ),
    //     ),
    //   ],
    // )
  );
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




