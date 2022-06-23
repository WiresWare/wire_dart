import 'dart:html';

import '../base/page.dart';

class MainPage extends Page {
  MainPage() : super('main') {
    dom.style.backgroundColor = 'wheat';
  }

  final _btnIndex = ButtonElement();
  final _btnGallery = ButtonElement();

  @override
  void render() {
    _btnIndex.addEventListener('click', _handleClickEvent);
    _btnIndex.text = 'INDEX';

    _btnGallery.addEventListener('click', _handleClickEvent);
    _btnGallery.text = 'GALLERY';

    dom.append(_btnIndex);
    dom.append(_btnGallery);
  }

  @override
  void destroy() {
    _btnIndex.removeEventListener('click', _handleClickEvent);
    _btnGallery.removeEventListener('click', _handleClickEvent);
    _btnIndex.remove();
    _btnGallery.remove();

    super.destroy();
  }

  void _handleClickEvent(Event event) {
    final ct = event.currentTarget;
    if (ct == _btnIndex) {
      // dispatchAction(Action.LOGIN_PAGE_BUTTON_INDEX_CLICKED);
    } else if (ct == _btnGallery) {
      // dispatchAction(Action.LOGIN_PAGE_BUTTON_GALLERY_CLICKED);
    }
  }
}
