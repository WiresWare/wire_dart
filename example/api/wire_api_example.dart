import 'package:wire/wire.dart';

main() {
  /// SUBSCRIBER and API EXAMPLE ======================================
  const String
    SIGNAL_1 = 'SIGNAL_1',
    SIGNAL_ONCE = 'SIGNAL_1_ONCE',
    SIGNAL_2 = 'SIGNAL_2';

  var SCOPE = Object();

  Wire.add(SCOPE, SIGNAL_1, (dynamic data, int wid) {
    print('> SIGNAL 1 (subscriber 1) -> Hello: ' + data);
  });

  var listener1 = (dynamic data, int wid) {
    print('> SIGNAL 1 (subscriber 2) -> Hello: ' + data);
  };

  Wire.add(SCOPE, SIGNAL_1, listener1);
  Wire.middleware(TestWireMiddleware());

  Wire.send(SIGNAL_1, 'World');
  Wire.send(SIGNAL_1, 'Dart');
  Wire.send(SIGNAL_1, 'Vladimir');
  Wire.remove(SIGNAL_1);
  /// SUBSCRIBER END =========================================
  ///
  /// REMOVE EXAMPLE ===========================================
  WireListener listener2 = (dynamic data, int wid) {
    print('> Remove: SIGNAL (listener 2) -> data: ' + data);
  };
  var SCOPE_2 = Object();
  var SIGNAL_3 = 'SIGNAL_3';
  var SIGNAL_4 = 'SIGNAL_4';

  /* 1 */ Wire.add(SCOPE, SIGNAL_3, listener2); // Will be removed
  /* 2 */ Wire.add(SCOPE, SIGNAL_4, listener2);
  /* 3 */ Wire.add(SCOPE_2, SIGNAL_3, listener2); // Will be removed
  /* 4 */ Wire.add(SCOPE_2, SIGNAL_4, (dynamic data, int wid) => print('> Remove: SIGNAL 2 -> data: ' + data));

  /* 1 */ Wire.remove(SIGNAL_3, listener: listener2);
  /* 3 */ Wire.remove(SIGNAL_3, scope: SCOPE_2);

  Wire.send(SIGNAL_3, 'SIGNAL_3');
  Wire.send(SIGNAL_4, 'SIGNAL_4');

  /* 2 */ Wire.remove(SIGNAL_1, scope: SCOPE);
  /* 4 */ Wire.remove(SIGNAL_2, scope: SCOPE_2);

  /// ONCE EXAMPLE ===========================================
  Wire.add(SCOPE, SIGNAL_ONCE, (dynamic data, int wid) {
    print('> SIGNAL 1 (limit 1) -> Goodbye: ' + data);
  }, replies: 1);

  print('\tNo ends: ' + Wire.send(SIGNAL_ONCE, 'World').toString());
  print('\tNo ends: ' + Wire.send(SIGNAL_ONCE, 'Dart').toString());
  print('\tNo ends: ' + Wire.send(SIGNAL_ONCE, 'Vladimir').toString());
  /// ONCE END ===============================================

  Wire.add(SCOPE, SIGNAL_2, (dynamic data, int wid) {
    print('> SIGNAL 2 -> I do: ' + data);
  });

  Wire.add(SCOPE, SIGNAL_2, (dynamic data, int wid) {
    print('> SIGNAL 2 (limit 2) -> I do: ' + data);
  }, replies: 2);

  print('\tSend ends: ' + Wire.send(SIGNAL_2, 'Code').toString());
  print('\tSend ends: ' + Wire.send(SIGNAL_2, 'Gym').toString());
  print('\tSend ends: ' + Wire.send(SIGNAL_2, 'Eat (sometimes)').toString());
  print('\tSend ends: ' + Wire.send(SIGNAL_2, 'Sleep').toString());
  print('\tSend ends: ' + Wire.send(SIGNAL_2, 'Repeat').toString());

  /// DATA TESTS ===============================================
  var key1 = 'SUPER_PARAM';
  Wire.data(key1).subscribe((data) => {
    print('\t Listener 1 -> ' + data)
  });

  Wire.data(key1).subscribe((data) => {
    print('\t Listener 2 -> ' + data)
  });

  print('> Wire.data Listeners: where initial data = ' + Wire.data(key1).value.toString());
  Wire.data(key1, 'Set VALUE to key1: ' + key1);
  Wire.data(key1, (value) => value + ' | APPENDED from function call');
}

class TestWireMiddleware extends WireMiddleware {
  @override
  void onAdd(Wire wire) {
    print('> TestWireMiddleware -> onAdd: Wire.signal = ${wire.signal}');
  }

  @override
  void onData(String key, prevValue, nextValue) {
    print('> TestWireMiddleware -> onData: key = ${key} | $prevValue | $nextValue');
  }

  @override
  void onRemove(String signal, [Object scope, listener]) {
    print('> TestWireMiddleware -> onRemove: signal = ${signal} | $scope | $listener');
  }

  @override
  void onSend(String signal, [data]) {
    print('> TestWireMiddleware -> onRemove: signal = ${signal} | $data');
  }
}
