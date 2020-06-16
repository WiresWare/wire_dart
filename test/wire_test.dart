import 'package:wire/wire.dart';
import 'package:test/test.dart';

void main() {
  group('1. Subscription tests', () {

    var SIGNAL_SUBSCRIPTION = 'SIGNAL_SUBSCRIPTION';

    var SCOPE_SUBSCRIPTION = Object();

    setUp(() {
      Wire.add(
        SCOPE_SUBSCRIPTION,
        SIGNAL_SUBSCRIPTION,
        (signal, data) => { print('Response on ${signal} with data: ${data}') });
    });

    var SIGNAL_NOT_REGISTERED = 'SIGNAL_NOT_REGISTERED';

    test('1.1 Unregistered Signal - Test', () {
      expect(
        Wire.send(
          SIGNAL_SUBSCRIPTION,
          SIGNAL_NOT_REGISTERED
      ), isFalse);
    });
  });
}
