library wire;

part 'const.dart';
part 'layers.dart';
part 'data.dart';

/// Wire - communication and data layers which consist of string keys, thus realization of String API when each component of the system - logical or visual - represented as a set of Strings - what it consumes is Data API and what it produces or reacts to is Signals API.
///
/// Wire is a kind of "pub/sub" library - communication layer or "bus" to which you can attach a wire and listen for signal associated with it.
/// Wire has simplest possible API - add, remove and send. Also it has data layer, universal container with key-value, where value is an object WireData type that holds dynamic value and can be subscribed for updates. This "data container" is something like Redis.
///
/// Created by Vladimir Cores (Minkin) on 07/10/19.
/// Github: https://github.com/vladimircores
/// License: APACHE LICENSE, VERSION 2.0
///

typedef WireListener<T> = Future<void> Function(T? payload, int wireId);

abstract class WireMiddleware {
  Future<void> onAdd(Wire wire);
  Future<void> onSend(String signal, [Object? payload, Object? scope]);
  Future<void> onRemove(String signal, [Object? scope, WireListener? listener]);
  Future<void> onData(String key, dynamic prevValue, dynamic nextValue);
}

class Wire<T> {
  ///
  /// [read-only] [static]
  /// Used to generate Wire wid
  ///
  /// @private
  static int _INDEX = 0;
  static final WireCommunicateLayer _COMMUNICATION_LAYER = WireCommunicateLayer();
  static final WireDataContainerLayer _DATA_CONTAINER_LAYER = WireDataContainerLayer();
  static final _MIDDLEWARE_LIST = <WireMiddleware>[];

  ///**************************************************
  ///  Protected / Private Properties
  ///**************************************************

  ///
  /// [read-only]
  /// The SIGNAL associated with this Wire.
  ///
  /// @private
  String? _signal;
  String get signal => _signal!;

  ///
  /// [read-only]
  /// The closure method, reaction to the Wire instance changes.
  ///
  /// @private
  WireListener<T>? _listener;
  WireListener<T> get listener => _listener!;

  ///
  /// [read-only] [internal use]
  /// Unique identification for wire instance.
  ///
  /// @private
  int? _id;
  int get id => _id!;

  ///
  /// [read-only] [internal use]
  /// Scope to which wire belongs to
  ///
  /// @private
  Object? _scope;
  Object get scope => _scope!;

  ///
  /// The number of times that wire instance will respond on signal before being removed.
  /// Default is 0 that means infinity times.
  ///
  int _replies = 0;
  int get replies => _replies;
  set replies(int value) {
    _withReplies = value > 0;
    _replies = value;
  }
  bool _withReplies = false;
  bool get withReplies => _withReplies;

  /// Wire object is a communication unit of the system, each instance associated with a signal
  ///
  /// Wire object can be passed as a reference to any component of the your system
  /// But it wont react on signal until it is attached to the communication layer with [attach]
  /// However you still can send data through it by calling [transfer]
  ///
  Wire(
    Object scope,
    String signal,
    WireListener<T> listener,
    [int replies = 0]
  ) {
    _scope = scope;
    _signal = signal;
    _listener = listener;
    this.replies = replies;
    _id = ++_INDEX;
  }

  /// Call associated WireListener with data.
  Future<void> transfer(dynamic payload) async {
    if (_listener == null) throw Exception(ERROR__LISTENER_IS_NULL);
    // Call a listener in this Wire only in case data type match it's listener type.
    final filterByPayloadType =  payload is T || payload == null;
    // print('> Wire -> transfer(${T}): filterByPayloadType = ${filterByPayloadType}');
    if (filterByPayloadType) await _listener!(payload, _id!);
  }

  /// Nullify all relations
  Future<void> clear() async {
    _scope = null;
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

  /// Remove wire object from communication layer, then inform all middlewares with
  /// Returns existence of another wires with that signal.
  static Future<bool> detach(Wire wire) {
    return remove(wire.signal, scope: wire.scope, listener: wire.listener);
  }

  /// Create wire object from params and [attach] it to the communication layer
  /// All middleware will be informed from [WireMiddleware.onAdd] before wire is attached to the layer
  static Future<Wire> add<T>(
    Object scope,
    String signal,
    WireListener<T> listener,
    {int replies = 0}
  ) async {
    final wire = Wire<T>(scope, signal, listener, replies);
    if (_MIDDLEWARE_LIST.isNotEmpty) {
      await Future.forEach(_MIDDLEWARE_LIST, (WireMiddleware middleware) => middleware.onAdd(wire));
    }
    attach(wire);
    return wire;
  }

  /// Check if signal string or wire instance exists in communication layer
  static bool has({String? signal, Wire? wire}) {
    if (signal != null) return _COMMUNICATION_LAYER.hasSignal(signal);
    if (wire != null) return _COMMUNICATION_LAYER.hasWire(wire);
    return false;
  }

  /// Send signal through all wires has the signal string value
  /// Payload is optional, default is null, passed to WireListener from [transfer]
  /// If use scope then only wire with this scope value will receive the payload
  /// All middleware will be informed from [WireMiddleware.onSend] before signal sent on wires
  ///
  /// Returns true when no wire for the signal has found
  static Future<bool> send<T>(String signal, {T? payload, Object? scope}) async {
    if (_MIDDLEWARE_LIST.isNotEmpty) {
      await Future.forEach(_MIDDLEWARE_LIST, (WireMiddleware middleware) => middleware.onSend(signal, payload));
    }
    return _COMMUNICATION_LAYER.send(signal, payload, scope);
  }

  /// Remove all entities from Communication Layer and Data Container Layer
  /// @param [withMiddleware] used to remove all middleware
  static Future<void> purge({bool? withMiddleware}) async {
    await _COMMUNICATION_LAYER.clear();
    await _DATA_CONTAINER_LAYER.clear();
    if (withMiddleware ?? false) {
      _MIDDLEWARE_LIST.clear();
    }
  }

  /// Remove all wires for specific signal, for more precise target to remove add scope and/or listener
  /// All middleware will be informed from [WireMiddleware.onRemove] after signal removed, only if existed
  /// Returns [bool] telling signal existed in communication layer
  static Future<bool> remove(String signal, {Object? scope, WireListener? listener}) async {
    final existed = await _COMMUNICATION_LAYER.remove(signal, scope, listener);
    if (existed) {
      await Future.forEach(_MIDDLEWARE_LIST, (WireMiddleware middleware) async {
        await middleware.onRemove(signal, scope, listener);
      });
    }
    return existed;
  }

  /// Class extending [WireMiddleware] can listen to all processes in side Wire
  static void middleware(WireMiddleware value) {
    if (!_MIDDLEWARE_LIST.contains(value)) {
      _MIDDLEWARE_LIST.add(value);
    } else {
      throw Exception(ERROR__MIDDLEWARE_EXISTS + value.toString());
    }
  }

  /// When you need Wires associated with signal or scope or listener
  /// Returns [List<Wire>]
  static List<Wire?> get({
    String? signal,
    Object? scope,
    WireListener? listener,
    int? wireId
  }) {
    var result = <Wire?>[];
    if (signal != null) result.addAll(_COMMUNICATION_LAYER.getBySignal(signal));
    if (scope != null) result.addAll(_COMMUNICATION_LAYER.getByScope(scope));
    if (listener != null) result.addAll(_COMMUNICATION_LAYER.getByListener(listener));
    if (wireId != null) result.add(_COMMUNICATION_LAYER.getByWID(wireId));

    return result;
  }

  /// Access to the data container, retrieve WireData object when value is null and set when is not
  /// [WireData] is a data container to changes of which anyone can subscribe/unsubscribe.
  /// It's associated with string key.
  /// [WireData] can't be null and Wire.data(key) will always return WireData instance.
  /// Initial value will be null and special property of [WireData] isSet equal to false until any value is set
  /// If value is null then delete method of [WireData] will be called, object will be removed from system
  /// To protect [WireData] from being set from unappropriated places the [WireDataLockToken] token introduced.
  /// When only specific object want have rights to write/change value of [WireData] it can create [WireDataLockToken] object
  /// and pass it to [Wire.data] method as option parameter `token` to validate the assign action.
  /// [WireData] API:
  /// ```
  /// WireData subscribe(WireDataListener listener)
  /// WireData unsubscribe([WireDataListener listener])
  /// void setValue(T input, { DataModificationToken token })
  /// void refresh()
  /// void remove()
  /// ```
  /// Returns [WireData]
  static WireData data<T>(String key, {T? value, WireDataGetter<T>? getter}) {
    final WireData wireData = _DATA_CONTAINER_LAYER.has(key)
        ? _DATA_CONTAINER_LAYER.get(key)
        : _DATA_CONTAINER_LAYER.create(key);
    // print('> Wire -> WireData - data key = ${key}, value = ${value}, getter = ${getter}');
    if (getter != null) {
      wireData.value = getter;
      wireData.lock(WireDataLockToken());
    }
    if (value != null) {
      if (wireData.isGetter) throw Exception(ERROR__VALUE_IS_NOT_ALLOWED_TOGETHER_WITH_GETTER);
      final prevValue = wireData.value;
      final nextValue = (value is Function) ? value(prevValue) : value;
      wireData.value = nextValue;
      Future.forEach(_MIDDLEWARE_LIST, (WireMiddleware m) async =>
        await m.onData(key, prevValue, nextValue));
    }
    return wireData;
  }
}
