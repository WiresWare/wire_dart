import 'dart:html';
import 'package:wire/wire.dart';

import 'controller/RouteController.dart';
import 'controller/TodoController.dart';
import 'model/TodoModel.dart';
import 'service/WebDatabaseService.dart';
import 'view/ClearCompletedView.dart';
import 'view/CompleteAllView.dart';
import 'view/TodoCountView.dart';
import 'view/TodoFilterView.dart';
import 'view/TodoInputView.dart';
import 'view/TodoListView.dart';
import 'middleware/TodoMiddleware.dart';

var todoModel;
var todoView;
var todoController;
var routeController;

main() {
  /// COUNTER EXAMPLE ======================================
  init();
  ready();
}

void init() {
  Wire.middleware(TodoMiddleware());
  var databaseService = WebDatabaseService();
  todoModel = TodoModel(databaseService);
  todoView = TodoView();
  todoController = TodoController(todoModel);
  routeController = RouteController();
}

void ready() {
  document.querySelector('#loading').remove();
}

class TodoView {
  TodoView()
  {
    TodoInputView(document.querySelector('.new-todo'));
    TodoListView(document.querySelector('.todo-list'));
    TodoCountView(document.querySelector('.todo-count'));
    TodoFilterView(document.querySelector('.filters'));
    CompleteAllView(document.querySelector('.toggle-all'));
    ClearCompletedView(document.querySelector('.clear-completed'));
  }
}
