import 'package:wire/wire.dart';

import '../const/TodoViewSignal.dart';
import '../model/ITodoModel.dart';

class TodoController {
  TodoController(ITodoModel todoModel) {

    Wire.add(this, TodoViewSignal.INPUT, (String text) {
      print('> TodoProcessor -> TodoViewOutputSignal.INPUT: ' + text);
      if (text != null && text.isNotEmpty) {
        todoModel.create(text);
        Wire.send(TodoViewSignal.CLEAR);
      }
    });

    Wire.add(this, TodoViewSignal.DELETE, (String id) {
      print('> TodoProcessor -> TodoViewOutputSignal.DELETE: ' + id);
      todoModel.remove(id);
    });

    print('Processor Ready');
  }
}