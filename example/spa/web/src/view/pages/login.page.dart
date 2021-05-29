import 'dart:html';

import '../base/page.dart';

class LoginPage extends Page {
  LoginPage() : super('login') {
    dom.style.backgroundColor = "lightblue";
  }

  @override
  void initialize() {
    (dom.querySelector('#btnConfirm') as HtmlElement)
      .addEventListener('click', (event) => {
        print('Confirm')
      });
  }

  @override
  void render() {

  }

  @override
  void destroy() {
    super.destroy();
  }
}
