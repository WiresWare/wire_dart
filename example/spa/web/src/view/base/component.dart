import 'dart:html';

abstract class Component {
  DivElement dom;

  Component(String className) {
    dom = DivElement();
    dom.className = '${className} ';
  }

  bool shouldRender() {
    return true;
  }

  void render() {}
  void destroy() {
    dom = null;
  }
}
