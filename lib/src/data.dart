part of wire;

///
/// Created by Vladimir Cores (Minkin) on 12/06/20.
/// Github: https://github.com/DQvsRA
/// License: APACHE LICENSE, VERSION 2.0
///
typedef WireDataListener<T> = void Function(T value);

class DataModificationToken {
  bool equal(DataModificationToken token) => this == token;
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

  DataModificationToken _token;
  bool get protected => _token != null;

  bool modificationAllowed(DataModificationToken token) =>
    !protected || _token.equal(token);

  T _value; // initial value is null
  T get value => _value;

  void setValue(T input, { DataModificationToken token }) {
    if (input == null && _key != null) return remove();
    if (modificationAllowed(token)) {
      _value = input;
      _isSet = true;
      refresh();
    } else {
      throw ERROR__DATA_MODIFICATION_TOKEN_DOES_NOT_MATCH;
    }
  }

  WireData(this._key, this._onRemove, this._token);

  void refresh() {
    _listeners.forEach((l) => l(_value));
  }

  void remove() {
    _onRemove(_key);
    _onRemove = null;

    _key = null;
    // null value means remove element that listening on change (unsubscribe)
    setValue(null, token: _token);
    _token = null;

    _listeners.clear();
  }

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
