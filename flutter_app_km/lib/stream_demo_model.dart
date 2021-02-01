import 'dart:async';
import 'stream_demo_event.dart';
import 'stream_demo_state.dart';


enum StreamViewState { Busy, DataRetrieved, NoData }

class StreamDemoModel {

  /// Data Member :  StreamController(_stateController), List<String>(_listItems),  _stateController.stream(streamState)
  // streamController 的add函数：Listeners receive this event in a later microtask.

  final StreamController<StreamDemoState> _stateController = StreamController<StreamDemoState>();
  // State : busy, error, initialized, fetched

  List<String> _listItems;

  Stream<StreamDemoState> get streamState => _stateController.stream;

  void dispatch(StreamDemoEvent event){
    print('Event dispatched: $event');
    if(event is FetchData) {
      _getListData(hasData: event.hasData, hasError: event.hasError);
    }
  }

  Future _getListData({bool hasError = false, bool hasData = true}) async {
    _stateController.add(BusyState());
    await Future.delayed(Duration(seconds: 2));

    if (hasError) {
      return _stateController.addError('error');
    }

    if (!hasData) {
      return _stateController.add(DataFetchedState(data: List<String>()));
    }

    _listItems = List<String>.generate(10, (index) => '$index content');
    _stateController.add(DataFetchedState(data: _listItems));
  }
}