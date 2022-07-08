import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wire/abstract/abstract_wire_database_service.dart';

class SharedDatabaseService extends WireDatabaseServiceAbstract {
  late final SharedPreferences _sp;

  @override
  bool exist(String key) {
    final result = !!_sp.containsKey(key);
    // log('> SharedDatabaseService -> exist: $key = $result');
    return result;
  }

  @override
  Future<dynamic> retrieve(String key) {
    final value = _sp.getString(key);
    // log('> SharedDatabaseService -> retrieve: $key');
    return Future.value(value != null ? jsonDecode(value) : null);
  }

  @override
  void save(String key, dynamic data) {
    // log('> SharedDatabaseService -> save: $key = $data');
    _sp.setString(key, jsonEncode(data));
  }

  @override
  void delete(String key) {
    // log('> SharedDatabaseService -> delete: $key');
    _sp.remove(key);
  }

  @override
  Future<bool> init([String? key]) async {
    _sp = await SharedPreferences.getInstance();
    return Future.value(true);
  }
}
