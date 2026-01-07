import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';

class CountCompletedGetter {
  final listOfAllTodosWireData = Wire.data<Object>(DataKeys.LIST_OF_IDS);
  final notCompletedCountWireData = Wire.data<int>(DataKeys.COUNT);

  int getter(_) {
    if (notCompletedCountWireData.isSet == false || listOfAllTodosWireData.isSet == false) return 0;
    final notCompletedCount = notCompletedCountWireData.value ?? 0;
    final result = (listOfAllTodosWireData.value as List<String>? ?? []).length - notCompletedCount;
    print('> CountCompletedGetter - getter: result = ${result}');
    return result as int;
  }
}
