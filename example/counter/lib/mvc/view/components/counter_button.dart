import 'dart:js_interop';
import 'package:web/web.dart';

import 'package:wire/wire.dart';
import 'package:wire_example_counter/mvc/view/base/dom_element.dart';
import 'package:wire_example_counter/mvc/view/components/dialog_message.dart';

void setEnabled(HTMLElement btn, bool enabled) {
  const baseClass = 'spectrum-Button spectrum-Button--primary';
  btn.className = enabled ? baseClass : '${baseClass} is-disabled';
}

class CounterButton extends DomElement {
  CounterButton(String title, String signal) : super(HTMLButtonElement()) {
    final span = HTMLSpanElement()
      ..textContent = title
      ..title = title
      ..className = 'spectrum-Button-label';
    dom
      ..className = 'spectrum-Button spectrum-Button--primary'
      ..addEventListener(
        'click',
        (MouseEvent _) {
          print('CounterButton -> onClick: ${signal}');
          setEnabled(dom, false);
          Wire.send(signal)
              .then((WireSendResults results) {
                if (results.hasError) {
                  DialogMessage(results.errorsString);
                }
              })
              .whenComplete(() => setEnabled(dom, true));
        }.toJS,
      )
      ..append(span);
  }
}
