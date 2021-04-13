import 'dart:html';
import 'package:wire/wire.dart';

import '../../const/CounterDataKeys.dart';

import '../base/dom_element.dart';

class CounterDisplay extends DomElement {
  CounterDisplay() : super(DivElement()) {
    dom.className = 'spectrum-Body spectrum-Body--L';

    final wireData = Wire.data(CounterDataKeys.COUNT);
    wireData.subscribe(update);
    update(wireData.value ?? 0);
  }

  void update(value) {
    dom.text = value.toString();
  }
}
