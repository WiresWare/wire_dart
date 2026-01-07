import 'package:wire/src/const.dart';
import 'package:wire/src/data.dart';
import 'package:wire/src/layers.dart';
import 'package:wire/src/results.dart';

/// Wire - communication and data layers which consist of string keys, thus realization of String API when each component of the system - logical or visual - represented as a set of Strings - what it consumes is Data API and what it produces or reacts to is Signals API.
///
/// Wire is a kind of "pub/sub" library - communication layer or "bus" to which you can attach a wire and listen for signal associated with it.
/// Wire has simplest possible API - add, remove and send. Also it has data layer, universal container with key-value, where value is an object WireData type that holds dynamic value and can be subscribed for updates. This "data container" is something like Redis.
///
/// Created by Vladimir Cores (Minkin) on 07/10/19.
/// Github: https://github.com/vladimircores
/// License: APACHE LICENSE, VERSION 2.0
///

typedef WireListener<T> = Future<dynamic> Function(T? payload, int wireId);
typedef WireValueFunction<T> = T? Function(T? prevValue);

abstract class WireMiddleware {
  Future<void> onAdd(Wire<dynamic> wire);
  Future<void> onSend(String signal, [Object? payload, Object? scope]);
  Future<void> onRemove(String signal, [Object? scope, WireListener<dynamic>? listener]);
  Future<void> onData(String key, dynamic prevValue, dynamic nextValue);
  Future<void> onDataError(dynamic error, String key, dynamic value);
  Future<void> onReset(String key, dynamic value);
}

class Wire<T> {
  /// Wire object is a communication unit of the system, each instance associated with a signal
  ///
  /// Wire object can be passed as a reference to any component of the your system
  /// But it wont react on signal until it is attached to the communication layer with [attach]
  /// However you still can send data through it by calling [transfer]
  ///
  Wire(Object scope, String signal, WireListener<T> listener, [int replies = 0]) {
    _scope = scope;
    _signal = signal;
    _listener = listener;
    this.replies = replies;
    _id = ++_INDEX;
  }

  ///
  /// [read-only] [static]
  /// Used to generate Wire wid
  ///
  /// @private
  static int _INDEX = 0;
  static final _COMMUNICATION_LAYER = WireCommunicateLayer();
  static final _DATA_CONTAINER_LAYER = WireDataContainerLayer();
  static final _MIDDLEWARE_LAYER = WireMiddlewaresLayer();

  ///**************************************************
  ///  Protected / Private Properties
  ///**************************************************

  ///
  /// [read-only]
  /// The SIGNAL associated with this Wire.
  ///
  /// @private
  late String? _signal;
  String get signal => _signal!;

  ///
  /// [read-only]
  /// The closure method, reaction to the Wire instance changes.
  ///
  /// @private
  WireListener<T>? _listener;
  bool listenerEqual(WireListener<dynamic> listener) {
    return _listener == listener;
  }

  ///
  /// [read-only] [internal use]
  /// Unique identification for wire instance.
  ///
  /// @private
  late int? _id;
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

  /// Call associated WireListener with data.
  Future<dynamic> transfer(dynamic payload) async {
    if (_listener == null) throw Exception(ERROR__LISTENER_IS_NULL);
    // Call a listener in this Wire only in case data type match it's listener type.
    final isFilterByPayloadType = payload is T || payload == null;
    print('> Wire -> transfer(${T}): isFilterByPayloadType = ${isFilterByPayloadType}');
    if (isFilterByPayloadType) return _listener!(payload, _id!);
  }

  /// Nullify all relations
  void clear() {
    _scope = null;
    _listener = null;
  }

  ///**********************************************************************************************************
  ///
  ///  Public Static Methods - API
  ///
  ///**********************************************************************************************************

  /// Add wire object to the communication layer
  static void attach(Wire<dynamic> wire) {
    _COMMUNICATION_LAYER.add(wire);
  }

  /// Remove wire object from communication layer, then inform all middlewares with
  /// Returns existence of another wires with that signal.
  static Future<bool> detach(Wire<dynamic> wire) {
    return remove(signal: wire.signal, scope: wire.scope);
  }

  /// Create wire object from params and [attach] it to the communication layer
  /// All middleware will be informed from [WireMiddleware.onAdd] before wire is attached to the layer
  static Future<Wire<T>> add<T>(Object scope, String signal, WireListener<T> listener, {int replies = 0}) async {
    final wire = Wire<T>(scope, signal, listener, replies);
    await _MIDDLEWARE_LAYER.onAdd(wire);
    attach(wire);
    return wire;
  }

  /// Register many signals at once
  static Future<List<Wire<dynamic>>> addMany(Object scope, Map<String, WireListener<dynamic>> signalToHandlerMap) {
    return Future.wait(signalToHandlerMap.entries.map((e) async => Wire.add(scope, e.key, e.value)));
  }

  /// Check if signal string or wire instance exists in communication layer
  static bool has<T>({String? signal, Wire<T>? wire}) {
    if (signal != null) return _COMMUNICATION_LAYER.hasSignal(signal);
    if (wire != null) return _COMMUNICATION_LAYER.hasWire(wire);
    return false;
  }

  /// Send signal through all wires has the signal string value
  /// Payload is optional, default is null, passed to WireListener from [transfer]
  /// If use scope then only wire with this scope value will receive the payload
  /// All middleware will be informed from [WireMiddleware.onSend] before signal sent on wires
  ///
  /// Returns WireSendResults which contains data from all listeners that react on the signal
  static Future<WireSendResults> send<T>(String signal, {T? payload, Object? scope}) async {
    await _MIDDLEWARE_LAYER.onSend(signal, payload);
    return _COMMUNICATION_LAYER.send(signal, payload, scope);
  }

  /// Remove all entities from Communication Layer and Data Container Layer
  /// @param [withMiddleware] used to remove all middleware
  static Future<void> purge({bool? withMiddleware}) async {
    await _COMMUNICATION_LAYER.clear();
    await _DATA_CONTAINER_LAYER.clear();
    if (withMiddleware ?? false) {
      _MIDDLEWARE_LAYER.clear();
    }
  }

  /// Remove all wires for specific signal, for more precise target to remove add scope and/or listener
  /// All middleware will be informed from [WireMiddleware.onRemove] after signal removed, only if existed
  /// Returns [bool] telling signal existed in communication layer
  static Future<bool> remove({String? signal, Object? scope, WireListener<dynamic>? listener}) async {
    if (signal != null) return _removeAllBySignal(signal, listener: listener);
    if (scope != null) return (await _removeAllByScope(scope, listener: listener)).isNotEmpty;
    if (listener != null) return (await _removeAllByListener(listener)).isNotEmpty;
    return false;
  }

  static Future<bool> _removeAllBySignal(String signal, {Object? scope, WireListener<dynamic>? listener}) async {
    final existed = await _COMMUNICATION_LAYER.remove(signal, scope, listener);
    if (existed) _MIDDLEWARE_LAYER.onRemove(signal, scope: scope, listener: listener);
    return existed;
  }

  static Future<List<bool>> _removeAllByScope<T>(Object scope, {WireListener<dynamic>? listener}) async {
    final listOfWiresForScope = List.from(_COMMUNICATION_LAYER.getByScope(scope));
    return Future.wait(
      listOfWiresForScope.map((dynamic item) async {
        final wire = item as Wire<dynamic>;
        return _removeAllBySignal(wire.signal, scope: scope, listener: listener);
      }),
    );
  }

  static Future<List<bool>> _removeAllByListener(WireListener<dynamic> listener) async {
    final listOfWiresWithListener = List.from(_COMMUNICATION_LAYER.getByListener(listener));
    return Future.wait(
      listOfWiresWithListener.map((dynamic item) async {
        final wire = item as Wire<dynamic>;
        return _removeAllBySignal(wire.signal, scope: wire.scope, listener: listener);
      }),
    );
  }

  /// Class extending [WireMiddleware] can listen to all processes inside Wire
  static void middleware(WireMiddleware value) {
    if (!_MIDDLEWARE_LAYER.has(value))
      _MIDDLEWARE_LAYER.add(value);
    else
      throw Exception(ERROR__MIDDLEWARE_EXISTS + value.toString());
  }

  /// When you need Wires associated with signal or scope or listener
  /// Returns [List<Wire>]
  static List<Wire<dynamic>> get<T>({String? signal, Object? scope, WireListener<dynamic>? listener, int? wireId}) {
    final result = <Wire<dynamic>>[];
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
      final instance = _COMMUNICATION_LAYER.getByWireId(wireId);
      if (instance != null) result.add(instance);
    }
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
  static WireData<T> data<T>(String key, {dynamic value, WireDataGetter<T>? getter}) {
    final wireData = _DATA_CONTAINER_LAYER.has(key) ? _DATA_CONTAINER_LAYER.get<T>(key) : _DATA_CONTAINER_LAYER.create<T>(key, _MIDDLEWARE_LAYER.onReset, _MIDDLEWARE_LAYER.onDataError);

    if (getter != null) {
      wireData.getter = getter;
      wireData.lock(WireDataLockToken());
    }
    // print('> Wire -> WireData - data key = ${key}, value = ${value}, getter = ${getter}, isGetter: ${wireData.isGetter}');
    if (value != null) {
      if (wireData.isGetter) throw Exception(ERROR__VALUE_IS_NOT_ALLOWED_TOGETHER_WITH_GETTER);
      final prevValue = wireData.isSet ? wireData.value : null;
      final nextValue = ((value is WireValueFunction<T>) ? value(prevValue) : value) as T;
      _MIDDLEWARE_LAYER.onData(key, prevValue, nextValue);
      wireData.value = nextValue;
    }
    return wireData;
  }

  /// Store an instance of the object by it's type, and lock it, so it can't be overwritten
  static T put<T>(T instance, {WireDataLockToken? lock}) {
    final key = instance.runtimeType.toString();
    // print('> WireData -> put: ${key} - ${instance}');
    final wireData = Wire.data<T>(key);
    if (wireData.isSet && wireData.isLocked) {
      throw AssertionError(ERROR__CANT_PUT_ALREADY_EXISTING_INSTANCE);
    }
    Wire.data<T>(key, value: instance).lock(lock ?? WireDataLockToken());
    return instance;
  }

  /// Return an instance of an object by its type, throw an error in case it is not set
  static T find<T>() {
    final key = T.toString();
    final wireData = Wire.data<T>(key);
    // print('> WireData -> find: ${key} - ${Wire.data<T>(key).value}');
    if (wireData.isSet == false) {
      throw AssertionError(ERROR__CANT_FIND_INSTANCE_NULL);
    }
    return wireData.value!;
  }
}
