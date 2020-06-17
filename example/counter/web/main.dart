import 'package:wire/wire.dart';
import 'dart:html';

import 'CounterProcessor.dart';
import 'components/counter_button.dart';
import 'components/counter_display.dart';
import 'const/counter_params.dart';
import 'const/counter_signals.dart';

var processor;
var application;

main() {
  /// COUNTER EXAMPLE ======================================
  Wire.data(CounterParams.COUNT, 0);
  print('Init Ready: initial value = ' + Wire.data(CounterParams.COUNT).value.toString());
  init();
}

void init() {
  processor = CounterProcessor();
  application = Application(document.querySelector('#root'));
}

class Application {
  DivElement root;
  Application(this.root)
  {
    try {

      var group = DivElement()..className = 'spectrum-ButtonGroup';
      group.append(CounterButton('Increase', CounterSignal.INCREASE).dom);
      group.append(CounterButton('Decrease', CounterSignal.DECREASE).dom);

      root.append(CounterDisplay().dom);
      root.append(group);

    } catch(e) {
      print(e);
    }
  }
}
