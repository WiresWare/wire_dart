import 'package:wire/wire.dart';

void main() {
  /// SUBSCRIBER and API EXAMPLE ======================================
  const
    SIGNAL_1 = 'SIGNAL_1',
    SIGNAL_ONCE = 'SIGNAL_1_ONCE',
    SIGNAL_2 = 'SIGNAL_2';

  final SCOPE = Object();

  Wire.add(SCOPE, SIGNAL_1, (dynamic data, int? wid) async {
    print('> SIGNAL 1 (subscriber 1) -> Hello: ${data}');
  });

  Future<void> listener1(dynamic data, int? wid) async {
    print('> SIGNAL 1 (subscriber 2) -> Hello: ${data}');
  }

  Wire.add(SCOPE, SIGNAL_1, listener1);
  Wire.middleware(TestWireMiddleware());

  Wire.send(SIGNAL_1, payload: 'World');
  Wire.send(SIGNAL_1, payload: 'Dart');
  Wire.send(SIGNAL_1, payload: 'Vladimir');
  Wire.remove(signal: SIGNAL_1);

  /// SUBSCRIBER END =========================================
  ///
  /// REMOVE EXAMPLE ===========================================
  Future<void> listener2(dynamic data, int? wid) async {
    print('> Remove: SIGNAL (listener 2) -> data: ${data}');
  }
  final SCOPE_2 = Object();
  const SIGNAL_3 = 'SIGNAL_3';
  const SIGNAL_4 = 'SIGNAL_4';

  /* 1 */ Wire.add(SCOPE, SIGNAL_3, listener2); // Will be removed in ***
  /* 2 */ Wire.add(SCOPE, SIGNAL_4, listener2);
  /* 3 */ Wire.add(SCOPE_2, SIGNAL_3, listener2); // Will be removed in ***
  /* 4 */ Wire.add(SCOPE_2, SIGNAL_4,
      (dynamic data, int? wid) async => print('> Remove: SIGNAL 2 -> dynamic data: ${data}'));
  /* 4 */ Wire.add<String>(SCOPE_2, SIGNAL_4,
      (String? data, int? wid) async => print('> Remove: SIGNAL 2 -> String data: ${data}'));
  /* 5 */ Wire.add<bool>(SCOPE_2, SIGNAL_4,
      (bool? data, int? wid) async => print('> Remove: SIGNAL 2 -> Boolean data: ${data}'));

  // *** (remove)
  /* 1 */ Wire.remove(signal: SIGNAL_3, listener: listener2);
  /* 3 */ Wire.remove(signal: SIGNAL_3, scope: SCOPE_2);

  /* 1, 3 */ Wire.send(SIGNAL_3, payload: 'SIGNAL_3');
  /* 4 */ Wire.send(SIGNAL_4, payload: 'SIGNAL_4');
  /* 5 */ Wire.send(SIGNAL_4, payload: false);

  /* 2 */ Wire.remove(signal: SIGNAL_1, scope: SCOPE);
  /* 4 */ Wire.remove(signal: SIGNAL_2, scope: SCOPE_2);

  /// ONCE EXAMPLE ===========================================
  Wire.add(SCOPE, SIGNAL_ONCE, (dynamic data, int? wid) async {
    print('> SIGNAL 1 (limit 1) -> Goodbye: ${data}');
  }, replies: 1);

  print('\tNo ends: ${Wire.send(SIGNAL_ONCE, payload: 'World')}');
  print('\tNo ends: ${Wire.send(SIGNAL_ONCE, payload: 'Dart')}');
  print('\tNo ends: ${Wire.send(SIGNAL_ONCE, payload: 'Peace')}');

  /// ONCE END ===============================================

  Wire.add(SCOPE, SIGNAL_2, (dynamic data, int? wid) async {
    print('> SIGNAL 2 -> I do: ${data}');
  });

  Wire.add(SCOPE, SIGNAL_2, (dynamic data, int? wid) async {
    print('> SIGNAL 2 (limit 2) -> I do: ${data}');
  }, replies: 2);

  print('\tSend ends: ${Wire.send(SIGNAL_2, payload: 'Code')}');
  print('\tSend ends: ${Wire.send(SIGNAL_2, payload: 'Gym')}');
  print('\tSend ends: ${Wire.send(SIGNAL_2, payload: 'Eat (sometimes)')}');
  print('\tSend ends: ${Wire.send(SIGNAL_2, payload: 'Sleep')}');
  print('\tSend ends: ${Wire.send(SIGNAL_2, payload: 'Repeat')}');

  /// DATA TESTS ===============================================
  const key1 = 'SUPER_PARAM';
  Wire.data(key1).subscribe((data) async => {print('\t Listener 1 -> ${data}')});

  Wire.data(key1).subscribe((data) async => {print('\t Listener 2 -> ${data}')});

  print('> Wire.data Listeners: where initial data = ${Wire.data(key1).value}');
  Wire.data(key1, value: 'Set VALUE to key1: $key1');
  Wire.data(key1, value: (value) => '${value} | APPENDED from function call');
}

class TestWireMiddleware extends WireMiddleware {
  @override
  Future<void> onAdd(Wire<dynamic> wire) async {
    print('> TestWireMiddleware -> onAdd: Wire.signal = ${wire.signal}');
  }

  @override
  Future<void> onData(String key, prevValue, nextValue) async {
    print('> TestWireMiddleware -> onData: key = ${key} | $prevValue | $nextValue');
  }

  @override
  Future<void> onRemove(String signal, [Object? scope, listener]) async {
    print('> TestWireMiddleware -> onRemove: signal = ${signal} | $scope | $listener');
  }

  @override
  Future<void> onSend(String? signal, [payload, scope]) async {
    print('> TestWireMiddleware -> onRemove: signal = ${signal} | $payload');
  }
}
