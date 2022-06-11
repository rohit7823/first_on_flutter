import 'dart:async';

enum CounterType {
  INCRESE,
  DECRESE,
  RESET
}

class CounterBloc {
  int counter = 0;
  final _streamStreamController = StreamController<int>();
  StreamSink<int> get _counterSink => _streamStreamController.sink;
  Stream<int> get counterStream => _streamStreamController.stream;

  final _eventStreamController = StreamController<CounterType>();
  StreamSink<CounterType> get eventSink => _eventStreamController.sink;
  Stream<CounterType> get _eventStream => _eventStreamController.stream;

  CounterBloc() {
    _eventStream.listen((event) {
      switch(event) {
        case CounterType.INCRESE:
          counter++;
          break;
        case CounterType.DECRESE:
          if(counter > 0) {
            counter--;
          }
          break;
        case CounterType.RESET:
          counter = 0;
          break;
      }
      _counterSink.add(counter);
    });
  }

  void onDispose() {
    _streamStreamController.close();
    _eventStreamController.close();
  }
}