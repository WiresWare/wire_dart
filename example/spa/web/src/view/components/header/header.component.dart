import 'dart:js_interop';

import 'package:web/web.dart';

import '../../base/component.dart';

class Header extends Component {
  Header() : super('header') {
    dom.style.backgroundColor = 'wheat';
  }

  final _btnIndex = HTMLButtonElement();
  final _btnGallery = HTMLButtonElement();

  @override
  void render() {
    _btnIndex.addEventListener('click', _handleClickEvent.toJS);
    _btnIndex.textContent = 'INDEX';

    _btnGallery.addEventListener('click', _handleClickEvent.toJS);
    _btnGallery.textContent = 'GALLERY';

    dom.append(_btnIndex);
    dom.append(_btnGallery);
  }

  @override
  void destroy() {
    _btnIndex.removeEventListener('click', _handleClickEvent.toJS);
    _btnGallery.removeEventListener('click', _handleClickEvent.toJS);
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
