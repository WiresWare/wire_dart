import 'dart:html';
import '../base/page.dart';

class ProfilesPage extends Page {
  ProfilesPage() : super('page/profiles.html') {
    dom.className += 'index';
    dom.style.backgroundColor = '#f1f1f1';
  }

  final _btnLogin = ButtonElement();

  @override
  void render() {
    _btnLogin.addEventListener('click', _handleClickEvent);
    _btnLogin.text = 'LOGIN';

    dom.children.add(_btnLogin);
  }

  @override
  void destroy() {
    _btnLogin.removeEventListener('click', _handleClickEvent);
    _btnLogin.remove();

    super.destroy();
  }

  void _handleClickEvent(event) {
    // dispatchAction(Action.INDEX_PAGE_BUTTON_LOGIN_CLICKED);
  }
}
