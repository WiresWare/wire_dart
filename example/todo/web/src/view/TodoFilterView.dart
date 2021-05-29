import 'dart:html';

import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/DataKeys.dart';
import 'package:wire_example_shared/todo/const/FilterValues.dart';

import 'base/DomElementView.dart';

class TodoFilterView extends DomElement {
  static const Map _FILTER_TO_VALUE = {
    FilterValues.ALL: 0,
    FilterValues.ACTIVE: 1,
    FilterValues.COMPLETED: 2
  };

  final CLASS_NAME_SELECTED = 'selected';

  TodoFilterView(UListElement dom) : super(dom) {
    Wire.data(DataKeys.FILTER).subscribe((value) async {
      final filter = value as FilterValues;
      final selectedChildIndex = _FILTER_TO_VALUE[filter];
      (dom.querySelector('.$CLASS_NAME_SELECTED') as AnchorElement).className = '';
      if (selectedChildIndex) {
        (dom.children[selectedChildIndex].children[0] as AnchorElement)
            .className = CLASS_NAME_SELECTED;
      }
    });
  }
}
