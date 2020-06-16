import 'dart:html';

import 'package:wire/wire.dart';

import '../const/TodoDataParams.dart';
import '../const/TodoViewSignal.dart';
import 'base/DomElementView.dart';

class ClearCompletedView extends DomElement {
  ClearCompletedView(ButtonElement dom):super(dom) {
    var listWireData = Wire.data(TodoDataParams.LIST);
    var countWireData = Wire.data(TodoDataParams.COUNT);

    var updateComponentVisibility = (value) => 
      setComponentVisibilityFrom(listWireData.value, countWireData.value);

    listWireData.subscribe(this, updateComponentVisibility);
    countWireData.subscribe(this, updateComponentVisibility);
    updateComponentVisibility(null);

    dom.onClick.listen((e) => Wire.send(TodoViewSignal.CLEAR_COMPLETED));
  }

  void setComponentVisibilityFrom(List list, int count) {
    dom.style.display = (count <= list?.length) ? 'block' : 'none';
  }
}

