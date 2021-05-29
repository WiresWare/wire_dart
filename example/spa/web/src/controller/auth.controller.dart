import 'package:states/states.dart';
import 'package:wire/wire.dart';

import '../constants/Action.dart';
import '../constants/Data.dart';
import '../constants/Signals.dart';
import '../states/auth.states.dart';

class AuthController {
  AuthController() {
    Wire.add<String>(this, Signals.STATES_ACTION__AUTH, (action, wid) async {
      final statesAuthWireData = Wire.data<AuthStates>(Data.STATES_AUTH);
      statesAuthWireData.value.execute(action);
    });
  }

  void initialize() {
    final WireData authStatesData = Wire.data(Data.STATES_AUTH);
    if (!authStatesData.isSet) {
      Wire.data(Data.STATES_AUTH, value: new AuthStates())
          .lock(WireDataLockToken());
    }

    final authStates = authStatesData.value;
    authStates.when(
      at: AuthStates.USER_LOGGED_OUT, to: AuthStates.USER_LOGIN_VALIDATE,
      on: Action.USER_LOGIN_VALIDATE, handler: (StatesTransition t) {
        print('> AuthController -> authStates: USER_LOGIN_VALIDATE - ${t.toString()}');
      }
    );
    authStates.when(
      at: AuthStates.USER_LOGIN_VALIDATE, to: AuthStates.USER_LOGGED_IN,
      on: Action.USER_LOGIN_COMPLETE, handler: (StatesTransition t) {
        print('> AuthController -> authStates: USER_LOGIN_COMPLETE - ${t.toString()}');
      }
    );
    authStates.when(
      at: AuthStates.USER_LOGIN_VALIDATE, to: AuthStates.USER_LOGIN_ERROR,
      on: Action.USER_LOGIN_ERROR, handler: (StatesTransition t) {
        print('> AuthController -> authStates: USER_LOGIN_ERROR - ${t.toString()}');
      }
    );
    authStates.when(
      at: AuthStates.USER_LOGIN_ERROR, to: AuthStates.USER_LOGGED_OUT,
      on: Action.USER_LOGOUT, handler: (StatesTransition t) {
        print('> AuthController -> authStates: USER_LOGIN_ERROR - ${t.toString()}');
      }
    );
    authStates.when(
      at: AuthStates.USER_LOGGED_IN, to: AuthStates.USER_LOGGED_OUT,
      on: Action.USER_LOGOUT, handler: (StatesTransition t) {
      }
    );
  }
}
