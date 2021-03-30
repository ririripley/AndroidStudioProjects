import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget _docExternalApplySwitch(CooperationProvider cProvider) {
  bool uiCanDocExternalApply = cProvider.canDocExternalApply;
  return Offstage(
    offstage: !cProvider.canCorpExternalApply,
    child: Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text('企业外成员可申请成为协作人',
                    style: TextStyle(fontSize: 16), maxLines: 2)),
            Container(
              width: 21,
            ),
            CupertinoSwitch(
              activeColor: Colors.blue,
              value: uiCanDocExternalApply,
              onChanged: (bool value) {
                uiCanDocExternalApply = value;
                cProvider.setCanDocExternalApply(uiCanDocExternalApply);
              },
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _transOwnerWidget(bool isVisible) {
  return Visibility(
    visible: isVisible,
    child: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _headerWithText(
            "转让文档所有权",
          ),

          ///
          ///
          Expanded(
              child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 3),
                  child: Text(
                      cProvider.isTimeLimitedForCorpOpen
                          ? '已开启企业外${cProvider.canExternalEdit ? '编辑' : '查看'}，${cProvider.remainingDay}天后到期。'
                          : '已开启企业外${cProvider.canExternalEdit ? '编辑' : '查看'}',
                      style: TextStyle(
                          fontSize: 15, color: Colors.black.withOpacity(0.6)),
                      maxLines: 1),
                ),
              ),
              Visibility(
                  visible: cProvider.docAdvSettingModuleEditable() &&
                      cProvider.docsItemModel.docType != DocsType.docsTypeForm,
                  maintainState: true,
                  child: CupertinoButton(
                    child: Padding(
                        padding: EdgeInsets.only(right: 2),
                        child: Text('修改',
                            style: TextStyle(fontSize: 15, color: Colors.blue),
                            maxLines: 1)),
                    onPressed: () {
                      /// 收集单无高级权限入口
                      if (cProvider.model != null &&
                          cProvider.docAdvSettingModuleEditable() &&
                          cProvider.docsItemModel.docType !=
                              DocsType.docsTypeForm) {
                        Navigator.of(context).pushSplit(SplitStyle(
                            '/CooperationAdvSetting',
                            arguments: cProvider,
                            size: CooperationModel.BoxSize(),
                            replaceRoute: false));
                      } else {
                        print("没有数据 ${cProvider.model}");
                      }
                    },
                  )),
            ],
          )),

          ///
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text('选择转让对象，对方同意后即可转让成功。转让后，你将无法管理文档。',
                          style: TextStyle(fontSize: 16), maxLines: 2)),
                  Container(
                    width: 21,
                  ),
                  CupertinoButton(
                    child: Text('转让 >',
                        style: TextStyle(fontSize: 17), maxLines: 2),
                    onPressed: null,
                  ),
                ],
              ),
            ),
          ),
          Visibility(
              visible: true,
              child: CupertinoButton(
                child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text('修改',
                        style: TextStyle(fontSize: 15, color: Colors.blue),
                        maxLines: 1)),
                onPressed: () {
                  if (cProvider.model != null) {
                    Navigator.of(context).pushSplit(SplitStyle(
                        '/CooperationAdvSetting',
                        arguments: cProvider,
                        size: CooperationModel.BoxSize(),
                        replaceRoute: false));
                  } else {
                    print("没有数据 ${cProvider.model}");
                  }
                },
              )),
        ],
      ),
    ),
  );
}

////
void main() {
  runApp(MyApp());
  testWidgets('test search bar for VP user', (tester) async {
    final provider = FriendPickerProvider();
    provider.isProvidingWeCom = true;
    final data = MockCGIModelData();
    final api = await MockAPIService.makeForWidgetTester(
      tester,
      '/DocsList',
      mockOperation: (api) {
        provider.api = api;
        api.setMockCGIData(CGI.work_weixin_searchuser, data.wecomSearchVPuser);
      },
    );

    api.rootNavigator.pushNamed('/WWWorkMatesPicker', arguments: provider);
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(Key('FriendSearchBar_search')), 'test');
    await tester.pumpAndSettle();
    expect(find.text('ponyma(马化腾)'), findsOneWidget);

    await tester.tap(find.text('ponyma(马化腾)'));
    await tester.pumpAndSettle();
    List<MemberModel> pickedMember = provider.pickedFriends();
    expect(pickedMember.length, 1);
    expect(pickedMember[0].need_remind, true);
    expect(
      find.byWidgetPredicate((Widget widget) => widget is OneOffButton),
      findsOneWidget,
    );
    await tester.tap(find.byType(OneOffButton).last);
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate((Widget widget) => widget is CommonAlertDialog),
      findsWidgets,
    );
    expect(find.text('取消'), findsWidgets);
  });
}

class MyApp extends StatelessWidget {
  /// 权限文案
  static List<Map<String, dynamic>> COOPERATION_INFO(bool isWeCom) {
    return [
      {
        "type": CooperationModel.EDITBLE,
        "icon": 'auth-icon-edit',
        "displayTitle": '${titleString(isWeCom)}可编辑',
        "displaySubTitle": '${subtitleString(isWeCom)}可编辑文档',
      }
    ];
  }

  ///
  @override
  Widget build(BuildContext context) {
    PermissionInfo cInfo = widget.currentInfo;

    Column contentView = privatePage(isWecom: cInfo.isWeCom);
    double contentHeight = 250.0;
    int memberCount =
        widget.currentConfig != null ? widget.currentConfig.members.length : 0;
    bool showRecallItem = this.widget.recallShareCallback != null;

    if (cInfo.type == CooperationModel.COOPERATION) {
      contentView =
          protectPage(true, false, showRecallItem, isWecom: cInfo.isWeCom);
      contentHeight = 162 +
          (memberCount > 0 ? memberCount * 64.0 : 250.0) +
          (showRecallItem ? WxchatFriendCell.CellHeight : 0);
    } else if ((cInfo.docsType == DocsType.docsTypePdf &&
            cInfo.type != CooperationModel.SELF) ||
        cInfo.type == CooperationModel.EDITBLE) {
      contentView = publicPage();
      contentHeight = 310.0;
    } else if (cInfo.type == CooperationModel.VIEWABLE) {
      contentView = protectPage(
          false, (cInfo.docsType == DocsType.docsTypePdf), showRecallItem,
          isWecom: cInfo.isWeCom);
      contentHeight = 162 +
          (memberCount > 0 ? memberCount * 64.0 : 250.0) +
          (showRecallItem ? WxchatFriendCell.CellHeight : 0);
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return TouchPadWidget(
            scrollController: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    height: max(contentHeight, constraints.maxHeight)),
                child: Container(
                  padding: padding,
                  child: contentView,
                ), // your column
              ),
            ));
      },
    );
  }

  ////
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
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
