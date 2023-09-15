import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/ViewSignals.dart';
import 'package:wire_example_shared/todo/data/dto/InputDTO.dart';

@Component(
  selector: 'todo-input',
  styleUrls: ['todo_input_component.css'],
  templateUrl: 'todo_input_component.html',
  directives: [
    MaterialFabComponent,
    MaterialIconComponent,
    materialInputDirectives,
  ],
)
class TodoInputComponent implements OnInit {
  String text = '';

  @override
  Future<Null> ngOnInit() async {
    Wire.add(this, ViewSignals.CLEAR_INPUT, (data, wid) {
      text = '';
    });
  }

  void enter() {
    Wire.send(ViewSignals.INPUT, payload: InputDTO(text, ''));
  }
}
