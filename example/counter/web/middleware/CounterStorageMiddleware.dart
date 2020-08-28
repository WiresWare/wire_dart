import 'dart:html';

import 'package:wire/src/main.dart';
import '../const/CounterParams.dart';

class CounterStorageMiddleware extends WireMiddleware {
  final ls = window.localStorage;

  @override
  void onAdd(Wire wire) {
    print('> CounterMiddleware -> onAdd: signal = ${wire.signal} | scope = ${wire.scope}');
  }

  @override
  void onData(String key, prevValue, nextValue) {
    print('> CounterMiddleware -> onData: key = ${key} | ${prevValue}-${nextValue}');
    if (key == CounterDataKeys.COUNT) {
      if (nextValue != null) {
        ls[CounterDataKeys.COUNT] = nextValue.toString();
      }
      else {
        if (ls.containsValue(CounterDataKeys.COUNT)) {
          ls.remove(CounterDataKeys.COUNT);
        }
      }
    }
  }

  @override
  void onRemove(String signal, [Object scope, listener]) {
    print('> CounterMiddleware -> onRemove: signal = ${signal} | ${scope} | ${listener}');
  }

  @override
  void onSend(String signal, [data, scope]) {
    print('> CounterMiddleware -> onSend: signal = ${signal} | data = ${data} | scope = ${scope}');
  }

  int getInitialValue() {
    return ls.containsKey(CounterDataKeys.COUNT) ?
      int.parse(ls[CounterDataKeys.COUNT]) : 0;
  }
}
