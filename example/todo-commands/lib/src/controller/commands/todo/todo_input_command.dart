import 'package:wire/utils/wire_command_with_wire_data.dart';
import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';
import 'package:wire_example_shared/todo/const/view_signals.dart';
import 'package:wire_example_shared/todo/data/dto/input_dto.dart';
import 'package:wire_example_shared/todo/data/vo/todo_vo.dart';

class TodoInputCommand extends WireCommandWithWireData<void> {
  TodoInputCommand(this.inputDTO);

  final InputDTO inputDTO;

  @override
  Future<void> execute() async {
    final text = inputDTO.text;

    if (text.isNotEmpty) {
      final note = inputDTO.note;
      final completed = inputDTO.completed;

      final newTodoId = DateTime.now().millisecondsSinceEpoch.toString();
      final newTodoVO = TodoVO(newTodoId, text, note, completed);

      final todoIdsList = await get<List<String>>(DataKeys.LIST_OF_IDS);
      final currentCount = await get<int>(DataKeys.COUNT);
      final notCompletedCount = currentCount + (completed ? 0 : 1);

      todoIdsList.add(newTodoId);

      // Add object to data layer by id
      update(newTodoVO.id, data: newTodoVO);
      // Update TodoList in data layer
      update(DataKeys.LIST_OF_IDS, data: todoIdsList);
      // Update counter
      update(DataKeys.COUNT, data: notCompletedCount);
      // Send signal to clean input
      Wire.send(ViewSignals.CLEAR_INPUT);
    } else {
      // Signalise about error or wrong input
    }
  }
}
