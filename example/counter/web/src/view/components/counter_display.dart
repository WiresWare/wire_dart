import 'dart:html';

import 'package:wire/wire.dart';

import '../../const/counter_data_keys.dart';
import '../base/dom_element.dart';

class CounterDisplay extends DomElement {
  CounterDisplay() : super(DivElement()) {
    final wireData = Wire.data(CounterDataKeys.COUNT);
    wireData.subscribe(update);
    update(wireData.value ?? 0);
  }

  Future<void> update(value) async {
    print('> CounterDisplay -> update: ${value}');
    dom.text = value.toString();
  }
}
