import 'dart:html';
import 'package:wire/wire.dart';
import '../const/TodoDataParams.dart';
import 'base/DomElementView.dart';
import 'TodoListItemView.dart';

class TodoListView extends DomElement {
  TodoListView(UListElement dom):super(dom) {
    var wireData = Wire.data(TodoDataParams.LIST);
    var list = (wireData.value as List);
    var append = (id) => dom.append(TodoListItemView(id).dom);
    if (list != null && list.isNotEmpty) list.forEach(append);

    wireData.subscribe(this, (value) {
      var list = value as List;
      print('> TodoListView ${list}');
      if (list != null && list.isNotEmpty) {
        append(list.last);
      }
    });
  }
}

