import 'dart:html';

import 'package:wire/wire.dart';

import '../const/counter_params.dart';
import 'base/dom_element.dart';

class CounterDisplay extends DomElement {
  CounterDisplay():super(DivElement()) {
    var wireData = Wire.data(CounterParams.COUNT);
    dom
      ..text = wireData.value.toString()
      ..className = 'spectrum-Body spectrum-Body--L';

    wireData.subscribe(this, (value) => {
      dom.text = value.toString()
    });
  }
}

