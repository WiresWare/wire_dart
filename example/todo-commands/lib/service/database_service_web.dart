import 'dart:convert';
import 'dart:html';

import 'package:wire/abstract/abstract_wire_database_service.dart';

class WebDatabaseService extends WireDatabaseServiceAbstract {
  @override
  bool exist(String key) {
    final result = !!window.localStorage.containsKey(key);
    // log('> WebDatabaseService -> exist: $key = $result');
    return result;
  }

  @override
  Future<dynamic> retrieve(String key) {
    final value = window.localStorage[key];
    print('> WebDatabaseService -> retrieve: $key');
    return Future.value(value != null ? jsonDecode(value) : null);
  }

  @override
  void save(String key, dynamic data) {
    // log('> WebDatabaseService -> save: $key = $data');
    window.localStorage[key] = jsonEncode(data);
  }

  @override
  void delete(String key) {
    // log('> StaticDatabaseService -> delete: $key');
    window.localStorage.remove(key);
  }

  @override
  Future<bool> init([String? key]) {
    return Future.value(true);
  }
}
