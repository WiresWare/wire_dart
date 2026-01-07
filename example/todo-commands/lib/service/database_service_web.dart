import 'dart:convert';
import 'package:web/web.dart';

import 'package:wire/abstract/abstract_wire_database_service.dart';

class WebDatabaseService extends WireDatabaseServiceAbstract {
  @override
  bool exist(String key) {
    final result = window.localStorage.getItem(key) != null;
    print('> WebDatabaseService -> exist: $key = $result');
    return result;
  }

  @override
  Future<dynamic> retrieve(String key) {
    final value = window.localStorage.getItem(key);
    print('> WebDatabaseService -> retrieve: $key');
    return Future.value(value);
  }

  @override
  void save(String key, dynamic data) {
    print('> WebDatabaseService -> save: $key = $data');
    window.localStorage.setItem(key, data as String);
  }

  @override
  void delete(String key) {
    print('> StaticDatabaseService -> delete: $key');
    window.localStorage.removeItem(key);
  }

  @override
  Future<bool> init([String? key]) {
    return Future.value(true);
  }
}
