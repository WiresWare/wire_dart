import 'dart:js_interop';

import 'package:http/http.dart' as http;

import 'package:states/states.dart';
import 'package:web/web.dart';

import 'package:wire/wire.dart';

import '../constants/action.dart';
import '../constants/data.dart';
import '../constants/signals.dart';
import '../states/router_states.dart';
import '../view/base/page.dart';
import '../view/pages/login.page.dart';
import '../view/pages/main.page.dart';
import '../view/pages/trials.page.dart';

class RoutesController {
  RoutesController(HTMLDivElement dom, String path) {
    _routerDOM = dom;
    _templatePath = path;
    Wire.add<String>(this, Signals.STATES_ACTION__NAVIGATE, (action, wid) async => (Wire.data(Data.STATES_ROUTER).value as RouterStates).execute(action!));
  }

  Page? _currentPage;
  late HTMLDivElement _routerDOM;
  late String _templatePath;
  final http.Client _client = http.Client();

  // ignore: avoid_setters_without_getters
  set templatePath(String value) => _templatePath = value;

  void initialize() {
    final routerStatesWireData = Wire.data(Data.STATES_ROUTER);
    if (!routerStatesWireData.isSet) {
      Wire.data(Data.STATES_ROUTER, value: RouterStates()).lock(WireDataLockToken());
    }

    final routerStates = routerStatesWireData.value as RouterStates;
    routerStates.when(at: RouterStates.INITIAL, to: RouterStates.PAGE_LOGIN, on: Action.NAVIGATE_TO_LOGIN, handler: (StatesTransition transition) => {navigateFromTo(LoginPage())});
    routerStates.when(at: RouterStates.INITIAL, to: RouterStates.PAGE_MAIN, on: Action.NAVIGATE_TO_MAIN, handler: (StatesTransition transition) => {navigateFromTo(MainPage())});
    routerStates.when(at: RouterStates.PAGE_LOGIN, to: RouterStates.PAGE_MAIN, on: Action.NAVIGATE_TO_MAIN, handler: (StatesTransition transition) => {navigateFromTo(MainPage())});
    routerStates.when(at: RouterStates.PAGE_MAIN, to: RouterStates.PAGE_TRIALS, on: Action.NAVIGATE_TO_TRIALS, handler: (StatesTransition transition) => {navigateFromTo(TrialsPage())});
    routerStates.when(at: RouterStates.PAGE_TRIALS, to: RouterStates.PAGE_MAIN, on: Action.NAVIGATE_TO_MAIN, handler: (StatesTransition transition) => {navigateFromTo(MainPage())});
  }

  Future<String> fetchData(String path) async {
    final url = Uri.http('127.0.0.1:8080', '${_templatePath}${path}.html');
    print('> RoutesController -> fetchData from $url');
    final response = await _client.get(url);
    return response.body;
  }

  Future<void> navigateFromTo(Page toPage) async {
    final hasCurrentPage = _currentPage != null;
    if (hasCurrentPage) await _currentPage?.beforeLeave();

    print('> RoutesController -> navigateFromTo: ${_currentPage} - ${toPage.path}');

    final template = await fetchData(toPage.path);
    toPage.dom.innerHTML = template.toJS;
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
