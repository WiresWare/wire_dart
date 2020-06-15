import 'package:wire/wire.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {

    var SIGNAL_SUBSCRIPTION = 'SIGNAL_subscription';
    var SCOPE = Object();

    setUp(() {
      Wire.add(SCOPE, SIGNAL_SUBSCRIPTION, (params) => { print('SUBSCRIBED with params: ${params}') });
    });

    test('First Test', () {
      expect(Wire.send(SIGNAL_SUBSCRIPTION, 'signal'), isFalse);
    });
  });
}
