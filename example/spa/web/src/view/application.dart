import 'package:wire/wire.dart';

import '../constants/action.dart';
import '../constants/data.dart';
import '../constants/signals.dart';

class Application {
  Application();

  void initialize() {
    final initialNavigateAction = Wire.data(Data.USER).isSet
        ? Action.NAVIGATE_TO_MAIN
        : Action.NAVIGATE_TO_LOGIN;

    Wire.send(Signals.STATES_ACTION__NAVIGATE, payload: initialNavigateAction);
  }
}
