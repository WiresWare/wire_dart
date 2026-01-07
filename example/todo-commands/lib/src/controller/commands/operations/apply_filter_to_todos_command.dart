import 'package:wire/utils/wire_command_with_wire_data.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';
import 'package:wire_example_shared/todo/const/filter_values.dart';
import 'package:wire_example_shared/todo/data/vo/todo_vo.dart';

class ApplyFilterToTodosCommand extends WireCommandWithWireData<void> {
  ApplyFilterToTodosCommand(this.filter);

  final FilterValues filter;

  @override
  Future<void> execute() async {
    final todoIdsList = await get<List<String>>(DataKeys.LIST_OF_IDS);
    print('> ApplyFilterToTodosCommand -> execute: $filter');
    await Future.forEach(todoIdsList, (String todoId) async {
      final todoVO = await get<TodoVO>(todoId);
      bool todoVisible = todoVO.visible;
      switch (filter) {
        case FilterValues.ALL:
          todoVisible = true;
          break;
        case FilterValues.ACTIVE:
          todoVisible = !todoVO.completed;
          break;
        case FilterValues.COMPLETED:
          todoVisible = todoVO.completed;
          break;
      }
      if (todoVO.visible != todoVisible) {
        todoVO.visible = todoVisible;
        update<TodoVO>(todoId, data: todoVO);
      }
    });

    update<FilterValues>(DataKeys.FILTER, data: filter);
  }
}
