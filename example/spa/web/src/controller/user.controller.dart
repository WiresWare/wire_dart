import 'dart:html';

import 'package:wire/wire.dart';

import '../constants/Data.dart';
import '../states/user.states.dart';

class UserController {
  UserController() {

  }

  void initialize() {
    final WireData userStatesData = Wire.data(Data.STATES_ROUTER);
    if (!userStatesData.isSet) userStatesData.value = new UserStates();

    final userStates = userStatesData.value;
  }
}
