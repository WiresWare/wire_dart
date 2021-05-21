part of wire;

///
/// Created by Vladimir Cores (Minkin) on 07/10/19.
/// Github: https://github.com/vladimircores
/// License: APACHE LICENSE, VERSION 2.0
///
class WireCommunicateLayer {
  final _wireById = <int?, Wire>{};
  final _wireIdsBySignal = <String?, List<int?>>{};

  Wire add(Wire wire) {
    final wireId = wire.id;
    final signal = wire.signal;

    if (_wireById.containsKey(wireId)) {
      throw ERROR__WIRE_ALREADY_REGISTERED + wireId.toString();
    }

    _wireById[wireId] = wire;

    if (!_wireIdsBySignal.containsKey(signal)) {
      _wireIdsBySignal[signal] = <int?>[];
    }

    _wireIdsBySignal[signal]!.add(wireId);

    return wire;
  }

  bool hasSignal(String? signal) {
    return _wireIdsBySignal.containsKey(signal);
  }

  bool hasWire(Wire wire) {
    return _wireById.containsKey(wire.id);
  }

  Future<bool> send(String signal, [payload, scope]) async {
    var noMoreSubscribers = true;
    if (hasSignal(signal)) {
      var wiresToRemove = <Wire?>[];
      _wireIdsBySignal[signal]!.forEach((wireId) async {
        final wire = _wireById[wireId];
        if (scope != null && wire!.scope != scope) return;
        noMoreSubscribers = wire!.replies > 0 && --wire.replies == 0;
        if (noMoreSubscribers) wiresToRemove.add(wire);
        await wire.transfer(payload);
      });
      for (var wire in wiresToRemove) noMoreSubscribers = await _removeWire(wire!);
    }
    return noMoreSubscribers;
  }

  Future<bool> remove(String signal, [Object? scope, WireListener? listener]) async {
    var exists = hasSignal(signal);
    if (exists) {
      final toRemoveList = <Wire?>[];
      _wireIdsBySignal[signal]!.forEach((wireId) {
        if (_wireById.containsKey(wireId)) {
          final wire = _wireById[wireId];
          final isWrongScope = scope != null && scope != wire!.scope;
          final isWrongListener = listener != null && listener != wire!.listener;
          if (isWrongScope || isWrongListener) return;
          toRemoveList.add(wire);
        }
      });
      for (final wireToRemove in toRemoveList) {
        await _removeWire(wireToRemove!);
      }
    }
    return exists;
  }

  Future<void> clear() async {
    var wiresToRemove = <Wire>[];
    _wireById.forEach((hash, wire) => wiresToRemove.add(wire));
    for (var wire in wiresToRemove)
      await _removeWire(wire);

    _wireById.clear();
    _wireIdsBySignal.clear();
  }

  List<Wire?> getBySignal(String signal) {
    return hasSignal(signal)
        ? _wireIdsBySignal[signal]!.map((wid) => _wireById[wid])
            as List<Wire<dynamic>?>
        : <Wire>[];
  }

  List<Wire> getByScope(Object scope) {
    var result = <Wire>[];
    _wireById.forEach((_, wire) => {if (wire.scope == scope) result.add(wire)});
    return result;
  }

  List<Wire> getByListener(WireListener listener) {
    var result = <Wire>[];
    _wireById.forEach(
        (_, wire) => {if (wire.listener == listener) result.add(wire)});
    return result;
  }

  Wire? getByWID(int wireId) {
    return _wireById.containsKey(wireId) ? _wireById[wireId] : null;
  }

  ///
  /// Exclude a Wire based on an signal.
  ///
  /// @param    The Wire to remove.
  /// @return If there is no ids (no Wires) for that SIGNAL stop future perform
  ///
  Future<bool> _removeWire(Wire wire) async {
    final wireId = wire.id;
    final signal = wire.signal;

    // Remove Wire by wid
    _wireById.remove(wireId);

    // Remove wid for Wire signal
    var wireIdsForSignal = _wireIdsBySignal[signal]!;
    wireIdsForSignal.remove(wireId);

    var noMoreSignals = wireIdsForSignal.isEmpty;
    if (noMoreSignals) _wireIdsBySignal.remove(signal);

    await wire.clear();

    return noMoreSignals;
  }
}

class WireDataContainerLayer {
  final Map<String, WireData> _dataMap = <String, WireData>{};

  WireData get(String key) => _dataMap[key]!;
  bool has(String key) => _dataMap.containsKey(key);
  WireData create(String key) {
    return _dataMap[key] = WireData(key, (id) async => await _dataMap.remove(id));
  }

  Future<void> clear() async {
    _dataMap.forEach((key, wireData) async {
      await wireData.remove();
    });
    _dataMap.clear();
  }
}
