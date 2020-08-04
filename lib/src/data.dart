part of wire;

///
/// Created by Vladimir Cores (Minkin) on 12/06/20.
/// Github: https://github.com/vladimircores
/// License: APACHE LICENSE, VERSION 2.0
///
typedef WireDataListener<T> = void Function(T value);

class WireDataLockToken {
  bool equal(WireDataLockToken token) => this == token;
}

class WireData<T> {
  Function? _onRemove;
  final _listeners = <WireDataListener<T?>>{};

  /// This property needed to distinguish between newly created and not set WireData which has value of null at the beginning
  /// And with WireData at time when it's removed, because when removing the value also set to null
  bool _isSet = false;
  bool get isSet => _isSet;

  String? _key;
  String? get key => _key;

  WireDataLockToken? _lockToken;
  bool get isLocked => _lockToken != null;

  /// Prevent any value modifications inside specific of [WireData] instance.
  /// [WireDataLockToken] token should be stored in some controller or responsible
  /// for modification entity. The purpose of this method is to restrict data changes
  /// only to the place where business logic or model related operations take place.
  bool lock(WireDataLockToken token) {
    var locked = !isLocked || _lockToken!.equal(token);
    if (locked) _lockToken = token;
    return locked; // throw ERROR__DATA_ALREADY_CLOSED
  }

  /// After calling this method with proper token [WireDataLockToken]
  /// changes to the [WireData] value will be allowed from anywhere of the system
  bool unlock(WireDataLockToken token) {
    var opened = (isLocked && _lockToken!.equal(token)) || !isLocked;
    if (opened) _lockToken = null;
    return opened; // throw ERROR__DATA_CANNOT_OPEN
  }

  T? _value; // initial value is null
  T? get value => _value;
  set value(T? input) {
    _guardian();
    _value = input;
    _isSet = true;
    refresh();
  }

  WireData(this._key, this._onRemove);

  Future<void> refresh() async {
    _listeners.forEach((l) async => await l(_value));
  }

  void remove() {
    _guardian();

    _onRemove!(_key); // never null because its a reference to the map.remove
    _onRemove = null;

    _key = null;
    // null value means remove element that listening on change (unsubscribe)
    value = null;
    _lockToken = null;

    _listeners.clear();
  }

  void _guardian() {
    if (isLocked) throw ERROR__DATA_IS_LOCKED;
  }

  WireData<T> subscribe(WireDataListener<T?> listener) {
    if (!hasListener(listener)) _listeners.add(listener);
    return this;
  }

  WireData<T> unsubscribe([WireDataListener<T>? listener]) {
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
