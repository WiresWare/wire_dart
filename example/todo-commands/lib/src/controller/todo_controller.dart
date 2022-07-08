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
      ViewSignals.INPUT:    (_, __) => TodoInputCommand(_! as InputDTO).execute(),
      ViewSignals.EDIT:     (_, __) => TodoEditCommand(_! as EditDTO).execute(),
      ViewSignals.DELETE:   (_, __) => TodoDeleteCommand(_! as String).execute(),
      ViewSignals.TOGGLE:   (_, __) => TodoToggleCommand(_! as String).execute(),

      ViewSignals.FILTER:          (_, __) => ApplyFilterToTodosCommand(_! as FilterValues).execute(),
      ViewSignals.CLEAR_COMPLETED: (_, __) => ClearCompletedTodosCommand().execute(),
      ViewSignals.COMPLETE_ALL:    (_, __) => CompleteAllTodosCommand(_! as bool).execute()
    });

    Wire.data(DataKeys.GET_COUNT_COMPLETED, getter: CountCompletedGetter().getter);
  }
}
