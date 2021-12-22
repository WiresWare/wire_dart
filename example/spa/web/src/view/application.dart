import 'dart:html';

import 'package:wire/wire.dart';

import '../constants/Action.dart';
import '../constants/Data.dart';

import '../constants/Signals.dart';

class Application {
  Application(HtmlElement root) { }

  void initialize() {

    final initialNavigateAction =
      Wire.data(Data.USER).isSet
        ? Action.NAVIGATE_TO_MAIN
        : Action.NAVIGATE_TO_LOGIN;

    Wire.send(Signals.STATES_ACTION__NAVIGATE, payload: initialNavigateAction);
  }
}
