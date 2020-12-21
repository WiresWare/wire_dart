import 'package:states/states.dart';
import 'package:wire/wire.dart';

import '../constants/Data.dart';

class AuthStates extends States {

  static final String
    USER_LOGIN_VALIDATE = 'state_user__login_validate',
    USER_LOGIN_REJECTED = 'state_user__login_rejected',
    USER_LOGIN_ERROR = 'state_user__login_error',

    USER_LOGGED_IN = 'state_user__logged_in',
    USER_LOGGED_OUT = 'state_user__logged_out'
  ;

  AuthStates() {
    add(USER_LOGGED_OUT);
    add(USER_LOGGED_IN);

    add(USER_LOGIN_VALIDATE);
    add(USER_LOGIN_REJECTED);
    add(USER_LOGIN_ERROR);

    Wire.data(Data.STATES_AUTH, value: this)
        .lock(WireDataLockToken());
  }
}

