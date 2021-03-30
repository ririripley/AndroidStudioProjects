import 'package:flutter/material.dart';
import 'stream_demo_event.dart';
import 'stream_demo_model.dart';
import 'stream_demo_state.dart';

class StreamBuilderDemo extends StatefulWidget {
  @override
  _StreamBuilderDemoState createState() => _StreamBuilderDemoState();
}

class _StreamBuilderDemoState extends State<StreamBuilderDemo> {
  final model = StreamDemoModel();

  @override
  void initState() {
    // model.dispatch(FetchData(hasData: true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stream Builder Demo'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.cached, color: Colors.black87,),
        onPressed: () {
          model.dispatch(FetchData());
        },
      ),
      body: StreamBuilder(
        stream: model.stream,
        builder: (buildContext, snapshot) {
          print('${snapshot.data}   + ${snapshot.hasData}');
          if (snapshot.hasError) {
            return Text('${snapshot.error}');
            // return _getInformationMessage(snapshot.error);
          }
          return Text(snapshot.hasData ? '${snapshot.data}' : 'NULL');
          // var streamState = snapshot.data; // stream一端传入的数据

          // if (!snapshot.hasData || streamState is BusyState) {
          //   return Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }
          // if (streamState is DataFetchedState) {
          //   if (!streamState.hasData) {
          //     return _getInformationMessage('not found data');
          //   }
          // }
          // return ListView.builder(
          //   itemCount: streamState.data.length,
          //   itemBuilder: (buildContext, index) =>
          //       _getListItem(index, streamState.data),
          // );
        },
      ),
    );
  }

  Widget _getListItem(int index, List<String> listItems) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(listItems[index]),
        ),
        Divider(),
      ],
    );
  }

  Widget _getInformationMessage(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w900,
            color: Colors.grey[500]),
        textAlign: TextAlign.center,
      ),
    );
  }
}