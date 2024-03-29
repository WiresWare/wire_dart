library wire;

import 'package:wire/wire.dart';

mixin WireMixinWithWireData {
  bool hasNot(String dataKey) => !has(dataKey);
  bool has(String dataKey) => Wire.data(dataKey).isSet;

  Future<T> get<T>(String dataKey) => Future(() {
        if (has(dataKey)) {
          return Future.value(Wire.data(dataKey).value as T);
        } else {
          return Future.error('Error: missing data on key - ${dataKey}');
        }
      });

  Future<Map<String, dynamic>> getMany(List<String> many) =>
      Future.wait(many.map((e) async => get(e))).then((List<dynamic> results, {int index = 0}) {
        return many.fold<Map<String, dynamic>>(
            {}, (Map<String, dynamic> p, key) => p..putIfAbsent(key, () => results[index++]));
      });

  void update(String dataKey, {dynamic data, bool refresh = true}) {
    // log('> MixinWithWireData -> update(${dataKey}): $data');
    if (data != null) {
      Wire.data(dataKey, value: data);
    } else if (refresh) {
      Wire.data(dataKey).refresh();
    }
  }

  void reset(String dataKey) {
    if (has(dataKey)) Wire.data(dataKey).reset();
  }

  Future<void> remove(String dataKey) async {
    if (has(dataKey)) await Wire.data(dataKey).remove();
  }
}
