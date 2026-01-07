import 'dart:math';

import 'package:wire/wire.dart';
import 'package:wire_example_counter/const/counter_data_keys.dart';
import 'package:wire_example_counter/const/counter_signals_keys.dart';

class CounterController {
  CounterController() {
    Wire.add(this, CounterSignalsKeys.DECREASE, (_, wid) async {
      // print('> Processor: DECREASE: wireId = ${wireId}; payload = $payload');
      final count = Wire.data<int>(CounterDataKeys.COUNT).value;
      final nextCount = (count ?? 0) > 0 ? (count! - 1) : 0;
      Wire.data(CounterDataKeys.COUNT, value: nextCount);
    });

    Wire.add(this, CounterSignalsKeys.INCREASE, (_, wid) async {
      // print('> Processor: INCREASE: wireId = ${wireId}; payload = $payload');
      if (Random().nextDouble() > 0.8) throw Exception('Increase failed');
      Wire.data<int>(
        CounterDataKeys.COUNT,
        value: (int? value) {
          return (value ?? 0) + 1;
        },
      );
    });

    print('CounterController Ready');
  }
}
