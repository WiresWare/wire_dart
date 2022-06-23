import 'package:states/states.dart';

class AuthStates extends States {
  AuthStates() {
    add(USER_LOGGED_OUT);
    add(USER_LOGGED_IN);

    add(USER_LOGIN_VALIDATE);
    add(USER_LOGIN_REJECTED);
    add(USER_LOGIN_ERROR);
  }

  static const String
    USER_LOGIN_VALIDATE = 'state_user__login_validate',
    USER_LOGIN_REJECTED = 'state_user__login_rejected',
    USER_LOGIN_ERROR = 'state_user__login_error',

    USER_LOGGED_IN = 'state_user__logged_in',
    USER_LOGGED_OUT = 'state_user__logged_out'
  ;
}
