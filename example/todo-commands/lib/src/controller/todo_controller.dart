import 'package:wire/wire.dart';

import 'package:wire_example_shared/todo/const/data_keys.dart';
import 'package:wire_example_shared/todo/const/filter_values.dart';
import 'package:wire_example_shared/todo/const/view_signals.dart';
import 'package:wire_example_shared/todo/data/dto/edit_dto.dart';
import 'package:wire_example_shared/todo/data/dto/input_dto.dart';
import 'package:wire_example_todo_commands/src/controller/commands/operations/apply_filter_to_todos_command.dart';
import 'package:wire_example_todo_commands/src/controller/commands/operations/clear_completed_todos_command.dart';
import 'package:wire_example_todo_commands/src/controller/commands/operations/complete_all_todos_command.dart';
import 'package:wire_example_todo_commands/src/controller/commands/todo/todo_delete_command.dart';
import 'package:wire_example_todo_commands/src/controller/commands/todo/todo_edit_command.dart';
import 'package:wire_example_todo_commands/src/controller/commands/todo/todo_input_command.dart';
import 'package:wire_example_todo_commands/src/controller/commands/todo/todo_toggle_command.dart';
import 'package:wire_example_todo_commands/src/controller/getters/getter_count_completed.dart';

class TodoController {
  TodoController() {
    Wire.addMany(this, {
      ViewSignals.INPUT: (input, __) => TodoInputCommand(input as InputDTO).execute(),
      ViewSignals.EDIT: (input, __) => TodoEditCommand(input as EditDTO).execute(),
      ViewSignals.DELETE: (input, __) => TodoDeleteCommand(input as String).execute(),
      ViewSignals.TOGGLE: (input, __) => TodoToggleCommand(input as String).execute(),

      ViewSignals.FILTER: (input, __) => ApplyFilterToTodosCommand(input as FilterValues).execute(),
      ViewSignals.CLEAR_COMPLETED: (input, __) => ClearCompletedTodosCommand().execute(),
      ViewSignals.COMPLETE_ALL: (input, __) => CompleteAllTodosCommand(input as bool).execute(),
    });

    Wire.data(DataKeys.GET_COUNT_COMPLETED, getter: CountCompletedGetter().getter);
  }
}
