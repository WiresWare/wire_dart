import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_example_counter/const/counter_data_keys.dart';
import 'package:wire_example_counter/const/counter_signals_keys.dart';
import 'package:wire_example_counter/mvc/controller/counter_controller.dart';
import 'package:wire_example_counter/mvc/view/components/counter_button.dart';
import 'package:wire_example_counter/mvc/view/components/counter_display.dart';

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
