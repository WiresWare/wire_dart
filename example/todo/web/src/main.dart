import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/controller/route_controller.dart';
import 'package:wire_example_shared/todo/controller/todo_controller.dart';
import 'package:wire_example_shared/todo/middleware/todo_middleware.dart';
import 'package:wire_example_shared/todo/model/todo_model.dart';
import 'package:wire_example_shared/todo/service/web_database_service.dart';
import 'package:wire_example_shared/todo/view/web/clear_completed_view.dart';
import 'package:wire_example_shared/todo/view/web/complete_all_view.dart';
import 'package:wire_example_shared/todo/view/web/todo_count_view.dart';
import 'package:wire_example_shared/todo/view/web/todo_filter_view.dart';
import 'package:wire_example_shared/todo/view/web/todo_input_view.dart';
import 'package:wire_example_shared/todo/view/web/todo_list_view.dart';

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
    final domTodoCount = document.querySelector('.todo-count')!.firstChild!;
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
