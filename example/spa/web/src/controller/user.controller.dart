import 'dart:html';

import 'package:wire/wire.dart';

import '../constants/Data.dart';
import '../states/user.states.dart';

class UserController {
  UserController() {

  }

  void initialize() {
    final userStates = Wire.data<UserStates>(Data.STATES_USER).value;
  }
}
