part of wire;

///
/// Created by Vladimir Cores (Minkin) on 07/10/19.
/// Github: https://github.com/DQvsRA
/// License: APACHE LICENSE, VERSION 2.0
///
class WireCommunicateLayer {
  final Map<int, Wire> _wireById = <int, Wire>{};
  final Map<String, List<int>> _wireIdsBySignal = <String, List<int>>{};

  Wire add(Wire wire) {
    final wireId = wire.id;
    final signal = wire.signal;

    if (_wireById.containsKey(wireId)) {
      throw ERROR__WIRE_ALREADY_REGISTERED + wireId.toString();
    }

    _wireById[wireId] = wire;

    if (!_wireIdsBySignal.containsKey(signal)) {
      _wireIdsBySignal[signal] = <int>[];
    }

    _wireIdsBySignal[signal].add(wireId);

    return wire;
  }

  bool hasSignal(String signal) {
    return _wireIdsBySignal.containsKey(signal);
  }

  bool hasWire(Wire wire) {
    return _wireById.containsKey(wire.id);
  }

  bool send(String signal, [payload, scope]) {
    var noMoreSubscribers = true;
    if (hasSignal(signal)) {
      var WiresToRemove = <Wire>[];
      _wireIdsBySignal[signal].forEach((wid) {
        final wire = _wireById[wid];
        if (scope != null && wire.scope != scope) return;
        noMoreSubscribers = wire.replies > 0 && --wire.replies == 0;
        if (noMoreSubscribers) WiresToRemove.add(wire);
        wire.transfer(payload);
      });
      WiresToRemove.forEach((r) => noMoreSubscribers = _removeWire(r));
    }
    return noMoreSubscribers;
  }

  bool remove(String signal, [Object scope, WireListener listener]) {
    var exists = hasSignal(signal);
    if (exists) {
      var toRemove = <Wire>[];
      _wireIdsBySignal[signal].forEach((wid) {
        var wire = _wireById[wid];
        var isWrongScope = scope != null && scope != wire.scope;
        var isWrongListener = listener != null && listener != wire.listener;
        if (isWrongScope || isWrongListener) return;
        toRemove.add(wire);
      });
      toRemove.forEach((r) => _removeWire(r));
    }
    return exists;
  }

  void clear() {
    var wireToRemove = <Wire>[];
    _wireById.forEach((h, w) => wireToRemove.add(w));
    wireToRemove.forEach(_removeWire);
    _wireById.clear();
    _wireIdsBySignal.clear();
  }

  List<Wire> getBySignal(String signal) {
    return hasSignal(signal)
        ? _wireIdsBySignal[signal].map((wid) => _wireById[wid])
        : <Wire>[];
  }

  List<Wire> getByScope(Object scope) {
    var result = <Wire>[];
    _wireById
        .forEach((wid, wire) => {if (wire.scope == scope) result.add(wire)});
    return result;
  }

  List<Wire> getByListener(WireListener listener) {
    var result = <Wire>[];
    _wireById.forEach(
        (wid, wire) => {if (wire.listener == listener) result.add(wire)});
    return result;
  }

  Wire getByWID(int wid) {
    return _wireById.containsKey(wid) ? _wireById[wid] : null;
  }

  ///
  /// Exclude a Wire based on an signal.
  ///
  /// @param    The Wire to remove.
  /// @return If there is no ids (no Wires) for that SIGNAL stop future perform
  ///
  bool _removeWire(Wire wire) {
    var wid = wire.id;
    var signal = wire.signal;

    // Remove Wire by wid
    _wireById.remove(wid);

    // Remove wid for Wire signal
    var widsForSignal = _wireIdsBySignal[signal];
    widsForSignal.remove(wid);

    var noMoreSignals = widsForSignal.isEmpty;
    if (noMoreSignals) _wireIdsBySignal.remove(signal);

    wire.clear();

    return noMoreSignals;
  }
}

class WireDataContainerLayer {
  final Map<String, WireData> _map = <String, WireData>{};
  WireData get(String key) {
    if (!_map.containsKey(key)) {
      _map[key] = WireData(key, _map.remove);
    }

    return _map[key];
  }

  void clear() {
    _map.forEach((key, wireData) {
      wireData.remove();
    });
    _map.clear();
  }
}
