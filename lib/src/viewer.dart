import 'main.dart';

class WireViewerMiddleware extends WireMiddleware {
  WireViewerMiddleware();

  @override
  Future<void> onAdd(Wire wire) async {
    print(
        '> WireViewerMiddleware -> onAdd: signal = ${wire.signal} | scope = ${wire.scope}');
  }

  @override
  Future<void> onData(String key, prevValue, nextValue) async {
    print(
        '> WireViewerMiddleware -> onData - key: ${key} | value: ${nextValue}-${prevValue}');
  }

  @override
  Future<void> onRemove(String signal, [Object? scope, WireListener? listener]) async {
    print(
        '> WireViewerMiddleware -> onRemove: signal = ${signal} | ${scope} | ${listener}');
  }

  @override
  Future<void> onSend(String signal, [data, scope]) async {
    print(
        '> WireViewerMiddleware -> onSend: signal = ${signal} | data = ${data} | scope = ${scope}');
  }
}