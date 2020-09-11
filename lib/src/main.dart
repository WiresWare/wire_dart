library wire;

part 'const.dart';
part 'layers.dart';
part 'data.dart';

/// Wire - communication and data layers
///
/// Dart pub/sub library - communication layer or "bus" to which you can attach a wire and listen for signal associated with it.
/// Wire has simplest possible API - add, remove and send. Also it has data layer, universal container with key-value, where value is an object WireData type that holds dynamic value and can be subscribed for updates. This "data container" is something like Redis.
///
/// Created by Vladimir Cores (Minkin) on 07/10/19.
/// Github: https://github.com/DQvsRA
/// License: APACHE LICENSE, VERSION 2.0
///

typedef WireListener<T> = void Function(T payload, int wireId);

abstract class WireMiddleware {
  void onAdd(Wire wire);
  void onSend(String signal, [payload, scope]);
  void onRemove(String signal, [Object scope, WireListener listener]);
  void onData(String key, dynamic prevValue, dynamic nextValue);
}

class Wire<T> {
  ///
  /// [read-only] [static]
  /// Used to generate Wire wid
  ///
  /// @private
  static int _INDEX = 0;
  static final WireCommunicateLayer _COMMUNICATION_LAYER =
      WireCommunicateLayer();
  static final WireDataContainerLayer _DATA_CONTAINER_LAYER =
      WireDataContainerLayer();
  static final _MIDDLEWARE_LIST = <WireMiddleware>[];

  ///**************************************************
  ///  Protected / Private Properties
  ///**************************************************

  ///
  /// [read-only]
  /// The SIGNAL associated with this Wire.
  ///
  /// @private
  String _signal;
  String get signal => _signal;

  ///
  /// [read-only]
  /// The closure method that this item was associated.
  ///
  /// @private
  WireListener<T> _listener;
  WireListener<T> get listener => _listener;

  ///
  /// [read-only] [internal use]
  /// Unique identification for wire instance.
  ///
  /// @private
  int _id;
  int get id => _id;

  ///
  /// [read-only] [internal use]
  /// Scope to which wire belongs to
  ///
  /// @private
  Object _scope;
  Object get scope => _scope;

  ///
  /// The number of times that wire instance will respond on signal before being removed.
  /// Default is 0 that means infinity times.
  ///
  int replies = 0;

  /// Wire object is a communication unit of the system, each instance associated with a signal
  ///
  /// Wire object can be passed as a reference to any component of the your system
  /// But it wont react on signal until it is attached to the communication layer with [attach]
  /// However you still can send data through it by calling [transfer]
  ///
  Wire(Object scope, String signal, WireListener<T> listener, [int replies = 0])
      : assert(scope != null),
        assert(signal != null),
        assert(listener != null) {
    _scope = scope;
    _signal = signal;
    _listener = listener;
    this.replies = replies;
    _id = ++_INDEX;
  }

  /// Call associated WireListener with data.
  void transfer(dynamic payload) {
    // Call a listener in this Wire only in case data type match it's listener type.
    if (payload is T || payload == null) {
      _listener(payload, _id);
    }
  }

  /// Nullify all relations
  void clear() {
    _scope = null;
    _signal = null;
    _listener = null;
  }

  ///**********************************************************************************************************
  ///
  ///  Public Static Methods - API
  ///
  ///**********************************************************************************************************

  /// Add wire object to the communication layer
  static void attach(Wire wire) {
    _COMMUNICATION_LAYER.add(wire);
  }

  /// Remove wire object from communication layer, returns existence.
  static bool detach(Wire wire) {
    return _COMMUNICATION_LAYER.remove(wire.signal, wire.scope, wire.listener);
  }

  /// Create wire object from params and [attach] it to the communication layer
  /// All middleware will be informed from [WireMiddleware.onAdd] before wire is attached to the layer
  static Wire add<T>(Object scope, String signal, WireListener<T> listener,
      {int replies = 0}) {
    final wire = Wire<T>(scope, signal, listener, replies);
    _MIDDLEWARE_LIST.forEach((m) => m.onAdd(wire));
    attach(wire);
    return wire;
  }

  /// Check if signal string or wire instance exists in communication layer
  static bool has({String signal, Wire wire}) {
    if (signal != null) return _COMMUNICATION_LAYER.hasSignal(signal);
    if (wire != null) return _COMMUNICATION_LAYER.hasWire(wire);
    return false;
  }

  /// Send signal through all wires has the signal string value
  /// Payload is optional, default is null, passed to WireListener from [transfer]
  /// If use scope then only wire with this scope value will receive the payload
  /// All middleware will be informed from [WireMiddleware.onSend] before signal sent on wires
  /// Returns true when no wire for the signal has found
  static bool send<T>(String signal, {T payload, Object scope}) {
    _MIDDLEWARE_LIST.forEach((m) => m.onSend(signal, payload));
    return _COMMUNICATION_LAYER.send(signal, payload, scope);
  }

  /// Remove all entities from Communication Layer and Data Container Layer
  /// @param [withMiddleware] used to remove all middleware
  static void purge({bool withMiddleware}) {
    _COMMUNICATION_LAYER.clear();
    _DATA_CONTAINER_LAYER.clear();
    if (withMiddleware ?? false) _MIDDLEWARE_LIST.clear();
  }

  /// Remove all wires for specific signal, for more precise target to remove add scope and/or listener
  /// All middleware will be informed from [WireMiddleware.onRemove] after signal removed, only if existed
  /// Returns [bool] telling signal existed in communication layer
  static bool remove(String signal, {Object scope, WireListener listener}) {
    var existed = _COMMUNICATION_LAYER.remove(signal, scope, listener);
    if (existed) {
      _MIDDLEWARE_LIST.forEach((m) => m.onRemove(signal, scope, listener));
    }
    return existed;
  }

  /// Class extending [WireMiddleware] can listen to all processes in side Wire
  static void middleware(WireMiddleware value) {
    if (!_MIDDLEWARE_LIST.contains(value)) {
      _MIDDLEWARE_LIST.add(value);
    } else {
      throw ERROR__MIDDLEWARE_EXISTS + value.toString();
    }
  }

  /// When you need Wires associated with signal or scope or listener
  /// Returns [List<Wire>]
  static List<Wire> get(
      {String signal, Object scope, WireListener listener, int wireId}) {
    var result = <Wire>[];
    if (signal != null) {
      result.addAll(_COMMUNICATION_LAYER.getBySignal(signal));
    }
    if (scope != null) {
      result.addAll(_COMMUNICATION_LAYER.getByScope(scope));
    }
    if (listener != null) {
      result.addAll(_COMMUNICATION_LAYER.getByListener(listener));
    }
    if (wireId != null) {
      result.add(_COMMUNICATION_LAYER.getByWID(wireId));
    }
    return result;
  }

  /// Access to the data container, retrieve WireData object when value is null and set when is not
  /// [WireData] is a data container to changes of which anyone can subscribe/unsubscribe.
  /// It's associated with string key.
  /// WireData can't be null and Wire.data(key) will always return WireData instance.
  /// Initial value will be null and special property of WireData isSet is false until not null value is set for the first time
  /// [WireData] API:
  /// ```
  /// WireData subscribe(WireDataListener listener)
  /// WireData unsubscribe([WireDataListener listener])
  /// void refresh()
  /// void remove()
  /// ```
  /// Returns [WireData]
  static WireData data<T>(String key, [T value]) {
    var wireData = _DATA_CONTAINER_LAYER.get(key);
    if (value != null) {
      var prevValue = wireData.value;
      var nextValue = value is Function ? value(prevValue) : value;
      _MIDDLEWARE_LIST.forEach((m) => m.onData(key, prevValue, nextValue));
      wireData.value = nextValue;
    }
    return wireData;
  }
}
