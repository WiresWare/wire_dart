part of wire;

///
/// Created by Vladimir Cores (Minkin) on 07/10/19.
/// Github: https://github.com/DQvsRA
/// License: APACHE LICENSE, VERSION 2.0
///
class WireCommunicateLayer {
  final Map<int, Wire> _wireByWID = <int, Wire>{};
  final Map<String, List<int>> _widsBySignal = <String, List<int>>{};

  Wire add(Wire wire) {
    final wid = wire.wid;
    final signal = wire.signal;

    if (_wireByWID.containsKey(wid)) {
      throw ERROR__WIRE_ALREADY_REGISTERED + wid.toString();
    }

    _wireByWID[wid] = wire;

    if (!_widsBySignal.containsKey(signal)) {
      _widsBySignal[signal] = <int>[];
    }

    _widsBySignal[signal].add(wid);

    return wire;
  }

  bool hasSignal(String signal) {
    return _widsBySignal.containsKey(signal);
  }

  bool hasWire(Wire wire) {
    return _wireByWID.containsKey(wire.wid);
  }

  bool send(String signal, [payload, scope]) {
    var noMoreSubscribers = true;
    if (hasSignal(signal)) {
      var WiresToRemove = <Wire>[];
      _widsBySignal[signal].forEach((wid) {
        var wire = _wireByWID[wid];
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
      _widsBySignal[signal].forEach((wid) {
        var wire = _wireByWID[wid];
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
    _wireByWID.forEach((h, w) => wireToRemove.add(w));
    wireToRemove.forEach(_removeWire);
    _wireByWID.clear();
    _widsBySignal.clear();
  }

  List<Wire> getBySignal(String signal) {
    return hasSignal(signal)
        ? _widsBySignal[signal].map((wid) => _wireByWID[wid])
        : <Wire>[];
  }

  List<Wire> getByScope(Object scope) {
    var result = <Wire>[];
    _wireByWID
        .forEach((wid, wire) => {if (wire.scope == scope) result.add(wire)});
    return result;
  }

  List<Wire> getByListener(WireListener listener) {
    var result = <Wire>[];
    _wireByWID.forEach(
        (wid, wire) => {if (wire.listener == listener) result.add(wire)});
    return result;
  }

  Wire getByWID(int wid) {
    return _wireByWID.containsKey(wid) ? _wireByWID[wid] : null;
  }

  ///
  /// Exclude a Wire based on an signal.
  ///
  /// @param    The Wire to remove.
  /// @return If there is no ids (no Wires) for that SIGNAL stop future perform
  ///
  bool _removeWire(Wire wire) {
    var wid = wire.wid;
    var signal = wire.signal;

    // Remove Wire by wid
    _wireByWID.remove(wid);

    // Remove wid for Wire signal
    var widsForSignal = _widsBySignal[signal];
    widsForSignal.remove(wid);

    var noMoreSignals = widsForSignal.isEmpty;
    if (noMoreSignals) _widsBySignal.remove(signal);

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
