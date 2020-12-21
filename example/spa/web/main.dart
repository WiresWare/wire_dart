import 'dart:html';

import 'src/controller/auth.controller.dart';
import 'src/controller/navigator.controller.dart';
import 'src/view/application.dart';

import 'src/constants/DOM.dart';
import 'src/constants/Pages.dart';

void main() async {
  DivElement rootDOM = querySelector(DOM.ID_ROOT);
  DivElement routerDOM = rootDOM.querySelector(DOM.ID_ROUTER);

  final authController = AuthController();
  final navigatorController = NavigatorController(routerDOM, Pages.TEMPLATES_PATH);

  final application = Application(rootDOM);

  authController.initialize();
  navigatorController.initialize();

  application.initialize();
}
