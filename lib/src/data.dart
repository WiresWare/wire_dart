part of wire;

///
/// Created by Vladimir Cores (Minkin) on 12/06/20.
/// Github: https://github.com/DQvsRA
/// License: APACHE LICENSE, VERSION 2.0
///
typedef WireDataListener<T> = void Function(T value);

class DataToken {
  bool equal(DataToken token) => this == token;
}

class WireData<T> {
  Function _onRemove;
  final _listeners = <WireDataListener<T>>{};

  /// This property needed to distinguish between newly created and not set WireData which has value of null at the beginning
  /// And with WireData at time when it's removed, because when removing the value also set to null
  bool _isSet = false;
  bool get isSet => _isSet;

  String _key;
  String get key => _key;

  DataToken _token;
  bool get protected => _token != null;

  bool lock(DataToken token) {
    var closed = !protected || _token.equal(token);
    if (closed) _token = token;
    return closed; // throw ERROR__DATA_ALREADY_CLOSED
  }
      
  bool unlock(DataToken token) {
    var opened = (protected && _token.equal(token)) || !protected;
    if (opened) _token = null;
    return opened; // throw ERROR__DATA_CANNOT_OPEN
  }

  T _value; // initial value is null
  T get value => _value;
  set value(T input) {
    _guardian();
    _value = input;
    _isSet = true;
    refresh();
  }

  WireData(this._key, this._onRemove);

  void refresh() {
    _listeners.forEach((l) => l(_value));
  }

  void remove() {
    _guardian();

    _onRemove(_key);
    _onRemove = null;

    _key = null;
    // null value means remove element that listening on change (unsubscribe)
    value = null;
    _token = null;

    _listeners.clear();
  }

  void _guardian() { if (protected) throw ERROR__DATA_PROTECTED; }

  WireData subscribe(WireDataListener<T> listener) {
    if (!hasListener(listener)) _listeners.add(listener);
    return this;
  }

  WireData unsubscribe([WireDataListener<T> listener]) {
    if (listener != null) {
      if (hasListener(listener)) _listeners.remove(listener);
    } else {
      _listeners.clear();
    }
    return this;
  }

  bool hasListener(WireDataListener<T> listener) {
    return _listeners.contains(listener);
  }
}
