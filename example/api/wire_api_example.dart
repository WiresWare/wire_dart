import 'package:wire/wire.dart';

main() {
  /// SUBSCRIBER and API EXAMPLE ======================================
  const String
    SIGNAL_1 = 'SIGNAL_1',
    SIGNAL_ONCE = 'SIGNAL_1_ONCE',
    SIGNAL_2 = 'SIGNAL_2';

  const Object SCOPE = Object();

  Wire.add(SCOPE, SIGNAL_1, (data) {
    print('> SIGNAL 1 (subscriber 1) -> Hello: ' + data);
  });

  Wire.add(SCOPE, SIGNAL_1, (data) {
    print('> SIGNAL 1 (subscriber 2) -> Hello: ' + data);
  });

  Wire.send(SIGNAL_1, 'World');
  Wire.send(SIGNAL_1, 'Dart');
  Wire.send(SIGNAL_1, 'Vladimir');
  Wire.remove(SIGNAL_1);
  /// SUBSCRIBER END =========================================

  /// ONCE EXAMPLE ===========================================
  Wire.add(SCOPE, SIGNAL_ONCE, (data) {
    print('> SIGNAL 1 (limit 1) -> Goodbye: ' + data);
  }, 1);

  print('\tNo ends: ' + Wire.send(SIGNAL_ONCE, 'World').toString());
  print('\tNo ends: ' + Wire.send(SIGNAL_ONCE, 'Dart').toString());
  print('\tNo ends: ' + Wire.send(SIGNAL_ONCE, 'Vladimir').toString());
  /// ONCE END ===============================================

  Wire.add(SCOPE, SIGNAL_2, (data) {
    print('> SIGNAL 2 -> I do: ' + data);
  });

  Wire.add(SCOPE, SIGNAL_2, (data) {
    print('> SIGNAL 2 (limit 2) -> I do: ' + data);
  }, 2);

  print('\tSend ends: ' + Wire.send(SIGNAL_2, 'Code').toString());
  print('\tSend ends: ' + Wire.send(SIGNAL_2, 'Gym').toString());
  print('\tSend ends: ' + Wire.send(SIGNAL_2, 'Eat (sometimes)').toString());
  print('\tSend ends: ' + Wire.send(SIGNAL_2, 'Sleep').toString());
  print('\tSend ends: ' + Wire.send(SIGNAL_2, 'Repeat').toString());

  var param1 = 'SUPER_PARAM';
  Wire.data(param1).subscribe(SCOPE, (data) => {
    print('\t Listener 1: ' + data)
  });

  Wire.data(param1).subscribe(SCOPE, (data) => {
    print('\t Listener 2: ' + data)
  });

  print('> Wire.data Listeners: where initial data = ' + Wire.data(param1).value.toString());
  Wire.data(param1, 'VALUE');
  Wire.data(param1, (value) => value + ' NEW');
}
