import 'dart:html';

import 'package:wire/src/main.dart';

import '../../const/CounterDataKeys.dart';

class CounterStorageMiddleware extends WireMiddleware {
  final storage = window.localStorage;

  @override
  void onAdd(Wire wire) {
    print(
        '> CounterMiddleware -> onAdd: signal = ${wire.signal} | scope = ${wire.scope}');
  }

  @override
  void onData(String key, prevValue, nextValue) {
    print(
        '> CounterMiddleware -> onData - key: ${key} = ${nextValue} (${prevValue})');
    if (key == CounterDataKeys.COUNT) {
      if (nextValue != null)
        storage[CounterDataKeys.COUNT] = nextValue.toString();
      else {
        if (storage.containsValue(CounterDataKeys.COUNT)) {
          storage.remove(CounterDataKeys.COUNT);
        }
      }
    }
  }

  @override
  void onRemove(String signal, [Object? scope, listener]) {
    print(
        '> CounterMiddleware -> onRemove: signal = ${signal} | ${scope} | ${listener}');
  }

  @override
  void onSend(String? signal, [data, scope]) {
    print(
        '> CounterMiddleware -> onSend: signal = ${signal} | data = ${data} | scope = ${scope}');
  }

  int getInitialValue() {
    return storage.containsKey(CounterDataKeys.COUNT)
        ? int.parse(storage[CounterDataKeys.COUNT]!)
        : 0;
  }
}
