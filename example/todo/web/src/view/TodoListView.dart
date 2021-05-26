import 'dart:html';
import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/DataKeys.dart';
import 'base/DomElementView.dart';
import 'TodoListItemView.dart';

class TodoListView extends DomElement {
  TodoListView(UListElement dom) : super(dom) {
    var wireDataTodoList = Wire.data(DataKeys.LIST_OF_IDS);
    var todoList = (wireDataTodoList.value as List);
    var append = (id) async {
      print('> TodoListView -> append id = ${id}');
      dom.insertBefore(TodoListItemView(id).dom, dom.firstChild);
    };
    if (todoList.isNotEmpty) todoList.forEach(append);

    wireDataTodoList.subscribe((value) async {
      var list = value as List;
      print('> TodoListView -> wireDataTodoList.subscribe: ${list}');
      if (list.isNotEmpty) append(list.last);
    });
  }
}
