import 'dart:html';

import 'package:wire/wire.dart';

import '../const/TodoDataParams.dart';

import 'base/DomElementView.dart';
import 'TodoItemView.dart';

class TodoListView extends DomElement {
  TodoListView(UListElement dom):super(dom) {
    var data = Wire.data(TodoDataParams.LIST);
    var list = (data.value as List);
    list.forEach((id) => dom.append(TodoItemView(id).dom));
    data.subscribe(this, (List list) {
      if (list != null) {
        dom.append(TodoItemView(list.last).dom);
      }
    });
  }
}

