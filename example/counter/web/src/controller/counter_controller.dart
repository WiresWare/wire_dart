import 'package:wire/wire.dart';

import '../const/counter_data_keys.dart';
import '../const/counter_signals_keys.dart';

class CounterController {
  CounterController() {
    Wire.add(this, CounterSignalsKeys.INCREASE, (dynamic payload, wireId) async {
      print('> Processor: INCREASE -> handle: wireId = ${wireId.toString()}; payload = $payload');
      Wire.data(CounterDataKeys.COUNT, value: (int? value) => (value ?? 0) + 1);
    });

    Wire.add(this, CounterSignalsKeys.DECREASE, (dynamic payload, wireId) async {
      print('> Processor: DECREASE -> handle: wireId = ${wireId.toString()}; payload = $payload');
      Wire.data(CounterDataKeys.COUNT, value: (int value) => value > 0 ? value - 1 : 0);
    });

    print('CounterController Ready');
  }
}
