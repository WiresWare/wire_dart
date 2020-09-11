import 'package:wire/wire.dart';

import 'const/CounterParams.dart';
import 'const/CounterSignals.dart';

class CounterProcessor {
  CounterProcessor() {
    Wire.add(this, CounterSignal.INCREASE, (payload, wireId) {
      print('> Processor: INCREASE -> handle: ' + payload.toString());
      Wire.data(CounterDataKeys.COUNT, (value) => (value ?? 0) + 1);
    });

    Wire.add(this, CounterSignal.DECREASE, (payload, wireId) {
      print('> Processor: DECREASE -> handle: ' + payload.toString());
      Wire.data(CounterDataKeys.COUNT, (int value) => (value ?? 0) > 0 ? value - 1 : 0);
    });

    print('Processor Ready');
  }
}
