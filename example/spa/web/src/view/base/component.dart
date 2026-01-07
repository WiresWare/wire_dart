import 'package:web/web.dart';

abstract class Component {
  Component(String className) {
    dom.className = '${className} ';
  }

  HTMLDivElement dom = HTMLDivElement();

  bool shouldRender() {
    return true;
  }

  void render() {}
  void destroy() {
    dom.remove();
  }
}
