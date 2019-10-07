import 'package:wire/wire.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {

    String SIGNAL_SUBSCRIPTION = "SIGNAL_subscription";

    setUp(() {
      Wire.add(SIGNAL_SUBSCRIPTION, (params) => { print("SUBSCRIBED with params: ${params}") });
    });

    test('First Test', () {
      expect(Wire.send(SIGNAL_SUBSCRIPTION, "signal"), isFalse);
    });
  });
}
