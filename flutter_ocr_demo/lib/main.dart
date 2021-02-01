import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Img;
import 'package:path_provider/path_provider.dart';
import 'dart:async';


void main() {
  // Read a jpeg image from file.
 // String path = 'test_compressed.jpeg'
 // print(CheckFileSize.check(path, 2000));
  print("haah");
  WidgetsFlutterBinding.ensureInitialized();
  //var file = new Io.File("whereIam.txt");
  // var path = getLocalFile();
  // print(path);
  final filePath = r"/Users/ripley/AndroidStudioProjects/flutter_ocr_demo/lib/test_compressed2.JPG";
  var newPath = CheckFileSize.check(filePath, 2000);
  print(newPath);
}


Future<File> getLocalFile() async {
  // 获取文档目录的路径
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String dir = appDocDir.path;
  final file = new File('$dir/test_compressed2.jpeg');
  return file;
}





class CheckFileSize {

  static Future<String> check(String filePath, int maxLength) async {

    Img.Image image = Img.decodeImage(new File(filePath).readAsBytesSync());
    int maxSide = image.height > image.width ? image.height : image.width;
    if(maxSide <= maxLength)
      return filePath;

    Img.Image newImg = null;

    if(image.height > image.width) {
      final double scaleH = image.width / image.height;
      newImg = Img.copyResize(image, height: maxLength, width: (maxLength * scaleH).round());
    }
    else {
      final double scaleW = image.height / image.width;
      newImg = Img.copyResize(image, width: maxLength, height: (maxLength * scaleW).round());
    }

    // Save the compressed image as a JPEG.
    String newPath = (await getTemporaryDirectory()).path + "/newimg.jpeg";
    print(newPath);
    new File(newPath)
      ..writeAsBytesSync(Img.encodeJpg(newImg,quality: 90));
    return newPath;
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
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//         // This makes the visual density adapt to the platform that you run
//         // the app on. For desktop platforms, the controls will be smaller and
//         // closer together (more dense) than on mobile platforms.
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
