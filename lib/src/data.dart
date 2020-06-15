part of wire;

///
/// Created by Vladimir Cores (Minkin) on 12/06/20.
/// Github: https://github.com/DQvsRA
/// License: MIT
///
class WireData
{
  Function _onRemove;

  WireData(this._key, this._onRemove);

  var _listeners = <Object, List<Function>>{};

  dynamic _key;
  dynamic get key => _key;

  dynamic _value;
  dynamic get value => _value;
  set value(dynamic value) {
    _value = value;
    _listeners.forEach((scope, listeners) =>
      listeners.forEach((lnr) => lnr(value)));
  }

  void remove() {
    _onRemove(_key);
    _onRemove = null;

    _key = null;
    value = null; // null value means remove element that listening on change (unsubscribe)
    _listeners.forEach((key, value) {
      while(value.isNotEmpty) {
        value.removeLast();
      }
      _listeners.remove(key);
    });
    _listeners = null;
  }

  WireData subscribe(Object scope, Function listener) {
    _listeners.putIfAbsent(scope, () => <Function>[]);
    _listeners[scope].add(listener);
    return this;
  }

  WireData unsubscribe(Object scope) {
    if (_listeners != null && _listeners.containsKey(scope)) {
      _listeners.remove(scope);
    }
    return this;
  }
}