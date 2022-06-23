import 'dart:html';

import 'package:wire/wire.dart';

import 'const/counter_data_keys.dart';
import 'const/counter_signals_keys.dart';
import 'controller/counter_controller.dart';
import 'model/middleware/counter_storage_middleware.dart';
import 'view/components/counter_button.dart';
import 'view/components/counter_display.dart';

late CounterController processor;
late ApplicationView application;

void main() {
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

  processor = CounterController();
  application = ApplicationView(root as DivElement?);
}

class ApplicationView {
  ApplicationView(this.root) {
    try {
      final group = DivElement()..className = 'spectrum-ButtonGroup';
      group.append(CounterButton('Increase', CounterSignalsKeys.INCREASE).dom);
      group.append(CounterButton('Decrease', CounterSignalsKeys.DECREASE).dom);

      root!.append(CounterDisplay().dom);
      root!.append(group);
    } catch (e) {
      print(e);
    }
  }

  final DivElement? root;
}
