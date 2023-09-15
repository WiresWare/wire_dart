import 'package:wire/wire.dart';
import 'package:wire_example_counter/const/counter_data_keys.dart';
import 'package:wire_example_counter/mvc/model/middleware/counter_storage_middleware.dart';

class CounterModel {
  CounterModel() {
    final counterStorageMiddleware = CounterStorageMiddleware();
    final initialValue = counterStorageMiddleware.getInitialValue();

    /// Set initial value from local storage
    Wire.data(CounterDataKeys.COUNT, value: initialValue);

    /// Register middleware after setting initial value to prevent saving initial value
    Wire.middleware(counterStorageMiddleware);
  }
}
