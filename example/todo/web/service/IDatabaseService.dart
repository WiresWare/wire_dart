abstract class IDatabaseService {
  bool exist(String key);
  dynamic retrieve(String key);
  void save(String key, dynamic data);
}