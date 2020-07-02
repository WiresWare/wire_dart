import 'package:wire/wire.dart';
import 'package:test/test.dart';

void main() {
  group('1. Subscription tests', () {

    var SUBSCRIPTION_SIGNAL = 'SIGNAL_SUBSCRIPTION';

    var SUBSCRIPTION_SCOPE = Object();

    setUp(() {
      Wire.add(
        SUBSCRIPTION_SCOPE,
        SUBSCRIPTION_SIGNAL,
        (signal, data) => { print('Response on ${signal} with data: ${data}') });
    });

    var SIGNAL_NOT_REGISTERED = 'SIGNAL_NOT_REGISTERED';

    test('1.1 Unregistered Signal - Test', () {
      expect(
        Wire.send(
          SUBSCRIPTION_SIGNAL,
          SIGNAL_NOT_REGISTERED
      ), isFalse);
    });
  });

  group('2. Purge tests', () {

    var SUBSCRIPTION_SIGNAL = 'SIGNAL_SUBSCRIPTION';
    var SUBSCRIPTION_SCOPE = Object();

    setUp(() {
      Wire.add(
          SUBSCRIPTION_SCOPE,
          SUBSCRIPTION_SIGNAL,
              (signal, data) => { print('Response on ${signal} with data: ${data}') });
    });

    var SIGNAL_NOT_REGISTERED = 'SIGNAL_NOT_REGISTERED';

    test('2.1 Purge', () {
      expect(
          Wire.send(
              SUBSCRIPTION_SIGNAL,
              SIGNAL_NOT_REGISTERED
          ), isFalse);
    });
  });
}
