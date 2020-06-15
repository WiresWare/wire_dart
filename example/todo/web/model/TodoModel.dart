import 'dart:convert';
import 'dart:html';

import 'package:wire/wire.dart';

import '../const/TodoDataParams.dart';
import 'ITodoModel.dart';
import 'vos/TodoVO.dart';

class TodoModel implements ITodoModel {
  static const String LOCAL_STORAGE_KEY = 'todo-mvc-dart-wire';

  TodoModel() {
    var idsList = <String>[];
    if (window.localStorage.containsKey(LOCAL_STORAGE_KEY)) {
      try {
        jsonDecode(window.localStorage[LOCAL_STORAGE_KEY]).forEach((obj){
          var todoVO = TodoVO.fromJson(obj);
          Wire.data(todoVO.id, todoVO);
          idsList.add(todoVO.id);
        });
      } catch (e) {
        print('Error loading form local storage: ' + e.toString());
      }
    }
    Wire.data(TodoDataParams.LIST, idsList);
  }

  @override
  TodoVO create(String text) {
    final time = DateTime.now().millisecondsSinceEpoch;
    final id = time.toString();
    final vo = TodoVO(id, text, false);
    final data = Wire.data(TodoDataParams.LIST);
    final list = data.value as List;

    list.add(vo.id);
    Wire.data(vo.id, vo);
    Wire.data(TodoDataParams.LIST, list);

    _save();

    print('> TodoModel -> create: ' + vo.id + ' - ' + vo.text);
    return vo;
  }
  @override
  TodoVO remove(String id) {
    final list = Wire.data(TodoDataParams.LIST).value as List;
    final data = Wire.data(id);
    final vo = data.value;

    list.remove(id);
    data.remove();

    _save();

    print('> TodoModel -> remove: ' + id);
    return vo;
  }

  @override
  TodoVO update(String id, String text) {
    _save();
    return null;
  }
  @override
  TodoVO toggle(String id) {
    _save();
    return null;
  }

  void _save() {
    var list = <TodoVO>[];
    (Wire.data(TodoDataParams.LIST).value as List).forEach((id) =>
      list.add(Wire.data(id).value)
    );
    window.localStorage[LOCAL_STORAGE_KEY] = jsonEncode(list);
  }
}