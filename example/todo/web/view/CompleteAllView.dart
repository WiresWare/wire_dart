import 'dart:html';

import 'package:wire/wire.dart';

import '../const/TodoDataParams.dart';
import '../const/TodoViewSignal.dart';
import 'base/DomElementView.dart';

class CompleteAllView extends DomElement {
  CompleteAllView(CheckboxInputElement dom):super(dom) {
    dom.onChange.listen((e) =>
      Wire.send(TodoViewSignal.COMPLETE_ALL, dom.checked));
  }
}

