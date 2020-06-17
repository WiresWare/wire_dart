part of wire;

///
/// Created by Vladimir Cores (Minkin) on 07/10/19.
/// Github: https://github.com/DQvsRA
/// License: APACHE LICENSE, VERSION 2.0
///
class WireLayer
{
  final Map<int, Wire> _wireByHash = <int, Wire>{};
  final Map<String, List<int>> _hashesBySignal = <String, List<int>>{};

  Wire add(Wire wire)
  {
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

  bool send(String signal, [args])
  {
    var noSubscribers = true;

    if (_hashesBySignal.containsKey(signal))
    {
      var WiresToRemove = <Wire>[];
      _hashesBySignal[signal].forEach((hash) {
        var wire = _wireByHash[hash];
        var replies = wire.replies;
        noSubscribers = replies > 0 && --replies == 0;
        if (noSubscribers) WiresToRemove.add(wire);
        wire.replies = replies;
        wire.transfer(args);
      });
      WiresToRemove.forEach((r) => noSubscribers = _removeSignal(r));
    }
    return noSubscribers;
  }

  bool remove(String signal, [Object scope, Function listener])
  {
    var exists = _hashesBySignal.containsKey(signal);
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

  ///
  /// Exclude a Wire based on an signal.
  ///
  /// @param	The Wire to remove.
  /// @return If there is no hashes (no Wires) for that SIGNAL stop future perform
  ///
  bool _removeSignal(Wire wire)
  {
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
