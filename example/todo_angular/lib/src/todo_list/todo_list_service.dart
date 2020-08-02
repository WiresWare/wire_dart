import 'dart:async';

import 'package:angular/core.dart';
import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/DataKeys.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class TodoListService {
  Future<List<String>> get() async => Wire.data(DataKeys.LIST).value;
}
