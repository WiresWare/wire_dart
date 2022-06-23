import 'dart:html';
import 'package:wire/wire.dart';

import '../../const/counter_data_keys.dart';

import '../base/dom_element.dart';

class CounterDisplay extends DomElement {
  CounterDisplay() : super(DivElement()) {
    dom.className = 'spectrum-Body spectrum-Body--L';

    final wireData = Wire.data<int?>(CounterDataKeys.COUNT);
    wireData.subscribe(update);
    update(wireData.value ?? 0);
  }

  Future<void> update(value) async {
    dom.text = value.toString();
  }
}
