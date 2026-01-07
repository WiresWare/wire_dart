import 'dart:js_interop_unsafe';

import 'package:web/web.dart';

import 'package:wire/wire.dart';
import 'package:wire_example_counter/const/counter_data_keys.dart';

class CounterStorageMiddleware extends WireMiddleware {
  final storage = window.localStorage;

  @override
  Future<void> onAdd(Wire<dynamic> wire) async {
    print('> CounterMiddleware -> onAdd: signal = ${wire.signal} | scope = ${wire.scope}');
  }

  @override
  Future<void> onData(String key, prevValue, nextValue) async {
    print('> CounterMiddleware -> onData - key: ${key} = ${nextValue} (${prevValue})');
    if (key == CounterDataKeys.COUNT) {
      if (nextValue != null)
        storage.setItem(CounterDataKeys.COUNT, nextValue.toString());
      else {
        if (storage.has(CounterDataKeys.COUNT)) {
          storage.removeItem(CounterDataKeys.COUNT);
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
    return storage.has(CounterDataKeys.COUNT) ? int.parse(storage.getItem(CounterDataKeys.COUNT)!) : 0;
  }

  @override
  Future<void> onDataError(error, String key, value) async {
    print('> CounterMiddleware -> onDataError: key = ${key} | value = ${value}');
  }

  @override
  Future<void> onReset(String key, value) async {
    print('> CounterMiddleware -> onReset: key = ${key} | value = ${value}');
  }
}
