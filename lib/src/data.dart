part of wire;

///
/// Created by Vladimir Cores (Minkin) on 12/06/20.
/// Github: https://github.com/vladimircores
/// License: APACHE LICENSE, VERSION 2.0
///
typedef WireDataListener = Future<void> Function(dynamic value);
typedef WireDataGetter = dynamic Function(WireData that);
typedef WireDataOnReset = void Function(String, dynamic);

class WireDataLockToken {
  bool equal(WireDataLockToken token) => this == token;
}

class WireData {
  WireData(this._key, this._onRemove, this._onReset);

  final String _key;
  final Function(String) _onRemove;
  final WireDataOnReset _onReset;

  final _listeners = <WireDataListener>{};

  bool get isGetter => _getter != null;

  /// This property needed to distinguish between newly created and not set WireData which has value of null at the beginning
  /// And with WireData at time when it's removed, because when removing the value also set to null
  bool get isSet => _value != null;

  String get key => _key;

  WireDataLockToken? _lockToken;
  bool get isLocked => _lockToken != null;

  /// Prevent any value modifications inside specific of [WireData] instance.
  /// [WireDataLockToken] token should be stored in some controller or responsible
  /// for modification entity. The purpose of this method is to restrict data changes
  /// only to the place where business logic or model related operations take place.
  bool lock(WireDataLockToken token) {
    final locked = !isLocked || _lockToken!.equal(token);
    if (locked) _lockToken = token;
    return locked; // throw ERROR__DATA_ALREADY_CLOSED
  }

  /// After calling this method with proper token [WireDataLockToken]
  /// changes to the [WireData] value will be allowed from anywhere of the system
  bool unlock(WireDataLockToken token) {
    final opened = (isLocked && _lockToken!.equal(token)) || !isLocked;
    if (opened) _lockToken = null;
    return opened; // throw ERROR__DATA_CANNOT_OPEN
  }

  WireDataGetter? _getter;
  set getter(WireDataGetter value) => _getter = value;

  dynamic _value; // initial value is null
  dynamic get value => isGetter ? _getter!(this) : _value;
  set value(dynamic input) {
    // print('> WireDate -> set value: ${input}');
    _guardian();
    _value = input;
    refresh();
  }

  Future<void> refresh([dynamic value]) async {
    if (_listeners.isEmpty) return;
    for (final listener in _listeners) {
      await listener(this.value);
    }
  }

  Future<void> reset() async {
    _guardian();
    final previousValue = _value;
    _value = null;
    _onReset(_key, previousValue);
    await refresh();
  }

  Future<void> remove({bool clean = false}) async {
    if (!clean) _guardian();
    _value = null;
    _lockToken = null;
    _onRemove(_key);
    await refresh();
    _listeners.clear();
  }

  void _guardian() {
    if (isLocked) throw Exception(isGetter ? ERROR__DATA_IS_GETTER : ERROR__DATA_IS_LOCKED);
  }

  WireData subscribe(WireDataListener listener) {
    if (!hasListener(listener)) {
      _listeners.add(listener);
    }
    return this;
  }

  WireData unsubscribe([WireDataListener? listener]) {
    if (listener != null) {
      if (hasListener(listener)) _listeners.remove(listener);
    } else {
      _listeners.clear();
    }
    return this;
  }

  bool hasListener(WireDataListener listener) {
    return _listeners.contains(listener);
  }
}
