import 'dart:async';

import 'package:wire/wire.dart';
import 'dart:html';

import 'controller/TodoController.dart';
import 'model/TodoModel.dart';
import 'view/TodoInputView.dart';
import 'view/TodoListView.dart';

var todoModel;
var todoProcessor;
var todoApplication;

main() {
  /// COUNTER EXAMPLE ======================================
//  Wire.data(CounterParams.COUNT, 0);
//  print('Init Ready: initial value = ' + Wire.data(CounterParams.COUNT).value.toString());
  init();
}

void init() {
  todoModel = TodoModel();
  todoProcessor = TodoController(todoModel);
  todoApplication = TodoApplication();
}

class TodoApplication {
  TodoApplication()
  {
    try {
        TodoInputView(document.querySelector('.new-todo'));
        TodoListView(document.querySelector('.todo-list'));
    } catch(e) {
      print(e);
    }
  }
}
