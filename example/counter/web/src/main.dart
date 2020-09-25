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

  // Set initial value from local storage
  Wire.data(CounterDataKeys.COUNT, value: counterStorageMiddleware.getInitialValue());
  // Register middleware after setting initial value to prevent saving initial value
  Wire.middleware(counterStorageMiddleware);

  print('Init Ready: initial value = ${Wire.data(CounterDataKeys.COUNT).value}');

  init();
}

void init() {
  final root = document.querySelector('#root');

  processor = CounterProcessor();
  application = ApplicationView(root);
}

class ApplicationView {
  DivElement root;
  ApplicationView(this.root)
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
