import 'dart:js_interop';

import 'package:web/web.dart';

import '../base/page.dart';

class ProfilesPage extends Page {
  ProfilesPage() : super('page/profiles.html') {
    dom.className += 'index';
    dom.style.backgroundColor = '#f1f1f1';
  }

  final _btnLogin = HTMLButtonElement();

  @override
  void render() {
    _btnLogin.addEventListener('click', _handleClickEvent.toJS);
    _btnLogin.textContent = 'LOGIN';

    dom.children.add(_btnLogin);
  }

  @override
  void destroy() {
    _btnLogin.removeEventListener('click', _handleClickEvent.toJS);
    _btnLogin.remove();

    super.destroy();
  }

  void _handleClickEvent(MouseEvent event) {
    print('> ProfilesPage -> _handleClickEvent');
    // dispatchAction(Action.INDEX_PAGE_BUTTON_LOGIN_CLICKED);
  }
}
