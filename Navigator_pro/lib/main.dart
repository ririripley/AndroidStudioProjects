import 'package:Navigator_pro/dataProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: RaisedButton(
        child: Text('C 页面'),
        onPressed: () {
          Navigator.of(context).pushNamed('/A');
        },
      ),
    );
  }
}

class APage extends StatefulWidget {
  final dataProvider provider;
  APage({Key key, this.provider}) : super(key: key);
  @override
  _ApageState createState() => _ApageState();


}

class _ApageState  extends State<APage> {
  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider.value(
        value: this.widget.provider,
        child: Consumer<dataProvider>(
          builder: (context, provider, child) {
            return Container(
                alignment: Alignment.center,
                child: Column(children: <Widget>[
                  RaisedButton(
                    child: Text('A 页面: '),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/B');
                    },
                  ),
                  // + provider.getData()
                  RaisedButton(
                    child: Text('back'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  RaisedButton(
                    child: Text(' A  add'),
                    onPressed: () {
                      provider.add();
                    },
                  ),
                  Text(provider.getData()),
                ]));
          },
        ),
      ),
    );
  }

}

class BPage extends StatefulWidget {
  final dataProvider provider;
  BPage({Key key, this.provider}) : super(key: key);

  @override
  _BpageState createState() => _BpageState();
}

class _BpageState extends State<BPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider.value(
        value: this.widget.provider,
        child: Consumer<dataProvider>(
          builder: (context, provider, child) {
            return Container(
                alignment: Alignment.center,
                child: Column(children: <Widget>[
                  RaisedButton(
                    child: Text('B 页面'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
//
                  // + provider.getData()
                  RaisedButton(
                    child: Text(' B  add'),
                    onPressed: () {
                      provider.add();
                    },
                  ),
                  Text(provider.getData()),
                ]));
          },
        ),
      ),
    );
  }
  }



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  dataProvider provider = dataProvider();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: <String, WidgetBuilder>{
        '/C': (context) => CPage(),
        '/A': (context) => APage(provider: provider),
        '/B': (context) => BPage(provider: provider),
      },
      home: Scaffold(
        body: CPage(),
      ),
    );
  }
}
