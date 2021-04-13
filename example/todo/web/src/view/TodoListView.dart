import 'dart:html';
import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/DataKeys.dart';
import 'base/DomElementView.dart';
import 'TodoListItemView.dart';

class TodoListView extends DomElement {
  TodoListView(UListElement dom) : super(dom) {
    var wireDataTodoList = Wire.data(DataKeys.LIST_OF_IDS);
    var todoList = (wireDataTodoList.value as List);
    var append = (id) => dom.append(TodoListItemView(id).dom);
    if (todoList.isNotEmpty) todoList.forEach(append);

    wireDataTodoList.subscribe((value) {
      var list = value as List;
      print('> TodoListView ${list}');
      if (list.isNotEmpty) append(list.last);
    });
  }
}
