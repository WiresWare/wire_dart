part of wire;

///
/// Created by Vladimir Cores (Minkin) on 12/06/20.
/// Github: https://github.com/DQvsRA
/// License: APACHE LICENSE, VERSION 2.0
///
typedef WireDataListener = void Function(dynamic value);

class WireData
{
  Function _onRemove;
  final _listeners = <Object, List<WireDataListener>>{};

  /// This property needed to distinguish between newly created and not set WireData which has value of null at the beginning
  /// And with WireData at time when it's removed, because when removing the value also set to null
  bool _isSet = false;
  bool get isSet => _isSet;

  dynamic _key;
  dynamic get key => _key;

  dynamic _value; // initial value is null
  dynamic get value => _value;
  set value(dynamic value) {
    _value = value;
    _isSet = true;
    refresh();
  }

  WireData(this._key, this._onRemove);

  void refresh() {
    _listeners.forEach((scope, listeners) =>
      listeners.forEach((func) => func(_value)));
  }

  void remove() {
    _onRemove(_key);
    _onRemove = null;

    _key = null;
    value = null; // null value means remove element that listening on change (unsubscribe)

    while(_listeners.isNotEmpty) {
      var value = _listeners.remove(_listeners.keys.last);
      while(value.isNotEmpty) {
        value.removeLast();
      }
    }
  }

  WireData subscribe(Object scope, WireDataListener listener) {
    _listeners.putIfAbsent(scope, () => <WireDataListener>[]);
    _listeners[scope].add(listener);
    return this;
  }

  WireData unsubscribe(Object scope, [WireDataListener listener]) {
    if (_listeners != null && _listeners.containsKey(scope)) {
      if (listener != null) {
        _listeners[scope].remove(listener);
        if (_listeners[scope].isNotEmpty) return this;
      }
      _listeners.remove(scope);
    }
    return this;
  }
}