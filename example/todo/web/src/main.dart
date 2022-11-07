import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/controller/route_controller.dart';
import 'package:wire_example_shared/todo/controller/todo_controller.dart';
import 'package:wire_example_shared/todo/middleware/todo_middleware.dart';
import 'package:wire_example_shared/todo/model/todo_model.dart';
import 'package:wire_example_shared/todo/service/web_database_service.dart';
import 'package:wire_example_todo/view.dart';

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
    ErrorView();
  }
  document.querySelector('#loading')?.remove();
}
