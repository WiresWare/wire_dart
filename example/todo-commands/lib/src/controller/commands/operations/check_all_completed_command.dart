import 'package:wire/utils/util_wire_command_with_wire_data.dart';
import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';
import 'package:wire_example_shared/todo/const/view_signals.dart';

class CheckAllCompletedCommand extends WireCommandWithWireData<void> {
  CheckAllCompletedCommand();

  @override
  Future<void> execute() async {
    final completeAllWireData = Wire.data(DataKeys.COMPLETE_ALL);
    final bool completeAll = completeAllWireData.isSet && (completeAllWireData.value as bool);
    print('> CheckAllCompletedCommand: completeAll = ${completeAll}');
    update(DataKeys.COMPLETE_ALL, data: completeAll);
    if (completeAll) {
      Wire.send(ViewSignals.COMPLETE_ALL_FORCED, payload: false);
    }
  }
}
