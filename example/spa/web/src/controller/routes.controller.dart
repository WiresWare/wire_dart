import 'dart:html';

import 'package:states/states.dart';
import 'package:wire/wire.dart';

import '../constants/Action.dart';
import '../constants/Data.dart';
import '../constants/Signals.dart';
import '../states/router.states.dart';
import '../view/base/page.dart';
import '../view/pages/login.page.dart';
import '../view/pages/main.page.dart';

class RoutesController {
  Page? _currentPage;
  late DivElement _routerDOM;
  late String _templatePath;

  void set templatePath(String value) => _templatePath = value;

  RoutesController(DivElement dom, String path) {
    _routerDOM = dom;
    _templatePath = path;

    Wire.add<String>(this, Signals.STATES_ACTION__NAVIGATE,
      (action, wid) async => Wire.data<RouterStates>(Data.STATES_ROUTER)
        .value.execute(action)
    );
  }

  void initialize() {
    final WireData routerStatesData = Wire.data(Data.STATES_ROUTER);
    if (!routerStatesData.isSet) {
      Wire.data(Data.STATES_ROUTER, value: new RouterStates()).lock(WireDataLockToken());
    }

    final routerStates = routerStatesData.value;
    routerStates.when(
      at: RouterStates.INITIAL, to: RouterStates.PAGE_LOGIN,
      on: Action.NAVIGATE_TO_LOGIN, handler: (StatesTransition transition) => {
        navigateFromTo(LoginPage()) }
    );
    routerStates.when(
      at: RouterStates.INITIAL, to: RouterStates.PAGE_MAIN,
      on: Action.NAVIGATE_TO_MAIN, handler: (StatesTransition transition) => {
        navigateFromTo(MainPage()) }
    );
  }

  Future<void> navigateFromTo(Page toPage) async {
    final hasCurrentPage = _currentPage != null;
    if (hasCurrentPage) await _currentPage?.beforeLeave();

    final template = await HttpRequest.getString('${_templatePath}${toPage.path}.html');
    toPage.dom.setInnerHtml(template, treeSanitizer: NodeTreeSanitizer.trusted);
    toPage.initialize();

    if (hasCurrentPage) {
      _currentPage!
        ..dom.remove()
        ..destroy();
    }

    if (toPage.shouldRender()) toPage.render();
    _routerDOM.append(toPage.dom);

    _currentPage = toPage;
  }
}
