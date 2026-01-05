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
  dynamic _value; // initial value is null

  Function(String)? _onRemove;
  WireDataOnReset? _onReset;
  WireDataGetter? _getter;
  WireDataLockToken? _lockToken;

  final _listeners = <WireDataListener>{};

  /// This property needed to distinguish between newly created and not set WireData which has value of null at the beginning
  /// And with WireData at time when it's removed, because when removing the value also set to null
  bool get isSet => _value != null;
  bool get isLocked => _lockToken != null;
  bool get isGetter => _getter != null;
  String get key => _key;
  dynamic get value => isGetter ? _getter!(this) : _value;
  int get numberOfListeners => _listeners.length;

  set getter(WireDataGetter value) => _getter = value;
  set value(dynamic input) {
    // print('> WireDate -> set value: ${input}');
    _guardian();
    _value = input;
    refresh();
  }

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

  Future<void> refresh([dynamic optional]) async {
    if (_listeners.isEmpty) return;
    final valueForListener = optional ?? value;
    final listeners = Set<WireDataListener>.from(_listeners);
    for (final listener in listeners) {
      await listener(valueForListener);
    }
  }

  // In the call of this function isSet will return false
  Future<void> reset() async {
    _guardian();
    final previousValue = _value;
    _value = null;
    _onReset!(_key, previousValue);
    await refresh();
  }

  Future<void> remove({bool clean = false}) async {
    if (!clean) _guardian();
    _lockToken = null;
    await reset();
    _onRemove!(_key);
    _onRemove = null;
    _onReset = null;
    _listeners.clear();
  }

  void _guardian() {
    if (isLocked) throw Exception(isGetter ? ERROR__DATA_IS_GETTER : ERROR__DATA_IS_LOCKED);
  }

  // Subscribe to updates of value but not getter because its value locked
  WireData subscribe(WireDataListener listener) {
    if (isGetter) throw Exception(ERROR__SUBSCRIBE_TO_DATA_GETTER);
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
