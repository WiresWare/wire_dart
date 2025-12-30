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
    final results = [];
    if (hasSignal(signal)) {
      final wireIdsList = List.of(_wireIdsBySignal[signal]!);
      final isLookingInScope = scope != null;
      for (final wireId in wireIdsList) {
        if (!_wireById.containsKey(wireId)) continue;
        final wire = _wireById[wireId]!;
        if (isLookingInScope && wire.scope != scope) continue;
        final result = await wire.transfer(payload).catchError(_processSendError);
        if (wire.withReplies && --wire.replies == 0) {
          await _removeWire(wire);
        }
        if (result != null) {
          results.add(result);
        }
      }
    }
    return WireSendResults(results, !hasSignal(signal));
  }

  WireSendError _processSendError(err) => WireSendError(ERROR__ERROR_DURING_PROCESSING_SEND, err as Exception);

  Future<bool> remove(String signal, [Object? scope, WireListener<dynamic>? listener]) async {
    final exists = hasSignal(signal);
    if (exists) {
      final withScope = scope != null;
      final withListener = listener != null;
      final toRemoveList = <Wire<dynamic>>[];
      final hasWires = _wireIdsBySignal.containsKey(signal);
      if (hasWires) {
        for (final wireId in _wireIdsBySignal[signal]!) {
          if (_wireById.containsKey(wireId)) {
            final wire = _wireById[wireId]!;
            final isWrongScope = withScope && scope != wire.scope;
            final isWrongListener = withListener && !wire.listenerEqual(listener!);
            if (isWrongScope || isWrongListener) continue;
            toRemoveList.add(wire);
          }
        }
      }
      if (toRemoveList.isNotEmpty) {
        for (final wire in toRemoveList) {
          await _removeWire(wire);
        }
      }
    }
    return exists;
  }

  Future<void> clear() async {
    final wireToRemove = <Wire<dynamic>>[];
    _wireById.forEach((_, wire) => wireToRemove.add(wire));
    if (wireToRemove.isNotEmpty) {
      for (final wire in wireToRemove) {
        await _removeWire(wire);
      }
    }
    _wireById.clear();
    _wireIdsBySignal.clear();
  }

  List<Wire<dynamic>> getBySignal(String signal) {
    if (hasSignal(signal)) {
      return _wireIdsBySignal[signal]!.map((wireId) {
        return _wireById[wireId];
      }).whereType<Wire<dynamic>>().toList();
    }
    return [];
  }

  List<Wire<dynamic>> getByScope(Object scope) {
    final result = <Wire<dynamic>>[];
    _wireById.forEach((_, wire) {
      if (wire.scope == scope) result.add(wire);
    });
    return result;
  }

  List<Wire<dynamic>> getByListener(WireListener<dynamic> listener) {
    final result = <Wire<dynamic>>[];
    _wireById.forEach((_, wire) {
      if (wire.listenerEqual(listener)) result.add(wire);
    });
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

    wire.clear();

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

  Future<void> onDataError(dynamic error, String key, dynamic value) async {
    return _process((WireMiddleware m) => m.onDataError(error, key, value));
  }

  Future<void> onReset(String key, dynamic prevValue) async {
    return _process((WireMiddleware m) => m.onReset(key, prevValue));
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

  bool remove(String key) => _dataMap.remove(key) != null;

  bool has(String key) => _dataMap.containsKey(key);
  WireData get(String key) => _dataMap[key]!;
  WireData<T> create<T>(String key, WireDataOnReset<T?> onReset, WireDataOnError<T?> onError) {
    final result = WireData<T>(key, remove, onReset, onError);
    _dataMap[key] = result;
    return result;
  }

  Future<void> clear() async {
    final wireDataToRemove = <WireData>[];
    _dataMap.forEach((key, wireData) => wireDataToRemove.add(wireData));
    if (wireDataToRemove.isNotEmpty) {
      for (final wireData in wireDataToRemove) {
        await wireData.remove(clean: true);
      }
    }
    _dataMap.clear();
  }
}
