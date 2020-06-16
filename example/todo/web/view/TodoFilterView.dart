import 'dart:html';

import 'package:wire/wire.dart';

import '../const/TodoDataParams.dart';
import '../const/TodoFilterValues.dart';
import 'base/DomElementView.dart';

class TodoFilterView extends DomElement {
  TodoFilterView(UListElement dom):super(dom) {
    Wire.data(TodoDataParams.FILTER).subscribe(this, (value) {
      var filter = value as TodoFilterValue;
      var selectedChildIndex;
      switch (filter) {
        case TodoFilterValue.ALL: selectedChildIndex = 0; break;
        case TodoFilterValue.ACTIVE: selectedChildIndex = 1; break;
        case TodoFilterValue.COMPLETED: selectedChildIndex = 2; break;
      }
      (dom.querySelector('.selected') as AnchorElement).className = '';
      (dom.children[selectedChildIndex].children[0] as AnchorElement)
          .className = 'selected';
    });
  }
}

