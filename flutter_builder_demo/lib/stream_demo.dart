import 'package:flutter/material.dart';
import 'base_stateful_demo.dart';
import 'future_builder_demo.dart';
import 'stream_builder_demo.dart';

class StreamDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stream Demo'),
        elevation: 0.0,
      ),
      body: ListView(
        children: <Widget>[
          ListItem(
            title: 'Base Stateful Demo',
            page: BaseStatefulDemo(),
            icon: Icon(
              Icons.local_bar,
              color: Colors.black54,
            ),
          ),
          ListItem(
            title: 'Future Builder Demo',
            page: FutureBuilderDemo(),
            icon: Icon(
              Icons.functions,
              color: Colors.black54,
            ),
          ),
          ListItem(
            title: 'Stream Builder Demo',
            page: StreamBuilderDemo(),
            icon: Icon(
              Icons.free_breakfast,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final String title;
  final Widget page;
  final Widget icon;

  ListItem({
    this.title,
    this.page,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(title),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => page),
            );
          },
          leading: icon,
          contentPadding: EdgeInsets.only(left: 16.0, right: 6.0),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: Colors.black45,
            size: 22.0,
          ),
        ),
        Divider(),
      ],
    );
  }
}