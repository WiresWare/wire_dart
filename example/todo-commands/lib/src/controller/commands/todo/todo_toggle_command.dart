import 'package:wire/utils/wire_command_with_wire_data.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';
import 'package:wire_example_shared/todo/data/vo/todo_vo.dart';
import 'package:wire_example_todo_commands/src/controller/commands/operations/check_all_completed_command.dart';

class TodoToggleCommand extends WireCommandWithWireData<void> {
  TodoToggleCommand(this.todoId);

  final String todoId;

  @override
  Future<void> execute() async {
    final todoVO = await get<TodoVO?>(todoId).onError((error, stackTrace) => null);
    if (todoVO == null) return;
    final count = await get<int>(DataKeys.COUNT).onError((error, stackTrace) => 0);
    final wasCompleted = todoVO.completed;

    todoVO.completed = !todoVO.completed;
    final completedCount = count + (todoVO.completed ? -1 : 1);

    update(todoId, data: todoVO);
    update(DataKeys.COUNT, data: completedCount);

    if (wasCompleted) CheckAllCompletedCommand().execute();

    print('> TodoToggleCommand -> toggled: id = ${todoVO.id} - ${todoVO.completed} - ${todoVO.text}');
  }
}
