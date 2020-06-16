import 'dart:convert';
import 'dart:html';
import 'package:wire/wire.dart';
import '../const/TodoDataParams.dart';
import '../const/TodoFilterValues.dart';
import 'ITodoModel.dart';
import 'vo/TodoVO.dart';

class TodoModel implements ITodoModel {
  static const String LOCAL_STORAGE_KEY = 'todo-mvc-dart-wire';

  TodoModel() {
    var idsList = <String>[];
    var notCompletedCount = 0;
    if (window.localStorage.containsKey(LOCAL_STORAGE_KEY)) {
      try {
        jsonDecode(window.localStorage[LOCAL_STORAGE_KEY]).forEach((obj){
          if (obj != null) {
            var todoVO = TodoVO.fromJson(obj);
            Wire.data(todoVO.id, todoVO);
            idsList.add(todoVO.id);
            if (!todoVO.completed) notCompletedCount++;
          }
        });
      } catch (e) {
        print('Error loading form local storage: ' + e.toString());
      }
    }
    Wire.data(TodoDataParams.LIST, idsList);
    Wire.data(TodoDataParams.COUNT, notCompletedCount);
  }

  @override
  TodoVO create(String text) {
    final time = DateTime.now().millisecondsSinceEpoch;
    final id = time.toString();
    final todoVO = TodoVO(id, text, false);
    final listData = Wire.data(TodoDataParams.LIST);
    final todoList = listData.value as List;
    final count = Wire.data(TodoDataParams.COUNT).value as int;

    todoList.add(todoVO.id);
    Wire.data(todoVO.id, todoVO);
    Wire.data(TodoDataParams.LIST, todoList);
    Wire.data(TodoDataParams.COUNT, count + 1);

    _save();

    print('> TodoModel -> created: ' + todoVO.id + ' - ' + todoVO.text);
    return todoVO;
  }

  @override
  TodoVO remove(String id) {
    final todoList = Wire.data(TodoDataParams.LIST).value as List;
    final count = Wire.data(TodoDataParams.COUNT).value as int;
    final todoWireData = Wire.data(id);
    final todoVO = todoWireData.value as TodoVO;

    todoList.remove(id);
    todoWireData.remove();

    if (todoVO.completed == false) {
      Wire.data(TodoDataParams.COUNT, count -1);
    }

    _save();

    print('> TodoModel -> removed: ' + id);
    return todoVO;
  }

  @override
  TodoVO update(String id, String text) {
    final todoWireData = Wire.data(id);
    final todoVO = todoWireData.value as TodoVO;
    todoVO.text = text;
    Wire.data(id, todoVO);
    _save();

    print('> TodoModel -> updated: ' + todoVO.id + ' - ' + todoVO.text);
    return todoVO;
  }

  @override
  TodoVO toggle(String id) {
    final todoWireData = Wire.data(id);
    final todoVO = todoWireData.value as TodoVO;
    final count = Wire.data(TodoDataParams.COUNT).value as int;

    todoVO.completed = !todoVO.completed;

    Wire.data(id, todoVO);
    Wire.data(TodoDataParams.COUNT, count + (todoVO.completed ? -1 : 1));

    _save();

    print('> TodoModel -> toggled: ' + todoVO.id + ' - ' + todoVO.text);
    return null;
  }

  @override
  void filter(TodoFilterValue filter) {
    final todoList = Wire.data(TodoDataParams.LIST).value as List;
    todoList.forEach((id) {
      var todoWireData = Wire.data(id);
      var todoVO = todoWireData.value as TodoVO;
      var todoVisible = todoVO.visible;
      switch (filter) {
        case TodoFilterValue.ALL: todoVisible = true; break;
        case TodoFilterValue.ACTIVE: todoVisible = !todoVO.completed; break;
        case TodoFilterValue.COMPLETED: todoVisible = todoVO.completed; break;
      }
      if (todoVO.visible != todoVisible) {
        todoVO.visible = todoVisible;
        Wire.data(id, todoVO);
      }
    });
    Wire.data(TodoDataParams.FILTER, filter);
    print('> TodoModel -> filtered: ' + filter.toString());
  }

  @override
  void clearCompleted() {
    final todoList = Wire.data(TodoDataParams.LIST).value as List;
    todoList.removeWhere((id) {
      var todoWireData = Wire.data(id);
      var todoVO = todoWireData.value as TodoVO;
      if (todoVO.completed) {
        todoWireData.remove();
      }
      return todoVO.completed;
    });

    _save();
    print('> TodoModel -> clearCompleted: length = ' + todoList.length.toString());
  }

  void _save() {
    var listToSave = <TodoVO>[];
    (Wire.data(TodoDataParams.LIST).value as List).forEach((id) =>
      listToSave.add(Wire.data(id).value)
    );
    window.localStorage[LOCAL_STORAGE_KEY] = jsonEncode(listToSave);
  }
}