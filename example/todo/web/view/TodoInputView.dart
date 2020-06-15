import 'dart:html';

import 'package:wire/wire.dart';

import '../const/TodoViewSignal.dart';

import 'base/DomElementView.dart';

class TodoInputView extends DomElement {
  TodoInputView(InputElement dom):super(dom) {
    Wire.add(this, TodoViewSignal.CLEAR, (_) => dom.value = '');
    dom
      ..text = ''
      ..onKeyPress.listen((e) =>
        e.keyCode == KeyCode.ENTER &&
          Wire.send(TodoViewSignal.INPUT, dom.value));
  }
}

