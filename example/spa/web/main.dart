import 'dart:html';

import 'src/constants/dom.dart';
import 'src/constants/pages.dart';
import 'src/controller/auth.controller.dart';
import 'src/controller/routes.controller.dart';
import 'src/view/application.dart';

void main() async {
  print('> main -> step 1 - get the dom');
  final rootDOM = querySelector(DOM.ID_ROOT)! as HtmlElement;
  final routerDOM = rootDOM.querySelector(DOM.ID_ROUTER)! as DivElement;

  print('> main -> step 2 - instantiate controllers');
  final authController = AuthController();
  final routesController = RoutesController(routerDOM, Pages.TEMPLATES_PATH);

  print('> main -> step 3 - instantiate application');
  final application = Application();

  print('> main -> step 4 - initialize controllers');
  authController.initialize();
  routesController.initialize();

  print('> main -> step 5 - initialize application');
  application.initialize();
}
