import 'dart:html';

import 'package:wire/wire.dart';

import '../../constants/action.dart';
import '../../constants/signals.dart';
import '../base/page.dart';

class LoginPage extends Page {
  LoginPage() : super('login') {
    dom.style.backgroundColor = 'lightblue';
  }

  @override
  void initialize() {
    (dom.querySelector('#btnConfirm')! as HtmlElement)
      .addEventListener('click', (event) {
        print('Confirm');
        Wire.send(Signals.STATES_ACTION__NAVIGATE, payload: Action.NAVIGATE_TO_MAIN);
      });
  }

  @override
  void render() {

  }

  // @override
  // void destroy() {
  //   super.destroy();
  // }
}
