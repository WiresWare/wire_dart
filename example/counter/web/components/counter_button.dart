import 'dart:html';

import 'package:wire/wire.dart';

import 'base/dom_element.dart';

class CounterButton extends DomElement {
  CounterButton(String title, String signal):super(ButtonElement()) {
    dom
      ..text = title
      ..title = title
      ..setAttribute('is', 'coral-button')
      ..setAttribute('variant', 'default')
      ..setAttribute('size', 'M')
//      ..className = '_coral-Button _coral-Button--primary'
      ..onClick.listen((event) => Wire.send(signal));
  }
}