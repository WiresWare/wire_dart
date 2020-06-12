import 'dart:html';

import 'package:wire/wire.dart';

import '../const/counter_params.dart';
import 'base/dom_element.dart';

class CounterDisplay extends DomElement {
  CounterDisplay():super(DivElement()) {
    dom.text = 'EMPTY';
    Wire.data(CounterParams.COUNT).listen((value) => {
      dom.text = value.toString()
    });
  }
}

