import 'dart:html';

import 'package:wire/wire.dart';

import 'base/dom_element.dart';

class CounterButton extends DomElement {
  CounterButton(String title, String signal):super(ButtonElement()) {
    dom
      ..text = title
      ..onClick.listen((event) => Wire.send(signal));
  }
}