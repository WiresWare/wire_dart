part of wire;

///
/// Created by Vladimir Cores (Minkin) on 07/10/19.
/// Github: https://github.com/DQvsRA
/// License: APACHE LICENSE, VERSION 2.0
///
class WireLayer {
  final Map<int, Wire> _wireByHash = <int, Wire>{};
  final Map<String, List<int>> _hashesBySignal = <String, List<int>>{};

  Wire add(Wire wire) {
    final hash = wire.hash;
    final signal = wire.signal;

    if (_wireByHash.containsKey(hash)) {
      throw ERROR__WIRE_ALREADY_REGISTERED + hash.toString();
    }

    _wireByHash[hash] = wire;

    if (!_hashesBySignal.containsKey(signal)) {
      _hashesBySignal[signal] = <int>[];
    }

    _hashesBySignal[signal].add(hash);

    return wire;
  }

  bool hasSignal(String signal) {
    return _hashesBySignal.containsKey(signal);
  }

  bool hasWire(Wire wire) {
    return _wireByHash.containsKey(wire.hash);
  }

  bool send(String signal, [data]) {
    var noMoreSubscribers = true;
    if (hasSignal(signal)) {
      var WiresToRemove = <Wire>[];
      _hashesBySignal[signal].forEach((hash) {
        var wire = _wireByHash[hash];
        var replies = wire.replies;
        noMoreSubscribers = replies > 0 && --replies == 0;
        if (noMoreSubscribers) WiresToRemove.add(wire);
        wire.replies = replies;
        wire.transfer(data);
      });
      WiresToRemove.forEach((r) => noMoreSubscribers = _removeWire(r));
    }
    return noMoreSubscribers;
  }

  bool remove(String signal, [Object scope, WireListener listener]) {
    var exists = hasSignal(signal);
    if (exists) {
      var toRemove = <Wire>[];
      _hashesBySignal[signal].forEach((hash) {
        var wire = _wireByHash[hash];
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
    _wireByHash.forEach((h, w) => wireToRemove.add(w));
    wireToRemove.forEach(_removeWire);
    _wireByHash.clear();
    _hashesBySignal.clear();
  }

  List<Wire> getBySignal(String signal) {
    return hasSignal(signal)
        ? _hashesBySignal[signal].map((hash) => _wireByHash[hash])
        : <Wire>[];
  }

  List<Wire> getByScope(Object scope) {
    var result = <Wire>[];
    _wireByHash
        .forEach((hash, wire) => {if (wire.scope == scope) result.add(wire)});
    return result;
  }

  List<Wire> getByListener(WireListener listener) {
    var result = <Wire>[];
    _wireByHash.forEach(
        (hash, wire) => {if (wire.listener == listener) result.add(wire)});
    return result;
  }

  ///
  /// Exclude a Wire based on an signal.
  ///
  /// @param    The Wire to remove.
  /// @return If there is no hashes (no Wires) for that SIGNAL stop future perform
  ///
  bool _removeWire(Wire wire) {
    var hash = wire.hash;
    var signal = wire.signal;

    // Remove Wire by hash
    _wireByHash.remove(hash);

    // Remove hash for Wire signal
    var hashesForSignal = _hashesBySignal[signal];
    hashesForSignal.remove(hash);

    var noMoreSignals = hashesForSignal.isEmpty;
    if (noMoreSignals) _hashesBySignal.remove(signal);

    wire.clear();

    return noMoreSignals;
  }
}
