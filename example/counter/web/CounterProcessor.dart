import 'package:wire/wire.dart';

import 'const/CounterParams.dart';
import 'const/CounterSignals.dart';

class CounterProcessor {
  CounterProcessor() {
    Wire.add(this, CounterSignal.INCREASE, (data, wid) {
      print('> Processor: INCREASE -> handle: ' + data.toString());
      Wire.data(CounterDataKeys.COUNT, (value) => value + 1 );
    });

    Wire.add(this, CounterSignal.DECREASE, (data, wid) {
      print('> Processor: DECREASE -> handle: ' + data.toString());
      Wire.data(CounterDataKeys.COUNT, (value) => value > 0 ? value - 1 : 0);
    });

    print('Processor Ready');
  }
}
