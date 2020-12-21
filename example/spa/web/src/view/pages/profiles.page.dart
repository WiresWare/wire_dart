import 'dart:html';
import '../base/page.dart';

class ProfilesPage extends Page {
  ButtonElement _btnLogin;

  ProfilesPage() : super('page/profiles.html') {
    _btnLogin = ButtonElement();
    dom.className += "index";
    dom.style.backgroundColor = "#f1f1f1";
  }

  void render() {
    _btnLogin.addEventListener("click", _handleClickEvent);
    _btnLogin.text = "LOGIN";

    dom.children.add(_btnLogin);
  }

  void destroy() {
    _btnLogin.removeEventListener("click", _handleClickEvent);
    _btnLogin = null;

    super.destroy();
  }

  void _handleClickEvent(event) {
    // dispatchAction(Action.INDEX_PAGE_BUTTON_LOGIN_CLICKED);
  }
}
