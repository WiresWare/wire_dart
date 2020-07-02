part of wire;

///
/// Created by Vladimir Cores (Minkin) on 12/06/20.
/// Github: https://github.com/DQvsRA
/// License: APACHE LICENSE, VERSION 2.0
///
class WireStore {
  final Map<String, WireData> _map = <String, WireData>{};
  dynamic get(String key) {
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
