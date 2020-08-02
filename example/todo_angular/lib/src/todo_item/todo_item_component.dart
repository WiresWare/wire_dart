import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/ViewSignals.dart';
import 'package:wire_example_shared/todo/data/vo/TodoVO.dart';

@Component(
  selector: 'todo-item',
  styleUrls: ['todo_item_component.css'],
  template: '''
    <material-checkbox #done materialTooltip="Mark item as done">
    </material-checkbox>
    <span [class.done]="done.checked">{{todo.text}}</span>
    <material-fab mini (trigger)="delete()">
      <material-icon icon="delete"></material-icon>
    </material-fab>
  ''',
  directives: [
    MaterialCheckboxComponent,
    MaterialFabComponent,
    MaterialIconComponent,
  ],
)

class TodoItemComponent implements OnInit {
  @Input()
  String id;

  @override
  Future<Null> ngOnInit() async { }

  TodoVO get todo => Wire.data(id).value;
  void delete() { Wire.send(ViewSignals.DELETE, id); }
}
