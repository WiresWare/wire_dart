import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';

class CountCompletedGetter {

  final listOfAllTodosWireData = Wire.data(DataKeys.LIST_OF_IDS);
  final notCompletedCountWireData = Wire.data(DataKeys.COUNT);

  int getter(WireData that) {
    if (!that.hasListener(that.refresh)) {
      listOfAllTodosWireData.subscribe(that.refresh);
      notCompletedCountWireData.subscribe(that.refresh);
    }

    final int notCompletedCount = notCompletedCountWireData.value as int;
    return (listOfAllTodosWireData.value as List).length - notCompletedCount;
  }
}
