import 'component.dart';

abstract class Page extends Component {
  late String _path;
  String get path => _path;

  Page(String path):super('page') {
    _path = path;
  }

  void initialize() { }

  Future<void> beforeLeave() {
    return Future.value();
  }
}
