import 'package:wire/wire.dart';
import 'dart:html';

import 'middleware/CounterStorageMiddleware.dart';
import 'CounterProcessor.dart';
import 'components/CounterButton.dart';
import 'components/CounterDisplay.dart';
import 'const/CounterParams.dart';
import 'const/CounterSignals.dart';

var processor;
var application;

main() {
  /// COUNTER EXAMPLE ======================================
  final counterStorageMiddleware = CounterStorageMiddleware();
  final initialValue = counterStorageMiddleware.getInitialValue();
  Wire.data(CounterDataKeys.COUNT, initialValue);
  Wire.middleware(counterStorageMiddleware);
  print('Init Ready: initial value = ${Wire.data(CounterDataKeys.COUNT).value}');
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
