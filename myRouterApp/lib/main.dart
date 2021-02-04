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
      initialRoute: "/",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes:{
        /// “命名路由”（Named Route）
        /// Map<String, WidgetBuilder> routes;
        "new_page":(context) => NewRoute(),
        "/": (context) => MyHomePage(title: 'Flutter Demo Home Page'),
      } ,
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}




/// Navigator Push Example
class RouterTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("I am built again!");
    String result =  "None";
    return Center(
      child: RaisedButton(
        onPressed: () async {
          // 打开`TipRoute`，并等待返回结果
          print("1");
           result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                print("I am inside the await now!");
                return TipRoute(
                  // 路由参数
                  text: "我是提示xxxx",
                );
              },
            ),
          );
          // 此处result 需要等到异步await返回（即TipRoute pop才会赋值，且每次pop不会重新调用RouterTestRoute的build函数重新渲染）
          // 每次点击RaisedButton之后出发onPressed 的异步函数，知道TipRoute pop异步函数的结果才返回，然后继续执行接下来的函数
          print("2");
          //输出`TipRoute`路由返回结果
          print("路由返回值: $result");
        },
        child: Text(result),
      ),
    );
  }
}


/// Navigator Pop Example
class TipRoute extends StatelessWidget {
  TipRoute({
    Key key,
    @required this.text,  // 接收一个text参数
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    print("The popped page is built again!");
    return Scaffold(
      appBar: AppBar(
        title: Text("提示"),
      ),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(text),

              /// bool pop(BuildContext context, [ result ])
              /// 将栈顶路由出栈，result为页面关闭时返回给上一个页面的数据。
              RaisedButton(
                onPressed: () => Navigator.pop(context, "返回给future"),
                child: Text("返回"),
              )
            ],
          ),
        ),
      ),
    );
  }
}



class NewRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    String args = ModalRoute.of(context).settings.arguments??" Nothing passed";
    return Scaffold(
      appBar: AppBar(
        title: Text("New route"),
      ),
      body: Center(
        child: Text(args),
      ),
    );
  }
}








//
// class RouterTestRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: RaisedButton(
//         onPressed: () async {
//           // 打开`TipRoute`，并等待返回结果
//           var result = await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) {
//                 return TipRoute(
//                   // 路由参数
//                   text: "我是提示xxxx",
//                 );
//               },
//             ),
//           );
//           //输出`TipRoute`路由返回结果
//           print("路由返回值: $result");
//         },
//         child: Text("打开提示页"),
//       ),
//     );
//   }
// }




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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text("open new route"),
              textColor: Colors.blue,
              onPressed: () {

                /// Named Route Method
                Navigator.pushNamed(context, "new_page", arguments: "I am the value being passed to new Route");
                // /// 导航到新路由
                // /// push:
                // /// 将给定的路由入栈（即打开新的页面），返回值是一个Future对象，用以接收新路由出栈（即关闭）时的返回数据。
                // /// Future push(BuildContext context, Route route)
                // /// Navigator.push(BuildContext context, Route route) 等价于 Navigator.of(context).push(Route route)
                // Navigator.push( context,
                //     MaterialPageRoute(builder: (context) {
                //       return NewRoute();
                //     }));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
L