import 'package:flutter/material.dart';
import 'customized_expansiontile.dart';
/// Animation
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     // return new FocusTestRoute();
//     return new MaterialApp(
//       title: "Home Page",
//       home: new MyHomePage('Ripley'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   final String title;
//   MyHomePage(this.title);
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage>
//     with SingleTickerProviderStateMixin {
//   /// 一个抽象类，仅仅知道当前的动画插值和状态（complete，dismissed）。
//   /// Animation对象是一个在一段时间内，依次生成一个区间值的类，其输出值是线性的，非线性的，
//   /// 也可以是一个步进函数或者其他曲线函数。控制器可以决定Animation动画的运行方式：正向，反向以及在中间进行切换.
//   /// Animation也可以生成除double之外的其他值，比如Animation或Animation
//   Animation<double> animation;
//
//   /// Animation是由AnimationController管理的，并通过Listeners和StateListeners管理动画状态所发生的变化。
//   /// AnimationController即动画控制器，它负责在给定的时间段内，以线性的方式生成默认区间为（0.0，1.0）的数字。
//   /// ,它能告诉Flutter动画的控制器已经创建好对象了，并且处于准备状态。要真正让动画运作起来，
//   /// 则需要通过AnimationController的forward()方法来启动动画。其中，数值的产生取决与屏幕的刷新情况，一般每秒60帧。
//   /// 数值生成以后，每个Animation对象都会通过Listener进行回调。
//
//   AnimationController controller;
//   /// The generation of numbers is tied to the screen refresh,
//   /// so typically 60 numbers are generated per second.
//   /// After each number is generated, each Animation object calls the attached Listener objects.
//   /// To create a custom display list for each child, see RepaintBoundary.
//
//
//   /// tween is used to map value
//   /// animation is used to generate values in certain ways
//   /// controller is used to control the animation with forward, reverse ... method
//   initState() {
//     super.initState();
//     controller = AnimationController(
//         duration: const Duration(milliseconds: 2000), vsync: this);
//     ///虽然Tween不会存储任何状态信息，但它给我们提供了evaluate(Animation animation)方法，
//     ///并可以通过映射获取动画当前值。Animation当前值可以通过value方法来获取。
//     ///evaluate还能执行其他处理，比如确保动画值分别为0.0和1.0时，返回开始和结束状态。若要使用Tween对象，需要调用animate方法，并传入一个控制器对象。
//     animation = Tween(begin: 0.0, end: 300.0).animate(controller)
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           //动画在结束时停止的状态
//           controller.reverse(); //颠倒
//         } else if (status == AnimationStatus.dismissed) {
//           //动画在开始时就停止的状态
//           controller.forward(); //向前
//         }
//       })
//       ..addListener(() {
//         setState(() {});
//       });
//     controller.forward();
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     // TODO: implement dispose
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Container(
//         height: animation.value,
//         margin: EdgeInsets.symmetric(vertical: 10.0),
//         width: animation.value,
//         child: FlutterLogo(),
//       ),
//     );
//   }
// }
//
/// ExpansionTile

class ExpansionTileSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('ExpansionTile'),
        ),
        body: new ListView.builder(
          itemBuilder: (BuildContext context, int index) => new EntryItem(data[index]),
          itemCount: data.length,
        ),
      ),
    );
  }
}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);
  final String title;
  final List<Entry> children;
}

// Data To Display
final List<Entry> data = <Entry>[
  new Entry('Chapter A',
    <Entry>[
      new Entry('Section A0',
        // <Entry>[
        //   new Entry('Item A0.1'),
        //   new Entry('Item A0.2'),
        //   new Entry('Item A0.3'),
        // ],
      ),
      new Entry('Section A1'),
      new Entry('Section A2'),
    ],
  ),
  new Entry('Chapter B',
    <Entry>[
      new Entry('Section B0'),
      new Entry('Section B1'),
    ],
  ),
  new Entry('Chapter C',
    <Entry>[
      new Entry('Section C0'),
      new Entry('Section C1'),
      new Entry('Section C2',
        // <Entry>[
        //   new Entry('Item C2.0'),
        //   new Entry('Item C2.1'),
        //   new Entry('Item C2.2'),
        //   new Entry('Item C2.3'),
        // ],
      ),
    ],
  ),
];

// Widget to display the data
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty)
      return new ListTile(title: new Text(root.title));
    return new CustomizedExpansionTile(
      dividerColor: Colors.black26,
      dividerDisplayTime: DividerDisplayTime.closed,
      enableTopDivider: false,
      enableBottomDivider: true,
      key: new PageStorageKey<Entry>(root),
      title: Container(
        child: Row(
          children: <Widget>[
            Container(width: 98,
            child: new Text(root.title,
              style: TextStyle(fontSize: 16),),),
            Container(width: 18,),
            Icon(Icons.arrow_drop_down_rounded,size: 80,),
            Container(width: 200,),
          ],
        ),
      ),

      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}

void main() {
  runApp(new ExpansionTileSample());
}
