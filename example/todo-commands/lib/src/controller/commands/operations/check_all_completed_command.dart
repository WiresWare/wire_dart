import 'package:wire/utils/wire_command_with_wire_data.dart';
import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';
import 'package:wire_example_shared/todo/const/view_signals.dart';

class CheckAllCompletedCommand extends WireCommandWithWireData<void> {
  CheckAllCompletedCommand();

  @override
  Future<void> execute() async {
    final count = (await get<List>(DataKeys.LIST_OF_IDS)).length;
    final countCompleted = Wire.data(DataKeys.GET_COUNT_COMPLETED).value;
    final completeAll = count == countCompleted;
    print('> CheckAllCompletedCommand: wdCount = ${count}');
    print('> CheckAllCompletedCommand: wdCountCompleted = ${countCompleted}');
    print('> CheckAllCompletedCommand: completeAll = ${completeAll}');
    update(DataKeys.COMPLETE_ALL, data: completeAll);
    Wire.send(ViewSignals.COMPLETE_ALL_FORCED, payload: completeAll);
  }
}
