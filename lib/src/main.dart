library wire;

part 'store.dart';
part 'layer.dart';
part 'data.dart';

///
/// Created by Vladimir Cores (Minkin) on 07/10/19.
/// Github: https://github.com/DQvsRA
/// License: APACHE LICENSE, VERSION 2.0
///

typedef WireListener = void Function(Wire wire, dynamic data);

class Wire {
  static int _INDEX = 0;
  static final WireLayer _LAYER = WireLayer();
  static final WireStore _STORE = WireStore();

  ///**************************************************
  ///  Protected / Private Properties
  ///**************************************************

  ///
  /// [read-only]
  /// The Wire SIGNAL associated with this Wire.
  ///
  /// @private
  String _signal;
  String get signal => _signal;

  ///
  /// [read-only]
  /// The closure method that this item was associated.
  ///
  /// @private
  WireListener _listener;
  WireListener get listener => _listener;

  ///
  /// [read-only] [internal use]
  /// Unique identification for this instance based on its attributes.
  ///
  /// @private
  int _hash;
  int get hash => _hash;

  ///
  /// [read-only] [internal use]
  /// Scope to which wire is belong to
  ///
  /// @private
  Object _scope;
  Object get scope => _scope;

  ///
  /// The number of times that this item will respond.
  /// Default is 0 that means infinity times.
  ///
  int replies = 0;

  Wire(Object scope, String signal, WireListener listener, int replies) {
    _scope = scope;
    _signal = signal;
    _listener = listener;
    this.replies = replies;
    _hash = ++_INDEX << 0x08;
  }

  ///**********************************************************************************************************
  ///
  ///  Public Methods
  ///
  ///**********************************************************************************************************
  void transfer(data) {
    // Call a listener in this Wire.
    _listener(this, data);
  }

  ///**********************************************************************************************************
  ///
  ///  Public Static Methods - API
  ///
  ///**********************************************************************************************************
  static Wire add(Object scope, String signal, WireListener listener,
      {int replies = 0}) {
    return _LAYER.add(Wire(scope, signal, listener, replies));
  }

  static bool has({String signal, Wire wire}) {
    if (signal != null) return _LAYER.hasSignal(signal);
    if (wire != null) return _LAYER.hasWire(wire);
    return false;
  }

  static bool send(String signal, [data]) {
    return _LAYER.send(signal, data);
  }

  static bool remove(String signal, {Object scope, WireListener listener}) {
    return _LAYER.remove(signal, scope, listener);
  }

  static List<Wire> get({String signal, Object scope, Function listener}) {
    var result = <Wire>[];
    if (signal != null) result.addAll(_LAYER.getBySignal(signal));
    if (scope != null) result.addAll(_LAYER.getByScope(scope));
    if (listener != null) result.addAll(_LAYER.getByListener(listener));
    return result;
  }

  static WireData data(String param, [dynamic value]) {
    var wd = _STORE.get(param);
    if (value != null) wd.value = value is Function ? value(wd.value) : value;
    return wd;
  }
}
