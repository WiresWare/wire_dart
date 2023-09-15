import 'package:wire/wire.dart';

import '../const/counter_data_keys.dart';
import '../const/counter_signals_keys.dart';

class CounterController {
  CounterController() {
    Wire.add(this, CounterSignalsKeys.DECREASE, (dynamic payload, wireId) async {
      print('> Processor: DECREASE: wireId = ${wireId}; payload = $payload');
      final count = Wire.data(CounterDataKeys.COUNT).value as int?;
      final nextCount = (count ?? 0) > 0 ? (count! - 1) : 0;
      Wire.data(CounterDataKeys.COUNT, value: nextCount);
    });

    Wire.add(this, CounterSignalsKeys.INCREASE, (dynamic payload, wireId) async {
      print('> Processor: INCREASE: wireId = ${wireId}; payload = $payload');
      Wire.data(CounterDataKeys.COUNT, value: (value) {
        final count = value as int?;
        return (count ?? 0) + 1;
      });
    });

    print('CounterController Ready');
  }
}
