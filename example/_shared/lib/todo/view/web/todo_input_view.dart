import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/view_signals.dart';
import 'package:wire_example_shared/todo/data/dto/input_dto.dart';
import 'package:wire_example_shared/todo/view/web/base/dom_element_view.dart';

class TodoInputView extends DomElement {
  TodoInputView(InputElement dom) : super(dom) {
    Wire.add(this, ViewSignals.CLEAR_INPUT, _clearInput);

    dom
      ..text = ''
      ..onKeyPress.listen((e) async {
        if (e.keyCode == KeyCode.ENTER) {
          _onInputEnter();
        }
      });
  }

  InputElement get input => dom as InputElement;

  Future<void> _clearInput(data, wid) async {
    input.value = '';
  }

  void _onInputEnter() {
    final dto = InputDTO(input.value!, '');
    Wire.send(ViewSignals.INPUT, payload: dto);
  }
}
