import 'dart:html';

import '../base/page.dart';

class LoginPage extends Page {
  LoginPage() : super('login') {
    dom.style.backgroundColor = "lightblue";
  }

  @override
  void initialize() {
    dom.querySelector('#btnConfirm')
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
