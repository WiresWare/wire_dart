part of wire;

///
/// Created by Vladimir Cores (Minkin) on 12/06/20.
/// Github: https://github.com/DQvsRA
/// License: MIT
///
class WireData
{
  final _listeners = <Object, List<Function>>{};

  dynamic _value;
  dynamic get value => _value;
  set value(dynamic value) {
    _value = value;
    _listeners.forEach((scope, listeners) =>
      listeners.forEach((lnr) => lnr(value)));
  }

  WireData subscribe(Object scope, Function listener) {
//    print('> Wire: WireData -> listen');
    _listeners.putIfAbsent(scope, () => <Function>[]);
    _listeners[scope].add(listener);
    return this;
  }

  WireData unsubscribe(Object scope) {
//    print('> Wire: WireData -> listen');
    _listeners.remove(scope);
    return this;
  }
}