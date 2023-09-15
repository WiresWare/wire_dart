import 'dart:html';

import 'package:wire/wire.dart';

import 'const/counter_data_keys.dart';
import 'const/counter_signals_keys.dart';
import 'controller/counter_controller.dart';
import 'view/components/counter_button.dart';
import 'view/components/counter_display.dart';

void main() {
  /// COUNTER EXAMPLE ======================================

  /// Create model that defines data sources and initial values
  // CounterModel();

  /// Create controller that register all signal processing
  CounterController();

  final rootDom = document.querySelector('#root');
  ApplicationView(rootDom as DivElement?);

  print('Init Ready: initial value = '
      '${Wire.data(CounterDataKeys.COUNT).value}');
}

class ApplicationView {
  ApplicationView(this.root) {
    try {
      final group = DivElement()..className = 'spectrum-ButtonGroup';

      final btnIncrease = CounterButton('Increase', CounterSignalsKeys.INCREASE);
      final btnDecrease = CounterButton('Decrease', CounterSignalsKeys.DECREASE);

      final counterDisplay = CounterDisplay();

      group.append(btnIncrease.dom);
      group.append(btnDecrease.dom);

      root!.append(counterDisplay.dom);
      root!.append(group);
    } catch (e) {
      print(e);
    }
  }

  final DivElement? root;
}
