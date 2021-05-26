import 'dart:async';

import '../base/page.dart';

class LogoutPage extends Page {
  late Timer _timer = Timer.periodic(Duration(seconds: 1), _handleTimerTick);
  int _counter = 3;

  LogoutPage() : super('page/logout.html') {
    dom.style.backgroundColor = 'coral';
  }

  @override
  void render() {
    dom.text = 'Go to Index in ${_counter}';
  }

  @override
  void destroy() {
    _timer.cancel();
    super.destroy();
  }

  void _handleTimerTick(Timer timer) {
    // if (--_counter == 0)
    //   // dispatchAction(Action.LOGOUT_PAGE_TIMER_EXPIRED);
    // else
    render();
  }
}
