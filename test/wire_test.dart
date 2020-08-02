import 'package:wire/wire.dart';
import 'package:test/test.dart';

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

void main() {
  group('1. Subscription tests', () {

    const SIGNAL = 'SIGNAL_SUBSCRIPTION';
    const SIGNAL_COUNTER = 'SIGNAL_COUNTER';
    const SCOPE = Object();

    WireListener<String> listener_string = (String data, wid) =>
    { print('> Response on ${Wire.get(wid:wid).single.signal} with STRING data: ${data}') };

    WireListener<bool> listener_boolean = (bool data, wid) =>
    { print('> Response on ${Wire.get(wid:wid).single.signal} with BOOLEAN data: ${data}') };

    var testWire = Wire<String>(SCOPE, 'wire_signal_1', listener_string);

    setUp(() {
      Wire.purge(withMiddleware: true);
      Wire.add<String>(SCOPE, SIGNAL, listener_string);
      Wire.add<bool>(SCOPE, SIGNAL, listener_boolean);
      Wire.attach(testWire);
    });

    var SIGNAL_NOT_REGISTERED = 'SIGNAL_NOT_REGISTERED';

    test('1.0 Registered Signal', () {
      expect(Wire.send(SIGNAL), isFalse);
      expect(Wire.send(SIGNAL, 'STRING_DATA'), isFalse);
      expect(Wire.send(SIGNAL, false), isFalse);
      expect(Wire.send(testWire.signal), isFalse);
    });

    test('1.1 Has Signal', () {
      expect(Wire.has(signal:SIGNAL), isTrue);
      expect(Wire.has(signal:SIGNAL_NOT_REGISTERED), isFalse);
      expect(Wire.has(signal:'RANDOM_SIGNAL'), isFalse);
      expect(Wire.has(wire:testWire), isTrue);
    });

    test('1.2 Unregistered Signal', () {
      expect(Wire.send(SIGNAL_NOT_REGISTERED), isTrue);
      expect(Wire.send('RANDOM'), isTrue);
    });

    test('1.3 Detach Signal', () {
      expect(Wire.detach(testWire), isTrue);
      expect(Wire.send(testWire.signal), isTrue);
    });

    test('1.4 Counter Signal', () {
      Wire.add(SCOPE, SIGNAL_COUNTER, (_, wid) {
        var wire = Wire.get(wid:wid).single;
        print('1.4 Response on ${wire.signal} replies left: ${wire.replies}');
      }, replies: 2);
      expect(Wire.send(SIGNAL_COUNTER), isFalse);
      expect(Wire.send(SIGNAL_COUNTER), isTrue);
    });
  });

  group('2. Purge and remove tests', () {

    var SIGNAL = 'SIGNAL_SUBSCRIPTION';
    var SIGNAL_2 = 'SIGNAL_SUBSCRIPTION_2';
    var SCOPE = Object();

    WireListener listener = (data, wid) {
      var wire = Wire.get(wid:wid).single;
      print('Response on ${wire.signal} with data: ${data}');
    };

    var testWire = Wire(SCOPE, 'wire_signal_2', listener);

    var testMiddleware = TestWireMiddleware();

    setUp(() {
      Wire.purge(withMiddleware: true);
      Wire.add(SCOPE, SIGNAL, listener);
      Wire.add(SCOPE, SIGNAL_2, listener);
      Wire.attach(testWire);
      Wire.middleware(testMiddleware);
    });

    test('2.1 Purge', () {
      Wire.purge(withMiddleware: true);
      expect(Wire.send(SIGNAL), isTrue);

      expect(Wire.has(wire: testWire), isFalse);
      expect(Wire.has(signal: SIGNAL), isFalse);

      expect(Wire.get(signal: SIGNAL), isEmpty);
      expect(Wire.get(signal: SIGNAL_2), isEmpty);
      expect(Wire.get(signal: testWire.signal), isEmpty);
      expect(Wire.get(scope: SCOPE), isEmpty);
      expect(Wire.get(listener: listener), isEmpty);
    });

    test('2.2 Remove', () {
      Wire.add(SCOPE, SIGNAL, listener);
      Wire.add(SCOPE, SIGNAL, (wire, data) => {});
      Wire.remove(SIGNAL);
      expect(Wire.has(signal:SIGNAL), isFalse);
      expect(Wire.get(signal:SIGNAL), isEmpty);
    });
  });

  group('3. Data Layer', () {

  });
}
