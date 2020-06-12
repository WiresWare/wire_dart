part of wire;

///
/// Created by Vladimir Cores (Minkin) on 07/10/19.
/// Github: https://github.com/DQvsRA
/// License: MIT
///
class WireLayer
{
  LinkedHashMap<int, Wire> _wireByHash = Map<int, Wire>();
  Map<String, List<int>> _hashesBySignal = Map<String, List<int>>();

  add(Wire wire)
  {
    int hash = wire.hash;
    String signal = wire.signal;

    _wireByHash[hash] = wire;

    if (_hashesBySignal.containsKey(signal)) {
      _hashesBySignal[signal].add(hash);
    } else { _hashesBySignal[signal] = [hash]; }
  }

  bool send(String signal, [args])
  {
    var noSubscribers = true;

    if (_hashesBySignal.containsKey(signal))
    {
      var WiresToRemove = <Wire>[];
      _hashesBySignal[signal].forEach((hash) {
        Wire wire = _wireByHash[hash];
        int replies = wire.replies;
        noSubscribers = replies > 0 && --replies == 0;
        if (noSubscribers) WiresToRemove.add(wire);
        wire.replies = replies;
        wire.transfer(args);
      });
      WiresToRemove.forEach((r) => noSubscribers = _removeSignal(r));
    }
    return noSubscribers;
  }

  bool remove(String signal)
  {
    bool exists = _hashesBySignal.containsKey(signal);
    if (exists) {
      var toRemove = List<Wire>();
      _hashesBySignal[signal].forEach((hash) => toRemove.add(_wireByHash[hash]));
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
    int hash = wire.hash;
    String signal = wire.signal;

    // Remove Wire by hash
    _wireByHash.remove(hash);

    // Remove hash for Wire signal
    List<int> hashesForSignal = _hashesBySignal[signal];
    hashesForSignal.remove(hash);

    bool noMoreSignals = hashesForSignal.isEmpty;
    if (noMoreSignals) _hashesBySignal.remove(signal);

    return noMoreSignals;
  }
}
