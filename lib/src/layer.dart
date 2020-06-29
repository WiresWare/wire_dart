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
    var hash = wire.hash;
    var signal = wire.signal;

    _wireByHash[hash] = wire;

    if (_hashesBySignal.containsKey(signal)) {
      _hashesBySignal[signal].add(hash);
    } else {
      _hashesBySignal[signal] = [hash];
    }

    return wire;
  }

  bool hasSignal(String signal) {
    return _hashesBySignal.containsKey(signal);
  }

  bool hasWire(Wire wire) {
    return _wireByHash.containsKey(wire.hash);
  }

  bool send(String signal, [data]) {
    var noSubscribers = true;

    if (hasSignal(signal)) {
      var WiresToRemove = <Wire>[];
      _hashesBySignal[signal].forEach((hash) {
        var wire = _wireByHash[hash];
        var replies = wire.replies;
        noSubscribers = replies > 0 && --replies == 0;
        if (noSubscribers) WiresToRemove.add(wire);
        wire.replies = replies;
        wire.transfer(data);
      });
      WiresToRemove.forEach((r) => noSubscribers = _removeSignal(r));
    }
    return noSubscribers;
  }

  bool remove(String signal, [Object scope, Function listener]) {
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
      toRemove.forEach((r) => _removeSignal(r));
    }
    return exists;
  }

  List<Wire> getBySignal(String signal) {
    return hasSignal(signal) ?
      _hashesBySignal[signal].map((hash) =>
        _wireByHash[hash])
      : <Wire>[];
  }

  List<Wire> getByScope(Object scope) {
    var result = <Wire>[];
    _wireByHash.forEach((hash, wire) => {
      if (wire.scope == scope) result.add(wire)
    });
    return result;
  }

  List<Wire> getByListener(Function listener) {
    var result = <Wire>[];
    _wireByHash.forEach((hash, wire) => {
      if (wire.listener == listener) result.add(wire)
    });
    return result;
  }

  ///
  /// Exclude a Wire based on an signal.
  ///
  /// @param    The Wire to remove.
  /// @return If there is no hashes (no Wires) for that SIGNAL stop future perform
  ///
  bool _removeSignal(Wire wire) {
    var hash = wire.hash;
    var signal = wire.signal;

    // Remove Wire by hash
    _wireByHash.remove(hash);

    // Remove hash for Wire signal
    var hashesForSignal = _hashesBySignal[signal];
    hashesForSignal.remove(hash);

    var noMoreSignals = hashesForSignal.isEmpty;
    if (noMoreSignals) _hashesBySignal.remove(signal);

    return noMoreSignals;
  }
}
