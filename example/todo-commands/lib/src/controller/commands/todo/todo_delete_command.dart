import 'package:wire/utils/wire_command_with_wire_data.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';
import 'package:wire_example_shared/todo/data/vo/todo_vo.dart';

class TodoDeleteCommand extends WireCommandWithWireData<void> {
  TodoDeleteCommand(this.todoId);

  final String todoId;

  @override
  Future<void> execute() async {
    print('> TodoDeleteCommand -> removed: ${todoId}');
    final todoIdsList = await get<List<String>>(DataKeys.LIST_OF_IDS);
    final count = await get<int>(DataKeys.COUNT);
    final todoVO = await get<TodoVO>(todoId);

    todoIdsList.remove(todoId);
    await remove(todoId);

    if (todoVO.completed == false) {
      update<int>(DataKeys.COUNT, data: count - 1);
    }

    update<List<String>>(DataKeys.LIST_OF_IDS, data: todoIdsList);
  }
}
