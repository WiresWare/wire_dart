import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/controller/RouteController.dart';
import 'package:wire_example_shared/todo/controller/TodoController.dart';
import 'package:wire_example_shared/todo/middleware/TodoMiddleware.dart';
import 'package:wire_example_shared/todo/model/TodoModel.dart';
import 'package:wire_example_shared/todo/service/WebDatabaseService.dart';
import 'package:wire_example_shared/todo/view/web/ClearCompletedView.dart';
import 'package:wire_example_shared/todo/view/web/CompleteAllView.dart';
import 'package:wire_example_shared/todo/view/web/TodoCountView.dart';
import 'package:wire_example_shared/todo/view/web/TodoFilterView.dart';
import 'package:wire_example_shared/todo/view/web/TodoInputView.dart';
import 'package:wire_example_shared/todo/view/web/TodoListView.dart';

var todoModel;
var todoView;
var todoController;
var routeController;

void main() async {
  Wire.middleware(TodoMiddleware());

  final databaseService = WebDatabaseService();
  final todoModel = TodoModel(databaseService);
  if (await todoModel.whenReady) {
    TodoController(todoModel);
    RouteController();
    TodoView();
  } else {
    print('> Main -> main: todoModel.whenReady = false');
    document.querySelector('#todoapp')
      ?..innerHtml = '<h2>Error during model initialization</h2>'
      ..style.textAlign = 'center'
      ..style.padding = '2rem 0';
  }
  document.querySelector('#loading')?.remove();
}

class TodoView {
  TodoView() {
    final domNewTodoInput = document.querySelector('.new-todo')!;
    final domTodoList = document.querySelector('.todo-list')!;
    final domTodoCount = document.querySelector('.todo-count')!.firstChild;
    final domFiltersList = document.querySelector('.filters')!;
    final domToggleAll = document.querySelector('.toggle-all')!;
    final domClearCompleted = document.querySelector('.clear-completed')!;

    TodoInputView(domNewTodoInput as InputElement);
    TodoListView(domTodoList as UListElement);
    TodoCountView(domTodoCount as Element);
    TodoFilterView(domFiltersList as UListElement);
    CompleteAllView(domToggleAll as CheckboxInputElement);
    ClearCompletedView(domClearCompleted as ButtonElement);
  }
}
