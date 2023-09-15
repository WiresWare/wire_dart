import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_example_counter/mvc/view/base/dom_element.dart';

class CounterButton extends DomElement {
  CounterButton(String title, String signal) : super(ButtonElement()) {
    final span = SpanElement()
      ..text = title
      ..title = title
      ..className = 'spectrum-Button-label';
    dom
      ..className = 'spectrum-Button spectrum-Button--primary'
      ..onClick.listen((event) => Wire.send(signal))
      ..append(span);
  }
}
