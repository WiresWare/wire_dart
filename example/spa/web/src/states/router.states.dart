import 'package:states/states.dart';

class RouterStates extends States {

  static final String
    INITIAL = 'state_route_initial',

    PAGE_MAIN = 'state_route__page_main',

    PAGE_LOGIN = 'state_route__page_login',
    PAGE_LOGOUT = 'state_route__page_logout',

    PAGE_PROFILES = 'state_route__page_profiles',
    PAGE_TRIALS = 'state_route__page_trials'
  ;

  RouterStates() {
    add(INITIAL);

    add(PAGE_MAIN);

    add(PAGE_LOGIN);
    add(PAGE_LOGOUT);
    add(PAGE_PROFILES);
    add(PAGE_TRIALS);
  }
}

