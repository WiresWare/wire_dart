import 'dart:html';

abstract class Component {
  DivElement dom = DivElement();

  Component(String className) {
    dom.className = '${className} ';
  }

  bool shouldRender() {
    return true;
  }

  void render() {}
  void destroy() {
    dom.remove();
  }
}
