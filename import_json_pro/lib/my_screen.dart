import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_widget.dart';

import 'my_screen.i18n.dart';
import 'my_widget.dart';

// Developed by Marcelo Glasberg (Aug 2019).
// For more info, see: https://pub.dartlang.org/packages/i18n_extension

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  late int counter;
  late Future<void> loadAsync;

  @override
  void initState() {
    super.initState();
    counter = 0;
    loadAsync = MyI18n.loadTranslations();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: loadAsync,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return I18n(
              child:   Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(flex: 2),
                    MyWidget(),
                    const Spacer(),
                    Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        "You clicked the button %d times:".plural(counter),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                    MaterialButton(
                      color: Colors.blue,
                      child: Text(
                        "Increment".i18n,
                        style: const TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      onPressed: _increment,
                    ),
                    const Spacer(),
                    MaterialButton(
                      color: Colors.blue,
                      child: Text(
                        "文档权限".i18n,
                        style: const TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      onPressed: _onPressed,
                    ),
                    Text(
                      "Locale: ${I18n.locale}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            );
          }
          return Container(width: 100, height: 200, color: Colors.purple,);
        }
    );
  }

  void _onPressed() async {
    I18n.of(context).locale = (I18n.localeStr == "zh_ch") ? const Locale("en", "US") : const Locale("zh", "CH");
  }

  void _increment() => setState(() => counter++);
}
