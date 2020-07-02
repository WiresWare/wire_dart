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
  void onData(String param, prevValue, nextValue) {
    print('> CounterMiddleware -> onData: param = ${param} | ${prevValue}-${nextValue}');
    if (param == CounterParams.COUNT) {
      if (nextValue != null) {
        ls[CounterParams.COUNT] = nextValue.toString();
      }
      else {
        if (ls.containsValue(CounterParams.COUNT)) {
          ls.remove(CounterParams.COUNT);
        }
      }
    }
  }

  @override
  void onRemove(String signal, [Object scope, listener]) {
    print('> CounterMiddleware -> onRemove: signal = ${signal} | ${scope} | ${listener}');
  }

  @override
  void onSend(String signal, [data]) {
    print('> CounterMiddleware -> onSend: signal = ${signal} | data = ${data}');
  }

  int getInitialValue() {
    return ls.containsKey(CounterParams.COUNT) ?
      int.parse(ls[CounterParams.COUNT]) : 0;
  }
}