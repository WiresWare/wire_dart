import 'dart:html';

import 'package:wire/wire.dart';

import '../constants/Action.dart';
import '../constants/Data.dart';

import '../constants/Signals.dart';

class Application {
  late DivElement _root;
  late DivElement _header;

  Application(DivElement root) {
    _root = root;
  }

  void initialize() {

    final navigationAction =
      Wire.data(Data.USER).isSet
        ? Action.NAVIGATE_TO_MAIN
        : Action.NAVIGATE_TO_LOGIN;

    Wire.send(Signals.NAVIGATE_ACTION, payload: navigationAction);
  }
}
