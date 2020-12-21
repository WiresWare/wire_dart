import 'package:states/states.dart';
import 'package:wire/wire.dart';

import '../constants/Action.dart';
import '../constants/Data.dart';
import '../constants/Signals.dart';
import '../states/auth.states.dart';

class AuthController {
  AuthController() {
    Wire.add<String>(this, Signals.USER_AUTH_ACTION,
      (action, wid) async => Wire.data<AuthStates>(Data.STATES_AUTH)
        .value.execute(action)
    );
  }

  void initialize() {
    final authStates = Wire.data<AuthStates>(Data.STATES_AUTH).value;
    authStates.when(
      at: AuthStates.USER_LOGGED_OUT, to: AuthStates.USER_LOGIN_VALIDATE,
      on: Action.USER_LOGIN_VALIDATE, handler: (StatesTransition t) => {
      }
    );
    authStates.when(
      at: AuthStates.USER_LOGIN_VALIDATE, to: AuthStates.USER_LOGGED_IN,
      on: Action.USER_LOGIN_COMPLETE, handler: (StatesTransition t) => {
      }
    );
    authStates.when(
      at: AuthStates.USER_LOGIN_VALIDATE, to: AuthStates.USER_LOGIN_ERROR,
      on: Action.USER_LOGIN_ERROR, handler: (StatesTransition t) => {
      }
    );
    authStates.when(
      at: AuthStates.USER_LOGIN_ERROR, to: AuthStates.USER_LOGGED_OUT,
      on: Action.USER_LOGOUT, handler: (StatesTransition t) => {
      }
    );
    authStates.when(
      at: AuthStates.USER_LOGGED_IN, to: AuthStates.USER_LOGGED_OUT,
      on: Action.USER_LOGOUT, handler: (StatesTransition t) => {
      }
    );
  }
}
