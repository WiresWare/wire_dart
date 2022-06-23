import 'dart:html';

abstract class Component {
  Component(String className) {
    dom.className = '${className} ';
  }

  DivElement dom = DivElement();

  bool shouldRender() {
    return true;
  }

  void render() {}
  void destroy() {
    dom.remove();
  }
}
