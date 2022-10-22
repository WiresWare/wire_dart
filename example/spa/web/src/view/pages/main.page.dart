import 'dart:html';

import 'package:wire/wire.dart';

import '../../constants/action.dart';
import '../../constants/signals.dart';
import '../base/page.dart';

class MainPage extends Page {
  MainPage() : super('main') {
    dom.style.backgroundColor = 'wheat';
  }

  final _btnTrials = ButtonElement();
  final _btnGallery = ButtonElement();

  @override
  void render() {
    _btnTrials.addEventListener('click', _handleClickEvent);
    _btnTrials.text = 'TRIALS';

    _btnGallery.addEventListener('click', _handleClickEvent);
    _btnGallery.text = 'GALLERY';

    dom.append(_btnTrials);
    dom.append(_btnGallery);
  }

  @override
  void destroy() {
    _btnTrials.removeEventListener('click', _handleClickEvent);
    _btnGallery.removeEventListener('click', _handleClickEvent);
    _btnTrials.remove();
    _btnGallery.remove();

    super.destroy();
  }

  void _handleClickEvent(Event event) {
    final ct = event.currentTarget;
    print('> MainPage -> _handleClickEvent: ct = ${ct}');
    if (ct == _btnTrials) {
      Wire.send(Signals.STATES_ACTION__NAVIGATE, payload: Action.NAVIGATE_TO_TRIALS);
    } else if (ct == _btnGallery) {
      // dispatchAction(Action.LOGIN_PAGE_BUTTON_GALLERY_CLICKED);
    }
  }
}
