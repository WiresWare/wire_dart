import 'dart:js_interop';

import 'package:web/web.dart';

import 'package:wire/wire.dart';

import '../../constants/action.dart';
import '../../constants/signals.dart';
import '../base/page.dart';

class TrialsPage extends Page {
  TrialsPage() : super('trials') {
    dom.style.backgroundColor = 'antiquewhite';
  }

  final _btnIndex = HTMLButtonElement();
  final _btnExit = HTMLButtonElement();

  @override
  void render() {
    _btnIndex.addEventListener('click', _handleClickEvent.toJS);
    _btnIndex.textContent = 'INDEX';

    _btnExit.addEventListener('click', _handleClickEvent.toJS);
    _btnExit.textContent = 'EXIT';

    dom.append(_btnIndex);
    dom.append(_btnExit);
  }

  @override
  void destroy() {
    _btnIndex.removeEventListener('click', _handleClickEvent.toJS);
    _btnIndex.remove();
    _btnExit.removeEventListener('click', _handleClickEvent.toJS);
    _btnExit.remove();

    super.destroy();
  }

  void _handleClickEvent(Event event) {
    print('> TrialsPage -> _handleClickEvent');
    final ct = event.currentTarget;
    if (ct == _btnIndex) {
      Wire.send(Signals.STATES_ACTION__NAVIGATE, payload: Action.NAVIGATE_TO_MAIN);
    } else if (ct == _btnExit) {
      // dispatchAction(Action.GALLERY_PAGE_BUTTON_EXIT_CLICKED);
    }
  }
}
