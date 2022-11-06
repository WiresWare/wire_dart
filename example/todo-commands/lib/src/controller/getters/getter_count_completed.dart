import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';

class CountCompletedGetter {
  final listOfAllTodosWireData = Wire.data(DataKeys.LIST_OF_IDS);
  final notCompletedCountWireData = Wire.data(DataKeys.COUNT);

  int getter(WireData that) {
    final int notCompletedCount = notCompletedCountWireData.value as int;
    final result = (listOfAllTodosWireData.value as List).length - notCompletedCount;
    print('> CountCompletedGetter - getter: result = ${result}');
    return result;
  }
}
