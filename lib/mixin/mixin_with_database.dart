library wire;

import 'dart:convert';

import 'package:wire/abstract/abstract_wire_database_service.dart';

mixin WireMixinWithDatabase {
  late final WireDatabaseServiceAbstract databaseService;

  bool exist(String key) => databaseService.exist(key);
  Future<dynamic> retrieve(String key) => databaseService.retrieve(key);
  // ignore: empty_catches
  void persist(String key, dynamic value) {
    try {
      databaseService.save(key, jsonEncode(value));
    } catch (e) {}
  }

  void delete(String key) => {if (exist(key)) databaseService.delete(key)};
}
