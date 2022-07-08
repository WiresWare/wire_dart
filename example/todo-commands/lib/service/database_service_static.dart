import 'dart:convert';

import 'package:wire/abstract/abstract_wire_database_service.dart';

class StaticDatabaseService extends WireDatabaseServiceAbstract {
  static final Map<String, String> _db = <String, String>{};

  @override
  bool exist(String key) {
    final result = !!_db.containsKey(key);
    print('> StaticDatabaseService -> exist: $key = $result');
    return result;
  }

  @override
  Future<dynamic> retrieve(String key) {
    final value = _db[key];
    print('> StaticDatabaseService -> retrieve: $key');
    return Future.value(value != null ? jsonDecode(value) : null);
  }

  @override
  void save(String key, dynamic data) {
    print('> StaticDatabaseService -> save: $key');
    _db[key] = jsonEncode(data);
  }

  @override
  void delete(String key) {
    print('> StaticDatabaseService -> delete: $key');
    _db.remove(key);
  }

  @override
  Future<bool> init([String? key]) {
    return Future.value(true);
  }
}
