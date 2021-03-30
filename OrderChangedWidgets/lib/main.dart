import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
//
// void main() {
//   // runApp(Screen());
//   runApp(HomePage());
// }


void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.indigo,
    ),
    home: App(),
  ));
}
// class StatelessContainer extends StatelessWidget {
//   Color color;
//   StatelessContainer(Color color) {this.color = color;}
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 100,
//       height: 100,
//       color: color,
//     );
//   }
// }


///1.  Change the Order of Widgets in a Row or Coloumn using StatefulWidget
// class Screen extends StatefulWidget {
//   @override
//   _ScreenState createState() => _ScreenState();
// }
//
// class _ScreenState extends State<Screen> {
//   List<Widget> widgets = [
//     StatefulContainer(Colors.red, key: UniqueKey()),
//     StatefulContainer(Colors.blue, key: UniqueKey()),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp( home:
//     Scaffold(
//       body: Center(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: widgets,
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: switchWidget,
//         child: Icon(Icons.undo),
//       ),
//     ));
//   }
//
//   switchWidget(){
//     widgets.insert(0, widgets.removeAt(1));
//     setState(() {});
//   }
// }
//
// class StatefulContainer extends StatefulWidget {
//   StatefulContainer(Color color, {Key key}) : super(key: key) {this.color = color;}
//   Color color;
//   @override
//   _StatefulContainerState createState() => _StatefulContainerState();
// }
//
// class _StatefulContainerState extends State<StatefulContainer> {
//   final Color color = RandomColor().randomColor();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 100,
//       height: 100,
//       color: color,
//     );
//   }
// }

///2 . Valuekey Example
// 使用statefulElement 虽然交换了对应的wiget, 但是对应的state一直还在， 没有被替换
// 注意setState 触发build的时候，返回的已经是全新的widget (new被省略)
// 两个新的widget : MyTextField() 都是新的，然后updateChildren的时候只是更新了element对应的widget,
// 但是element对应的state没有变化，同时，所以结果是第一个element更新了对应的_widget, 然后第二个element由于没有对应的widget
// 被加到inactive element中，后面会被dispose掉。
// 所以最后重新渲染的时候，还是第一个element的 state的build 函数被执行

class MyTextField extends StatefulWidget {
  MyTextField({Key key}) : super(key: key);
  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
    );
  }
}



class MyStatelessTextField extends StatelessWidget {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  bool showFirst = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:
    Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget> [
            /// I'm fucking genius :)!
            /// 注意这个地方使用ValueKey 和 UniqueKey 的结果很不同
            /// 使用UniqueKey的话，之前的element 都会被加入到inactiveList中，对应的state同时也被dispose掉, 然后调用inflateWidget 产生新的element， 无法保留上次的状态
            /// 使用ValueKey， 原来的element 通过排序即可对应上新的key, 所以第二个element得以保存下来
            if(showFirst) MyTextField(key: UniqueKey()),
            MyTextField(key: UniqueKey()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton (
          child: Icon(Icons.add),
          onPressed: (){
            setState(() {
              showFirst = !showFirst;
            });
          }),
    ),);

  }
}

/// 3. Global Key Example : can be used to access widgets in other widget tree
/// In this case, we are actually making use of key so as to store the state in a map which we
/// could access the data stored in the state for convenience in the future.

/// Attention:
///  Just found that if a page is popped, the old pages would not be rebuilt: the reasons can be explained as follows:
///  We already knew that the build function of navigatorState is to build a widget called Overlay , and Overlay
///  actually build a widget called _theatre which is a multipleobjectWidget owning a list of widgets as its children widget property.
///  Bases on what was mentioned, if a page is popped, what happened was that the length of children widget list decreased by one.
///  So the corresponding element will be deactivated, and that's all.
///
/// OFC, the analysis above is based on the premise that no element is marked as dirty so there is no rebuild phase.
/// If there is any dirty element appearing, the rebuild function will be called.
class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  GlobalKey<_CounterState> _counterState;

  @override
  void initState() {
    super.initState();
    /// Define a global key
    _counterState = GlobalKey();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
            children: <Widget>[
              Counter(
                /// Counter is a StatefulWidget with assigned global key
                key: _counterState,
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.navigate_next),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              /// Page1 is passed with a globalkey
              return Page1(_counterState);
            }),
          ).then((value) => this.setState(() {}));
          /// 注意 push 方法返回的是一个future对象，该future对象会在对应的页面pop的时候执行complete函数，此时then便可以执行
        },
      ),
    );
  }
}

class Counter extends StatefulWidget {
  const Counter({
    Key key,
  }) : super(key: key);
  @override
  _CounterState createState() => _CounterState();
}
class _CounterState extends State<Counter> {
  int count;
  @override
  void initState() {
    super.initState();
    count = 0;
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            setState(() {
              count++;
            });
          },
        ),
        Text(count.toString()),
      ],
    );
  }
}

class Page1 extends StatefulWidget {
  final GlobalKey<_CounterState> counterKey;
  Page1( this.counterKey);
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  widget.counterKey.currentState.count++;
                  print(widget.counterKey.currentState.count);
                });
              },
            ),
            Text(
              widget.counterKey.currentState.count.toString(),
              style: TextStyle(fontSize: 50),
            ),
          ],
        ),
      ),
    );
  }
}