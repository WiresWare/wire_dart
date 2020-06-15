import 'vos/TodoVO.dart';

abstract class ITodoModel {
  TodoVO create(String text);
  TodoVO remove(String id);
  TodoVO update(String id, String text);
  TodoVO toggle(String id);
}