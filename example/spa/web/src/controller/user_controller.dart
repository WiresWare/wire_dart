import 'package:wire/wire.dart';

import '../constants/data.dart';
import '../states/user_states.dart';

class UserController {
  UserController();

  void initialize() {
    final userStatesData = Wire.data(Data.STATES_ROUTER);
    if (!userStatesData.isSet) userStatesData.value = UserStates();

    // final userStates = userStatesData.value;
  }
}
