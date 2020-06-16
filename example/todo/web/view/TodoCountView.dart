import 'dart:html';

import 'package:wire/wire.dart';

import '../const/TodoDataParams.dart';
import 'base/DomElementView.dart';

class TodoCountView extends DomElement {
  TodoCountView(SpanElement dom):super(dom) {
    var wireData = Wire.data(TodoDataParams.COUNT);
    var update = (value) => dom.firstChild.text = value.toString();
    wireData.subscribe(this, update);
    update(wireData.value);
  }
}

