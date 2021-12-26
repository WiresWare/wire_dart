import 'package:angular/angular.dart';
import 'package:wire_example_angular_todo/app_component.template.dart' as ng;

late ComponentRef _app;

void main() {
  _app = runApp(ng.AppComponentNgFactory);
}

void hot$onDestroy() {
  _app.destroy();
  main();
}
