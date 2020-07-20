import 'dart:html';

import 'package:wire/wire.dart';

import '../const/CounterParams.dart';
import 'base/dom_element.dart';

class CounterDisplay extends DomElement {
  CounterDisplay():super(DivElement()) {
    var wireData = Wire.data(CounterDataKeys.COUNT);
    dom
      ..text = wireData.value.toString()
      ..className = 'spectrum-Body spectrum-Body--L';

    wireData.subscribe((value) => {
      dom.text = value.toString()
    });
  }
}

