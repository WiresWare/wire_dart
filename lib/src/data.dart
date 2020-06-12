part of wire;

///
/// Created by Vladimir Cores (Minkin) on 12/06/20.
/// Github: https://github.com/DQvsRA
/// License: MIT
///
class WireData
{
  final _controller = StreamController.broadcast();

  dynamic _value;
  dynamic get value => _value;
  set value(dynamic value) {
    _value = value;
//    print('> Wire: WireData -> set: ' + value.toString());
    _controller.sink.add(_value);
  }

  WireData listen(Function listener) {
//    print('> Wire: WireData -> listen');
    _controller.stream.listen(listener);
    return this;
  }
}