import 'package:wire/wire.dart';
import 'dart:html';

import 'components/counter_button.dart';
import 'components/counter_display.dart';
import 'const/counter_params.dart';
import 'const/counter_signals.dart';

var processor;
var application;

main() {
  /// COUNTER EXAMPLE ======================================
  processor = Processor();
  application = Application(document.querySelector('#root'));
  Wire.data(CounterParams.COUNT, 0);
  print('Init Ready: initial value = ' + Wire.data(CounterParams.COUNT).value.toString());
}

class Processor {
  Processor() {
    Wire.add(CounterSignal.INCREASE, ([opt]) {
      Wire.data(CounterParams.COUNT, (value) {
        print('> Processor: INCREASE -> handle: ' + value.toString());
        return value + 1;
      });
    });

    Wire.add(CounterSignal.DECREASE, ([opt]) {
      Wire.data(CounterParams.COUNT, (value) {
        print('> Processor: DECREASE -> handle: ' + value.toString());
        return value > 0 ? value - 1 : 0;
      });
    });

    print('Processor Ready');
  }
}

class Application {
  DivElement root;
  Application(this.root)
  {
    try {

      root.append(CounterDisplay().dom);
      root.append(CounterButton('Increase', CounterSignal.INCREASE).dom);
      root.append(CounterButton('Decrease', CounterSignal.DECREASE).dom);

    } catch(e) {
      print(e);
    }
  }
}
