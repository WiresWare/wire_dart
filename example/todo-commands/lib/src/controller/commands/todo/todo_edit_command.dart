import 'package:wire/utils/wire_command_with_wire_data.dart';
import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';
import 'package:wire_example_shared/todo/data/dto/edit_dto.dart';
import 'package:wire_example_shared/todo/data/vo/todo_vo.dart';

class TodoEditCommand extends WireCommandWithWireData<void> {
  TodoEditCommand(this.editTodoDTO);

  final EditDTO editTodoDTO;

  @override
  Future<void> execute() async {
    final todoText = editTodoDTO.text;
    final todoNote = editTodoDTO.note;
    final todoId = editTodoDTO.id;
    if (todoText.isEmpty) {
      _removeTodo(todoId);
    } else {
      _updateTodo(todoId, todoText, todoNote);
    }
    print('> TodoEditCommand -> toggled: id = ${todoId} - ${todoText} - ${todoNote}');
  }

  Future<void> _updateTodo(String id, String text, String note) async {
    final todoVO = await get<TodoVO>(id);
    todoVO.text = text;
    todoVO.note = note;
    update<TodoVO>(id, data: todoVO);
  }

  Future<void> _removeTodo(String id) async {
    final todoIdsList = await get<List<String>>(DataKeys.LIST_OF_IDS);
    final count = await get<int>(DataKeys.COUNT);
    final todoVO = await get<TodoVO>(id);

    todoIdsList.remove(id);
    await Wire.data(id).remove();

    if (todoVO.completed == false) {
      update(DataKeys.COUNT, data: count - 1);
    }

    update(DataKeys.LIST_OF_IDS, data: todoIdsList);
  }
}
