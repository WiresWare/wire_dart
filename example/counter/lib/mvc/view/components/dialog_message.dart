import 'dart:js_interop';
import 'package:web/web.dart';
import 'package:wire_example_counter/mvc/view/base/dom_element.dart';

class DialogMessage extends DomElement {
  DialogMessage(String message) : super(window.document.getElementById('dialog')! as HTMLElement) {
    final closeBtn = (dom as HTMLDialogElement).querySelector('.close')! as HTMLButtonElement;
    final content = (dom as HTMLDialogElement).querySelector('.content')! as HTMLDivElement;
    content.textContent = message;
    closeBtn.addEventListener(
      'click',
      () {
        (dom as HTMLDialogElement).close();
      }.toJS,
    );
    (dom as HTMLDialogElement).showModal();
  }
}
