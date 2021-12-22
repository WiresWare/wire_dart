import 'package:wire/wire.dart';

import '../const/CounterDataKeys.dart';
import '../const/CounterSignalsKeys.dart';

class CounterController {
  CounterController() {
    Wire.add(this, CounterSignalsKeys.INCREASE, (dynamic payload, wireId) async {
      print('> Processor: INCREASE -> handle: ' + payload.toString());
      Wire.data(CounterDataKeys.COUNT, value: (value) => (value ?? 0) + 1);
    });

    Wire.add(this, CounterSignalsKeys.DECREASE, (dynamic payload, wireId) async {
      print('> Processor: DECREASE -> handle: ' + payload.toString());
      Wire.data(CounterDataKeys.COUNT, value: (int value) => value > 0 ? value - 1 : 0);
    });

    print('CounterController Ready');
  }
}
