import 'dart:convert';

import 'package:wire/abstract/abstract_wire_database_service.dart';
import 'package:wire/mixin/mixin_with_database.dart';
import 'package:wire/mixin/mixin_with_when_ready.dart';
import 'package:wire/mixin/mixin_with_wire_data.dart';
import 'package:wire/wire.dart';
import 'package:wire_example_shared/todo/const/data_keys.dart';
import 'package:wire_example_shared/todo/data/vo/todo_vo.dart';
import 'package:wire_example_todo_commands/service/database_service_web.dart';

class StorageMiddleware extends WireMiddleware with WireMixinWithDatabase, WireMixinWithWireData, WireMixinWithWhenReady {
  StorageMiddleware() {
    databaseService = Wire.find<WebDatabaseService>() as WireDatabaseServiceAbstract;
    whenReady = Future(() async {
      await databaseService.init();
      // final wireDataTodoList = Wire.data(DataKeys.LIST_OF_IDS);
      // final todoList = wireDataTodoList.value as List<String>;
      final hasStoredList = exist(DataKeys.LIST_OF_IDS);
      print('> StorageMiddleware -> setup - hasStoredList: ${hasStoredList}');
      if (hasStoredList) {
        final todoIdsListRaw = await retrieve(DataKeys.LIST_OF_IDS) as String;
        final todoIdsList = <String>[];
        await Future.forEach(jsonDecode(todoIdsListRaw) as List<dynamic>, (v) async {
          final todoId = v.toString();
          if (exist(todoId)) {
            final todoRaw = jsonDecode(await retrieve(todoId) as String) as Map<String, dynamic>;
            print('> \t todoRaw(${todoId}): ${todoRaw}');
            update<TodoVO>(todoId, data: TodoVO.fromJson(todoRaw));
          }
          todoIdsList.add(todoId);
        });
        print('> StorageMiddleware -> LIST_OF_IDS: ${todoIdsList}');
        update<List<String>>(DataKeys.LIST_OF_IDS, data: todoIdsList);

        if (exist(DataKeys.COUNT)) {
          final countRaw = int.parse(await retrieve(DataKeys.COUNT) as String);
          print('> StorageMiddleware -> COUNT: ${countRaw}');
          update<int>(DataKeys.COUNT, data: countRaw);
        } else
          update<int>(DataKeys.COUNT, data: todoIdsList.length);

        if (exist(DataKeys.COMPLETE_ALL)) {
          final completeAllRaw = await retrieve(DataKeys.COMPLETE_ALL) as String;
          print('> StorageMiddleware -> COMPLETE_ALL: ${completeAllRaw}');
          update<bool>(DataKeys.COMPLETE_ALL, data: completeAllRaw == 'true');
        } else
          update<bool>(DataKeys.COMPLETE_ALL, data: false);
      } else {
        update<List<String>>(DataKeys.LIST_OF_IDS, data: <String>[]);
        update<bool>(DataKeys.COMPLETE_ALL, data: false);
        update<int>(DataKeys.COUNT, data: 0);
      }
      return Future.value(true);
    });
  }

  @override
  Future<void> onAdd(wire) async {}

  @override
  Future<void> onData(String key, prevValue, nextValue) async {
    print(
      '> StorageMiddleware -> onData: key = '
      '${key} | $prevValue | $nextValue',
    );
    persist(key, nextValue);
  }

  @override
  Future<void> onRemove(String signal, [Object? scope, listener]) async {}

  @override
  Future<void> onSend(signal, [payload, scope]) async {}

  @override
  Future<void> onDataError(error, String key, value) {
    print(
      '> StorageMiddleware -> onDataError: key = '
      '${key} | $value',
    );
    return Future.value();
  }

  @override
  Future<void> onReset(String key, value) {
    print(
      '> StorageMiddleware -> onReset: key = '
      '${key} | $value',
    );
    return Future.value();
  }
}
