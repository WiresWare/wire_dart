import 'package:wire/wire.dart';

import '../const/counter_data_keys.dart';
import 'middleware/counter_storage_middleware.dart';

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
