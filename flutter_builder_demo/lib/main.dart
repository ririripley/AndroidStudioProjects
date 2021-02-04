import 'package:flutter/material.dart';
import 'stream_builder_demo.dart';
import 'package:flutter_app_km/MyNotification.dart';

void main() async {

  runApp(MyBaseApp());
  // print("A");
  // futurePrint(Duration(milliseconds: 1), "B")
  //     .then((status) => print(status));
  // print("C");
  // futurePrint(Duration(milliseconds: 2), "D") .then((status) => print(status));
  // print("E");
}



class MyBaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:  StreamBuilderDemo(),
    );
  }
}

/// Using StreamBuilder: StreamBuilderDemo.dart


/// Using FutureBuilder
class FutureBuilderDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("I am invoked! "); // this will only be executed once since we use FutureBuilder
    return Scaffold(
      appBar: AppBar(
        title: Text('Future Builder Demo'),
      ),
      body: FutureBuilder(
        future: _getListData(),
        builder: (buildContext, snapshot) {
          if (snapshot.hasError) {
            return _getInfoMessage(snapshot.error);
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                backgroundColor: Colors.yellow[100],
              ),
            );
          }
          var listData = snapshot.data; //_getListData()的返回值
          if (listData.length == 0) {
            return _getInfoMessage('No data found');
          }

          return ListView.builder(
            itemCount: listData.length,
            itemBuilder: (buildContext, index) {
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text(listData[index]),
                  ),
                  Divider(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _getInfoMessage(String msg) {
    return Center(
      child: Text(msg),
    );
  }

  Future<List<String>> _getListData(
      {bool hasError = false, bool hasData = true}) async {
    await Future.delayed(Duration(seconds: 10));

    if (hasError) {
      return Future.error('获取数据出现问题，请再试一次');
    }

    if (!hasData) {
      return List<String>();
    }

    return List<String>.generate(10, (index) => '$index content');
  }
}


/// Using SetState to deal with async task (update widget with SetState Method which will invoke build method(:disadvantage))
class BaseStatefulDemo extends StatefulWidget {
  @override
  _BaseStatefulDemoState createState() => _BaseStatefulDemoState();
}

class _BaseStatefulDemoState extends State<BaseStatefulDemo> {
  List<String> _pageData;

  bool get _fetchingData => _pageData == null;

  @override
  void initState() {
    _getListData(hasError: false, hasData: true)
        .then((data) => setState(() {
      if (data.length == 0) {
        data.add('No data fount');
      }
      _pageData = data;
    }))
        .catchError((error) => setState(() {
      _pageData = [error];
    }));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    print("i AM invoked !");
    return Scaffold(
      appBar: AppBar(
        title: Text('Base Stateful Demo'),
      ),
      body: _fetchingData
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
          backgroundColor: Colors.yellow[100],
        ),
      )
          : ListView.builder(
        itemCount: _pageData.length,
        itemBuilder: (buildContext, index) {
          return getListDataUi(index);
        },
      ),
    );
  }

  Widget getListDataUi(int index) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(_pageData[index]),
        ),
        Divider(),
      ],
    );
  }

  Future<List<String>> _getListData(
      {bool hasError = false, bool hasData = true}) async {
    await Future.delayed(Duration(seconds: 10));

    if (hasError) {
      return Future.error('获取数据出现问题，请再试一次');
    }

    if (!hasData) {
      return List<String>();
    }

    return List<String>.generate(10, (index) => '$index content');
  }
}