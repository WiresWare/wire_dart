import 'dart:async';
import 'dart:html';

import 'package:wire/wire.dart';

import '../const/TodoViewSignal.dart';
import '../model/vos/TodoVO.dart';
import 'base/DomElementView.dart';

class TodoItemView extends DomElement {

  StreamSubscription _inpToggleListener;
  StreamSubscription _btnDeleteListener;

  TodoItemView(String id):super(LIElement()) {

    final container = DivElement()
      ..className = 'view';

    final inpToggle = InputElement()
      ..className = 'toggle'
      ..type = 'checkbox';

    final lblContent = LabelElement()
      ..className = 'todo-content';

    final btnDelete = ButtonElement()
      ..className = 'destroy';

    var data = Wire.data(id);
    var value = data.value as TodoVO;

    var update = (TodoVO value) {
      if (value != null) {
        dom.id = value.id;
        lblContent.text = value.text;
        inpToggle.checked = value.completed;
        lblContent.style.textDecoration = value.completed ? 'line-through' : '';
      } else {
        Wire.data(dom.id).unsubscribe(this);
        _inpToggleListener.cancel();
        _btnDeleteListener.cancel();
        dom.remove();
      }
    };

    update(value);

    _inpToggleListener = inpToggle.onClick.listen((e) => Wire.send(TodoViewSignal.TOGGLE));
    _btnDeleteListener = btnDelete.onClick.listen((e) => Wire.send(TodoViewSignal.DELETE, id));

    data.subscribe(this, update);

    container.append(inpToggle);
    container.append(lblContent);
    container.append(btnDelete);

    dom.append(container);
  }
}

