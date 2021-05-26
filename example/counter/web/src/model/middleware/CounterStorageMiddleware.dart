import 'dart:html';

import 'package:wire/src/main.dart';

import '../../const/CounterDataKeys.dart';

class CounterStorageMiddleware extends WireMiddleware {
  final storage = window.localStorage;

  @override
  Future<void> onAdd(Wire wire) async {
    print('> CounterMiddleware -> onAdd: signal = ${wire.signal} | scope = ${wire.scope}');
  }

  @override
  Future<void> onData(String key, prevValue, nextValue) async {
    print('> CounterMiddleware -> onData - key: ${key} = ${nextValue} (${prevValue})');
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
  Future<void> onRemove(String signal, [Object? scope, listener]) async {
    print('> CounterMiddleware -> onRemove: signal = ${signal} | ${scope} | ${listener}');
  }

  @override
  Future<void> onSend(String? signal, [data, scope]) async {
    print('> CounterMiddleware -> onSend: signal = ${signal} | data = ${data} | scope = ${scope}');
  }

  int getInitialValue() {
    return storage.containsKey(CounterDataKeys.COUNT)
      ? int.parse(storage[CounterDataKeys.COUNT]!)
      : 0;
  }
}
