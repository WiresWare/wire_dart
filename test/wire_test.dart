import 'package:wire/wire.dart';
import 'package:test/test.dart';

class TestMiddleware extends WireMiddleware {
  @override
  void onAdd(Wire wire) {
  }

  @override
  void onData(String param, prevValue, nextValue) {
  }

  @override
  void onRemove(String signal, [Object scope, listener]) {
  }

  @override
  void onSend(String signal, [data]) {
  }
}

void main() {
  group('1. Subscription tests', () {

    var SIGNAL = 'SIGNAL_SUBSCRIPTION';
    var SCOPE = Object();

    WireListener listener = (signal, data) =>
      { print('Response on ${signal} with data: ${data}') };

    var testWire = Wire(SCOPE, 'wire_signal_1', listener);

    setUp(() {
      Wire.purge(withMiddleware: true);
      Wire.add(SCOPE, SIGNAL, listener);
      Wire.attach(testWire);
    });

    var SIGNAL_NOT_REGISTERED = 'SIGNAL_NOT_REGISTERED';

    test('1.0 Registered Signal', () {
      expect(Wire.send(SIGNAL), isFalse);
      expect(Wire.send(testWire.signal), isFalse);
    });

    test('1.1 Has Signal', () {
      expect(Wire.has(signal:SIGNAL), isTrue);
      expect(Wire.has(signal:SIGNAL_NOT_REGISTERED), isFalse);
      expect(Wire.has(signal:'NOT_A_SIGNAL'), isFalse);
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
  });

  group('2. Purge and remove tests', () {

    var SIGNAL = 'SIGNAL_SUBSCRIPTION';
    var SIGNAL_2 = 'SIGNAL_SUBSCRIPTION_2';
    var SCOPE = Object();

    WireListener listener = (signal, data) =>
      { print('Response on ${signal} with data: ${data}') };

    var testWire = Wire(SCOPE, 'wire_signal_2', listener);

    var testMiddleware = TestMiddleware();

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
}
