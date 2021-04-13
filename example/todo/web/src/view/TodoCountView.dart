import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/DataKeys.dart';

import 'base/DomElementView.dart';

class TodoCountView extends DomElement {
  TodoCountView(Element dom) : super(dom) {
    final wireDataCount = Wire.data<int>(DataKeys.COUNT);
    wireDataCount.subscribe(updateCount);
    updateCount(wireDataCount.value);
  }

  void updateCount<int>(int value) {
    dom.text = value.toString();
  }
}
