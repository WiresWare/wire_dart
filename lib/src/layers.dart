part of wire;

///
/// Created by Vladimir Cores (Minkin) on 07/10/19.
/// Github: https://github.com/vladimircores
/// License: APACHE LICENSE, VERSION 2.0
///
class WireCommunicateLayer {
  final _wireById = <int, Wire<dynamic>>{};
  final _wireIdsBySignal = <String, List<int>>{};

  Wire<dynamic> add(Wire<dynamic> wire) {
    final wireId = wire.id;
    final signal = wire.signal;

    if (_wireById.containsKey(wireId)) {
      throw Exception(ERROR__WIRE_ALREADY_REGISTERED + wireId.toString());
    }

    _wireById[wireId] = wire;

    if (!_wireIdsBySignal.containsKey(signal)) {
      _wireIdsBySignal[signal] = <int>[];
    }

    _wireIdsBySignal[signal]!.add(wireId);

    return wire;
  }

  bool hasSignal(String signal) {
    return _wireIdsBySignal.containsKey(signal);
  }

  bool hasWire(Wire<dynamic> wire) {
    return _wireById.containsKey(wire.id);
  }

  Future<WireSendResults> send(String signal, [payload, scope]) async {
    bool noMoreSubscribers = true;
    // print('> Wire -> WireCommunicateLayer: send - hasSignal($signal) = ${hasSignal(signal)}');
    final results = [];
    if (hasSignal(signal)) {
      final hasWires = _wireIdsBySignal.containsKey(signal);
      // print('> Wire -> WireCommunicateLayer: send - hasWires = ${hasWires}');
      if (hasWires) {
        final wiresToRemove = <Wire<dynamic>>[];
        final isLookingInScope = scope != null;
        await Future.forEach<int>(_wireIdsBySignal[signal]!, (wireId) async {
          final wire = _wireById[wireId]!;
          if (isLookingInScope && wire.scope != scope) return;
          final resultData = await wire.transfer(payload).catchError(_processSendError);
          if (resultData != null) results.add(resultData);
          noMoreSubscribers = wire.withReplies && --wire.replies == 0;
          if (noMoreSubscribers) wiresToRemove.add(wire);
          // print('> \t\t wireId = ${wireId} | noMoreSubscribers = ${noMoreSubscribers}');
        });
        if (wiresToRemove.isNotEmpty) {
          await Future.forEach(wiresToRemove, (Wire<dynamic> wire) async {
            noMoreSubscribers = await _removeWire(wire);
          });
        }
      }
    }
    return WireSendResults(results, noMoreSubscribers);
  }

  WireSendError _processSendError(err) => WireSendError(ERROR__ERROR_DURING_PROCESSING_SEND, err as Exception);

  Future<bool> remove(String signal, [Object? scope, WireListener<dynamic>? listener]) async {
    final exists = hasSignal(signal);
    if (exists) {
      final withScope = scope != null;
      final withListener = listener != null;
      final toRemoveList = <Wire<dynamic>>[];
      await Future.forEach(_wireIdsBySignal[signal]!, (wireId) {
        if (_wireById.containsKey(wireId)) {
          final wire = _wireById[wireId]!;
          final isWrongScope = withScope && scope != wire.scope;
          final isWrongListener = withListener && !wire.listenerEqual(listener);
          if (isWrongScope || isWrongListener) return;
          toRemoveList.add(wire);
        }
      });
      await Future.forEach(toRemoveList, (Wire<dynamic> wireToRemove) => _removeWire(wireToRemove));
    }
    return exists;
  }

  Future<void> clear() async {
    final wiresToRemove = <Wire<dynamic>>[];
    _wireById.forEach((hash, wire) => wiresToRemove.add(wire));
    if (wiresToRemove.isNotEmpty) {
      await Future.forEach(wiresToRemove, (Wire<dynamic> wire) => _removeWire(wire));
    }

    _wireById.clear();
    _wireIdsBySignal.clear();
  }

  List<Wire<dynamic>> getBySignal(String signal) {
    return hasSignal(signal) ? _wireIdsBySignal[signal]!.map((wid) => _wireById[wid]!).toList() : <Wire<dynamic>>[];
  }

  List<Wire<dynamic>> getByScope(Object scope) {
    final result = <Wire<dynamic>>[];
    _wireById.forEach((_, wire) => {if (wire.scope == scope) result.add(wire)});
    return result;
  }

  List<Wire<dynamic>> getByListener(WireListener<dynamic> listener) {
    final result = <Wire<dynamic>>[];
    // print('> Wire -> WireCommunicateLayer: getByListener, listener = ${listener}');
    _wireById.forEach((_, wire) {
      final compareListener = wire.listenerEqual(listener);
      // print('\t compareListener = ${compareListener}');
      if (compareListener) result.add(wire);
    });
    // print('> \t result = ${result}');
    return result;
  }

  Wire<dynamic>? getByWireId(int wireId) {
    return _wireById.containsKey(wireId) ? _wireById[wireId] : null;
  }

  ///
  /// Exclude a Wire based on a signal.
  ///
  /// @param    The Wire to remove.
  /// @return If there is no ids (no Wires) for that SIGNAL stop future perform
  ///
  Future<bool> _removeWire(Wire<dynamic> wire) async {
    final wireId = wire.id;
    final signal = wire.signal;

    // Remove Wire by wid
    _wireById.remove(wireId);

    // Remove wid for Wire signal
    final wireIdsForSignal = _wireIdsBySignal[signal]!;
    wireIdsForSignal.remove(wireId);

    final noMoreSignals = wireIdsForSignal.isEmpty;
    if (noMoreSignals) _wireIdsBySignal.remove(signal);

    await wire.clear();

    return noMoreSignals;
  }
}

class WireMiddlewaresLayer {
  final _MIDDLEWARE_LIST = <WireMiddleware>[];

  bool has(WireMiddleware middleware) => _MIDDLEWARE_LIST.contains(middleware);
  void add(WireMiddleware middleware) => _MIDDLEWARE_LIST.add(middleware);
  void clear() => _MIDDLEWARE_LIST.clear();

  Future<void> onData(String key, dynamic prevValue, dynamic nextValue) async {
    return _process((WireMiddleware m) => m.onData(key, prevValue, nextValue));
  }

  Future<void> onReset(String key, dynamic prevValue) async {
    return _process((WireMiddleware m) => m.onData(key, prevValue, null));
  }

  Future<void> onRemove(String signal, {Object? scope, WireListener<dynamic>? listener}) async {
    return _process((WireMiddleware mw) => mw.onRemove(signal, scope, listener));
  }

  Future<void> onSend(String signal, dynamic payload) async {
    return _process((WireMiddleware mw) => mw.onSend(signal, payload));
  }

  Future<void> onAdd(Wire<dynamic> wire) async {
    return _process((WireMiddleware mw) => mw.onAdd(wire));
  }

  Future<void> _process(Function(WireMiddleware mw) p) async {
    if (_MIDDLEWARE_LIST.isNotEmpty) {
      await Future.forEach(_MIDDLEWARE_LIST, p);
    }
  }
}

class WireDataContainerLayer {
  final _dataMap = <String, WireData>{};

  bool _remove(String key) => _dataMap.remove(key) != null;

  bool has(String key) => _dataMap.containsKey(key);
  WireData get(String key) => _dataMap[key]!;
  WireData create(String key, WireDataOnReset onReset) {
    final result = WireData(key, _remove, onReset);
    _dataMap[key] = result;
    return result;
  }

  Future<void> clear() async {
    final wireDataToRemove = <WireData>[];
    _dataMap.forEach((key, wireData) => wireDataToRemove.add(wireData));
    await Future.forEach(wireDataToRemove, (WireData wireData) async => wireData.remove(clean: true));

    _dataMap.clear();
  }
}
