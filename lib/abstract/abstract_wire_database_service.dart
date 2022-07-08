abstract class WireDatabaseServiceAbstract {
  Future<bool> init([String key]);
  bool exist(String key);
  Future<dynamic> retrieve(String key);
  void save(String key, dynamic data);
  void delete(String key);
}
