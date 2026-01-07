import 'dart:js_interop';

import 'package:web/web.dart';

import 'package:wire_example_shared/todo/view/web/clear_completed_view.dart';
import 'package:wire_example_shared/todo/view/web/complete_all_view.dart';
import 'package:wire_example_shared/todo/view/web/todo_count_view.dart';
import 'package:wire_example_shared/todo/view/web/todo_filter_view.dart';
import 'package:wire_example_shared/todo/view/web/todo_input_view.dart';
import 'package:wire_example_shared/todo/view/web/todo_list_view.dart';

class TodoView {
  TodoView() {
    final domNewTodoInput = document.querySelector('.new-todo')!;
    final domTodoList = document.querySelector('.todo-list')!;
    final domTodoCount = document.querySelector('.todo-count')!.firstChild!;
    final domFiltersList = document.querySelector('.filters')!;
    final domToggleAll = document.querySelector('.toggle-all')!;
    final domClearCompleted = document.querySelector('.clear-completed')!;

    TodoInputView(domNewTodoInput as HTMLInputElement);
    TodoListView(domTodoList as HTMLUListElement);
    TodoCountView(domTodoCount as HTMLElement);
    TodoFilterView(domFiltersList as HTMLUListElement);
    CompleteAllView(domToggleAll as HTMLInputElement);
    ClearCompletedView(domClearCompleted as HTMLButtonElement);
  }
}

class ErrorView {
  ErrorView() {
    final app = document.querySelector('#todoapp') as HTMLElement?;
    if (app == null) return;
    app
      ..innerHTML = '<h2>Error during model initialization</h2>'.toJS
      ..style.textAlign = 'center'
      ..style.padding = '2rem 0';
  }
}
