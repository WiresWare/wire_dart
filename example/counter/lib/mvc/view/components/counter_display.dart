import 'package:web/web.dart';

import 'package:wire/wire.dart';
import 'package:wire_example_counter/const/counter_data_keys.dart';
import 'package:wire_example_counter/mvc/view/base/dom_element.dart';

class CounterDisplay extends DomElement {
  CounterDisplay() : super(HTMLDivElement()) {
    final wireData = Wire.data<int>(CounterDataKeys.COUNT);
    wireData.subscribe(update);
    update(wireData.value ?? 0);
  }

  Future<void> update(int? value) async {
    print('> CounterDisplay -> update: ${value}');
    dom.textContent = value.toString();
  }
}
