import 'package:wire/src/main.dart';

class WireViewerMiddleware extends WireMiddleware {
  WireViewerMiddleware();

  @override
  Future<void> onAdd(Wire<dynamic> wire) async {
    print('> WireViewerMiddleware -> onAdd: signal = ${wire.signal} | scope = ${wire.scope}');
  }

  @override
  Future<void> onData(String key, prevValue, nextValue) async {
    print('> WireViewerMiddleware -> onData - key: ${key} | value: ${nextValue}-${prevValue}');
  }

  @override
  Future<void> onRemove(String signal, [Object? scope, WireListener<dynamic>? listener]) async {
    print('> WireViewerMiddleware -> onRemove: signal = ${signal} | ${scope} | ${listener}');
  }

  @override
  Future<void> onSend(String signal, [payload, scope]) async {
    print('> WireViewerMiddleware -> onSend: signal = ${signal} | data = ${payload} | scope = ${scope}');
  }

  @override
  Future<void> onDataError(error, String key, value) {
    throw UnimplementedError();
  }

  @override
  Future<void> onReset(String key, value) {
    throw UnimplementedError();
  }
}
