import 'package:wire/wire.dart';
import 'dart:html';

import 'const/CounterDataKeys.dart';
import 'const/CounterSignalsKeys.dart';

import 'model/middleware/CounterStorageMiddleware.dart';
import 'controller/CounterController.dart';
import 'view/components/CounterButton.dart';
import 'view/components/CounterDisplay.dart';

var processor;
var application;

void main() {
  /// COUNTER EXAMPLE ======================================
  final counterStorageMiddleware = CounterStorageMiddleware();

  // Set initial value from local storage
  Wire.data(CounterDataKeys.COUNT,
      value: counterStorageMiddleware.getInitialValue());
  // Register middleware after setting initial value to prevent saving initial value
  Wire.middleware(counterStorageMiddleware);

  print(
      'Init Ready: initial value = ${Wire.data(CounterDataKeys.COUNT).value}');

  init();
}

void init() {
  final root = document.querySelector('#root');

  processor = CounterController();
  application = ApplicationView(root as DivElement?);
}

class ApplicationView {
  DivElement? root;
  ApplicationView(this.root) {
    try {
      var group = DivElement()..className = 'spectrum-ButtonGroup';
      group.append(CounterButton('Increase', CounterSignalsKeys.INCREASE).dom);
      group.append(CounterButton('Decrease', CounterSignalsKeys.DECREASE).dom);

      root!.append(CounterDisplay().dom);
      root!.append(group);
    } catch (e) {
      print(e);
    }
  }
}
