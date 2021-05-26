import 'dart:html';

import '../base/page.dart';

class MainPage extends Page {
  ButtonElement _btnIndex = ButtonElement();
  ButtonElement _btnGallery = ButtonElement();

  MainPage() : super('main.html') {
    dom.style.backgroundColor = 'wheat';
  }

  void render() {
    _btnIndex.addEventListener('click', _handleClickEvent);
    _btnIndex.text = 'INDEX';

    _btnGallery.addEventListener('click', _handleClickEvent);
    _btnGallery.text = 'GALLERY';

    dom.append(_btnIndex);
    dom.append(_btnGallery);
  }

  void destroy() {
    _btnIndex.removeEventListener("click", _handleClickEvent);
    _btnGallery.removeEventListener("click", _handleClickEvent);
    _btnIndex.remove();
    _btnGallery.remove();

    super.destroy();
  }

  void _handleClickEvent(Event event) {
    var ct = event.currentTarget;
    if (ct == _btnIndex) {
      // dispatchAction(Action.LOGIN_PAGE_BUTTON_INDEX_CLICKED);
    } else if (ct == _btnGallery) {
      // dispatchAction(Action.LOGIN_PAGE_BUTTON_GALLERY_CLICKED);
    }
  }
}
