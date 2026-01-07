library;

import 'dart:convert';

import 'package:wire/abstract/abstract_wire_database_service.dart';

bool isPrimitive(dynamic value) {
  return value is String ||
      value is int ||
      value is double || // or use 'value is num' to cover both int and double
      value is bool ||
      value == null;
}

mixin WireMixinWithDatabase {
  late final WireDatabaseServiceAbstract databaseService;

  bool exist(String key) => databaseService.exist(key);
  Future<dynamic> retrieve(String key) => databaseService.retrieve(key);
  // ignore: empty_catches
  void persist(String key, dynamic value) {
    print('> WireMixinWithDatabase -> persist: key = $key | $value | isPrimitive(${isPrimitive(value)})');
    try {
      if (value == null) {
        delete(key);
        return;
      }
      databaseService.save(key, isPrimitive(value) ? value.toString() : jsonEncode(value));
    } catch (e) {
      print('> WireMixinWithDatabase -> failed to persist data: key = $key | $value');
    }
  }

  void delete(String key) => {if (exist(key)) databaseService.delete(key)};
}
