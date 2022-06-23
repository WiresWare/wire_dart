import 'component.dart';

abstract class Page extends Component {
  Page(String path):super('page') {
    _path = path;
  }

  late String _path;
  String get path => _path;

  void initialize() { }

  Future<void> beforeLeave() {
    return Future.value();
  }
}
