import 'package:wire/wire.dart';

import '../const/TodoFilterValues.dart';
import '../const/TodoViewSignal.dart';
import '../model/ITodoModel.dart';
import '../model/dto/EditDTO.dart';

class TodoController {
  ITodoModel todoModel;
  TodoController(this.todoModel) {

    /*
    Wire.add(this, TodoViewSignal.INPUT, (data) {s
      var text = data as String;
      print('> TodoProcessor -> TodoViewOutputSignal.INPUT: ' + text);
      if (text != null && text.isNotEmpty) {
        todoModel.create(text);
        Wire.send(TodoViewSignal.CLEAR);
      }
    });

    Wire.add(this, TodoViewSignal.DELETE, (data) {
      var todoId = data as String;
      print('> TodoProcessor -> TodoViewOutputSignal.DELETE: ' + todoId);
      todoModel.remove(todoId);
    });
    * */

    Wire.add(this, TodoViewSignal.INPUT,  _SignalProcessor);
    Wire.add(this, TodoViewSignal.EDIT,   _SignalProcessor);
    Wire.add(this, TodoViewSignal.DELETE, _SignalProcessor);
    Wire.add(this, TodoViewSignal.TOGGLE, _SignalProcessor);
    Wire.add(this, TodoViewSignal.FILTER, _SignalProcessor);
    Wire.add(this, TodoViewSignal.CLEAR_COMPLETED, _SignalProcessor);

    print('Processor Ready');
  }

  void _SignalProcessor(String signal, dynamic data) {
    print('> TodoProcessor -> ${signal}: data = ' + data.toString());
    switch (signal) {
      case TodoViewSignal.INPUT:
        var text = data as String;
        if (text != null && text.isNotEmpty) {
          todoModel.create(text);
          Wire.send(TodoViewSignal.CLEAR_INPUT);
        }
        break;
      case TodoViewSignal.EDIT:
        var editTodoDTO = data as EditDTO;
        var todoText = editTodoDTO.text;
        var todoId = editTodoDTO.id;
        if (todoText.isEmpty) {
          todoModel.remove(todoId);
        } else {
          todoModel.update(todoId, todoText);
        }
        break;
      case TodoViewSignal.TOGGLE:
        var todoId = data as String;
        todoModel.toggle(todoId);
        break;
      case TodoViewSignal.DELETE:
        var todoId = data as String;
        todoModel.remove(todoId);
        break;
      case TodoViewSignal.FILTER:
        var filter = data as TodoFilterValue;
        todoModel.filter(filter);
        break;
      case TodoViewSignal.CLEAR_COMPLETED:
        todoModel.clearCompleted();
        break;
    }
  }
}