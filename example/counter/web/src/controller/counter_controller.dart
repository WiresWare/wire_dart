import 'package:wire/wire.dart';

import '../const/counter_data_keys.dart';
import '../const/counter_signals_keys.dart';

class CounterController {
  CounterController() {
    Wire.add(this, CounterSignalsKeys.INCREASE, (dynamic payload, wireId) async {
      print('> Processor: INCREASE -> handle: wireId = ${wireId}; payload = $payload');
      Wire.data(CounterDataKeys.COUNT, value: (value) {
        final count = value as int?;
        return (count ?? 0) + 1;
      });
    });

    Wire.add(this, CounterSignalsKeys.DECREASE, (dynamic payload, wireId) async {
      print('> Processor: DECREASE -> handle: wireId = ${wireId}; payload = $payload');
      final countWireData = Wire.data(CounterDataKeys.COUNT);
      final count = countWireData.value as int?;
      final nextCount = (count ?? 0) > 0 ? (count! - 1) : 0;
      Wire.data(CounterDataKeys.COUNT, value: nextCount);
    });

    print('CounterController Ready');
  }
}
