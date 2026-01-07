import 'package:wire/utils/wire_command_with_wire_data.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';
import 'package:wire_example_shared/todo/data/vo/todo_vo.dart';

class CompleteAllTodosCommand extends WireCommandWithWireData<void> {
  CompleteAllTodosCommand(this.isComplete);

  final bool isComplete;

  @override
  Future<void> execute() async {
    final todoIdsList = await get<List<String>>(DataKeys.LIST_OF_IDS);
    int count = await get<int>(DataKeys.COUNT);
    print('> CompleteAllTodosCommand -> execute: isComplete = ${isComplete} - count = $count');
    await Future.forEach(todoIdsList, (String todoId) async {
      final todoVO = await get<TodoVO>(todoId);
      if (todoVO.completed != isComplete) {
        count += isComplete ? -1 : 1;
        todoVO.completed = isComplete;
        update<TodoVO>(todoId, data: todoVO);
      }
    });
    update<int>(DataKeys.COUNT, data: count);
    update<bool>(DataKeys.COMPLETE_ALL, data: isComplete);
  }
}
