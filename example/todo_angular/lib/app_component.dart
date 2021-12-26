import 'package:angular/angular.dart';
import 'package:wire_example_angular_todo/src/todo_input/todo_input_component.dart';
import 'package:wire_example_shared/todo/controller/TodoController.dart';
import 'package:wire_example_shared/todo/model/TodoModel.dart';
import 'package:wire_example_shared/todo/service/WebDatabaseService.dart';

import 'src/todo_list/todo_list_component.dart';

// AngularDart info: https://angulardart.dev
// Components info: https://angulardart.dev/components

@Component(
  selector: 'my-app',
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: [TodoListComponent, TodoInputComponent],
)
class AppComponent {
  // Nothing here yet. All logic is in TodoListComponent.
  AppComponent() {
    final whenReady = Future(() async {
      final databaseService = WebDatabaseService();
      final todoModel = TodoModel(databaseService);
      if (await todoModel.whenReady) {
        print('> Main -> main: todoModel.whenReady');
        TodoController(todoModel);
      }
    });
  }
}
