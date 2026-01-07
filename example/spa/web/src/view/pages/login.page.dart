import 'dart:js_interop';

import 'package:web/web.dart';

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
    (dom.querySelector('#btnConfirm')! as HTMLElement).addEventListener(
      'click',
      (MouseEvent _) {
        print('Confirm');
        Wire.send(Signals.STATES_ACTION__NAVIGATE, payload: Action.NAVIGATE_TO_MAIN);
      }.toJS,
    );
  }

  @override
  void render() {}

  // @override
  // void destroy() {
  //   super.destroy();
  // }
}
