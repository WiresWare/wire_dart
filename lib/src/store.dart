part of wire;

///
/// Created by Vladimir Cores (Minkin) on 12/06/20.
/// Github: https://github.com/DQvsRA
/// License: MIT
///
class WireStore
{
  Map<dynamic, WireData> _map = Map<dynamic, WireData>();
  dynamic get(dynamic param) {
    if (!_map.containsKey(param)) {
      _map[param] = WireData(param, _map.remove);
    }

    return _map[param];
  }
}