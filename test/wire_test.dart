import 'package:wire/wire.dart';
import 'package:test/test.dart';

class TestWireMiddleware extends WireMiddleware {
  @override
  Future<void> onAdd(Wire wire) async {
    print('> TestWireMiddleware -> onAdd: Wire.signal = ${wire.signal}');
  }

  @override
  Future<void> onData(String key, prevValue, nextValue) async {
    print('> TestWireMiddleware -> onData: key = '
        '${key} | $prevValue | $nextValue');
  }

  @override
  Future<void> onRemove(String signal, [Object? scope, listener]) async {
    print('> TestWireMiddleware -> onRemove: signal = '
        '${signal} | $scope | $listener');
  }

  @override
  Future<void> onSend(String? signal, [data, scope]) async {
    print('> TestWireMiddleware -> onRemove: signal = '
        '${signal} | $data | $scope');
  }
}

void main() {
  final GROUP_1_TITLE = '1. Subscriptions';
  final GROUP_2_TITLE = '2. Purge and remove';
  final GROUP_3_TITLE = '3. Data access';
  final GROUP_4_TITLE = '4. Data lock/unlock';
  final GROUP_5_TITLE = '5. Data getters';

  group(GROUP_1_TITLE, () {
    const SIGNAL_G1 = 'SIGNAL';
    const SIGNAL_COUNTER = 'SIGNAL_COUNTER';
    const SIGNAL_NOT_REGISTERED = 'SIGNAL_NOT_REGISTERED';

    final TEST_CASE_1_0 = '1.0. Registered Signal';
    final TEST_CASE_1_1 = '1.1. Has Signal';
    final TEST_CASE_1_2 = '1.2. Unregistered Signal';
    final TEST_CASE_1_3 = '1.3. Detach Signal';
    final TEST_CASE_1_4 = '1.4. Counter Signal with 2 replies';
    final TEST_CASE_1_5 = '1.5. Test put/find';
    final TEST_CASE_1_6 = '1.6. Add many and remove by scope';

    const SCOPE = Object();

    WireListener<String> listener_string = (String? data, wid) async {
      print('> \t WireListener -> STRING \t data: ${data} - receives only data of String type or null');
    };

    WireListener<bool> listener_boolean = (bool? data, wid) async {
      print('> \t WireListener -> BOOLEAN \t data: ${data} - receives only data of Boolean type or null');
    };

    WireListener listener_dynamic = (dynamic data, wid) async {
      print('> \t WireListener -> DYNAMIC \t data: ${data} - receives all types of data');
    };

    var wireToAttach = Wire<String>(SCOPE, 'wire_signal_attached', (dynamic data, wid) async {
      final wire = Wire.get(wireId: wid).single;
      print('> \t WireListener on attached wire: "${wire.signal}" with data: ${data}');
    });

    setUpAll(() async {
      print('> 1: Setup -> Cleanup everything');
      await Wire.purge(withMiddleware: true);
      print('> 1: Setup -> Add signal $SIGNAL_G1 with dynamic WireListener');
      print('> \t\t Dynamic listener (with specified data type) will react on any signal');
      Wire.add(SCOPE, SIGNAL_G1, listener_dynamic);
      print('> 1: Setup -> Add signal $SIGNAL_G1 with string WireListener');
      Wire.add<String>(SCOPE, SIGNAL_G1, listener_string);
      print('> 1: Setup -> Add signal $SIGNAL_G1 with boolean WireListener');
      Wire.add<bool>(SCOPE, SIGNAL_G1, listener_boolean);
      print('> 1: Setup -> Attach pre-created signal ${wireToAttach.signal} with string WireListener');
      Wire.attach(wireToAttach);
    });

    test(TEST_CASE_1_0, () async {
      print('> ===========================================================================');
      print('> $TEST_CASE_1_0 ');
      print('> ===========================================================================');
      print('> 1.0.1 -> Send signal: $SIGNAL_G1 data == null - all three WireListeners should receive the signal');
      expect(await Wire.send(SIGNAL_G1), isFalse);
      print('> 1.0.2 -> Send signal: $SIGNAL_G1 with STRING data - WireListeners that expect data type <String> receive or null');
      expect(await Wire.send(SIGNAL_G1, payload: 'STRING_DATA'), isFalse);
      print('> 1.0.3 -> Send signal: $SIGNAL_G1 with BOOLEAN data');
      expect(await Wire.send(SIGNAL_G1, payload: false), isFalse);
      print('> 1.0.3 -> Send attached ${wireToAttach.signal} signal without data (=null)');
      expect(await Wire.send(wireToAttach.signal), isFalse);
    });

    test(TEST_CASE_1_1, () async {
      print('> ===========================================================================');
      print('> $TEST_CASE_1_1 ');
      print('> ===========================================================================');
      print('> 1.1.1 -> Check if signal ($SIGNAL_G1) exists in communication layer');
      expect(Wire.has(signal: SIGNAL_G1), isTrue);
      print('> 1.1.2 -> Wire.has(signal: SIGNAL_NOT_REGISTERED) == isFalse');
      expect(Wire.has(signal: SIGNAL_NOT_REGISTERED), isFalse);
      print('> 1.1.3 -> Wire.has(signal: "RANDOM_SIGNAL") == isFalse');
      expect(Wire.has(signal: 'RANDOM_SIGNAL'), isFalse);
      print('> 1.1.4 -> Wire.has(wire: wireToAttach) == isTrue');
      expect(Wire.has(wire: wireToAttach), isTrue);
    });

    test(TEST_CASE_1_2, () async {
      print('> ===========================================================================');
      print('> $TEST_CASE_1_2 ');
      print('> ===========================================================================');
      print('> 1.2.1 -> Wire.send(SIGNAL_NOT_REGISTERED) == isTrue');
      expect(await Wire.send(SIGNAL_NOT_REGISTERED), isTrue);
      print('> 1.2.2 -> Wire.send("RANDOM") == isTrue');
      expect(await Wire.send('RANDOM'), isTrue);
    });

    test(TEST_CASE_1_3, () async {
      print('> ===========================================================================');
      print('> $TEST_CASE_1_3 ');
      print('> ===========================================================================');
      print('> 1.3.1 -> Wire.detach(wireToAttach) == isTrue');
      expect(await Wire.detach(wireToAttach), isTrue);
      print('> 1.3.2 -> Wire.send(wireToAttach.signal) == isTrue - because there is no Wires (listeners) for that signal');
      expect(await Wire.send(wireToAttach.signal), isTrue);
    });

    test(TEST_CASE_1_4, () async {
      print('> ===========================================================================');
      print('> $TEST_CASE_1_4 ');
      print('> ===========================================================================');
      print('> TEST REPLIES for Wire.add(SCOPE, SIGNAL_COUNTER, (dynamic _, wid) {}, replies: 2');
      Wire.add(SCOPE, SIGNAL_COUNTER, (dynamic _, wid) async {
        var wire = Wire.get(wireId: wid).single;
        print('1.4. -> Response on ${wire.signal} replies left: ${wire.replies}');
      }, replies: 2);
      print('> 1.4.1 -> Wire.send(SIGNAL_COUNTER) == isFalse');
      expect(await Wire.send(SIGNAL_COUNTER), isFalse);
      print('> 1.4.2 -> Wire.send(SIGNAL_COUNTER) == isTrue - True means that there is not more wires with that signal left');
      expect(await Wire.send(SIGNAL_COUNTER), isTrue);
    });

    test(TEST_CASE_1_5, () async {
      print('> ===========================================================================');
      print('> $TEST_CASE_1_5 ');
      print('> ===========================================================================');
      print('> TEST put/find instances by their type, the instance should be preserved');

      final putFindTestObject = PutFindTestObject();
      print('> 1.5.1 -> Put object of type ${putFindTestObject.runtimeType} to Wire');
      Wire.put(putFindTestObject);
      print('> 1.5.2 -> Find object of type ${putFindTestObject.runtimeType}');
      expect(Wire.find<PutFindTestObject>() == putFindTestObject, isTrue);
    });

    test(TEST_CASE_1_6, () async {
      print('> ===========================================================================');
      print('> $TEST_CASE_1_6 ');
      print('> ===========================================================================');
      print('> TEST for add many signals/listener for the scope and remove them all by that scope');

      final scope = PutFindTestObject();
      final SIGNAL_NEW = 'SIGNAL_NEW';

      await Wire.addMany(scope, {
        SIGNAL_G1: (_, __) async { print('> $TEST_CASE_1_6 -> Hello from $SIGNAL_G1'); },
        SIGNAL_NEW: (_, __) async { print('> $TEST_CASE_1_6 -> Hello from $SIGNAL_NEW'); },
        SIGNAL_COUNTER: (_, __) async { print('> $TEST_CASE_1_6 -> Hello from $SIGNAL_COUNTER'); },
      });

      print('> 1.6.1 -> Check if added signals exist');
      expect(Wire.get(signal: SIGNAL_G1).isNotEmpty, isTrue);
      expect(Wire.get(signal: SIGNAL_NEW).isNotEmpty, isTrue);
      expect(Wire.get(signal: SIGNAL_COUNTER).isNotEmpty, isTrue);

      print('> 1.6.2 -> Send signal to verify their work');
      await Wire.send(SIGNAL_G1);
      await Wire.send(SIGNAL_NEW);
      await Wire.send(SIGNAL_COUNTER);

      print('> 1.6.3 -> Call Wire.removeAllByScope(scope)');
      await Wire.remove(scope: scope);

      print('> 1.6.4 -> Check no signals after removal');
      expect(Wire.get(scope: scope).isEmpty, isTrue);
    });
  });

  group(GROUP_2_TITLE, () {

    var SIGNAL_G2 = 'G2_SIGNAL_SUBSCRIPTION';
    var SIGNAL_G2_2 = 'G2_SIGNAL_SUBSCRIPTION_2';
    var SCOPE = Object();

    WireListener listener = (dynamic data, wid) async {
      final wire = Wire.get(wireId: wid).single;
      print('2. -> Response on ${wire.signal} with data: ${data}');
    };

    var testWire = Wire(SCOPE, 'wire_signal_2', listener);

    var testMiddleware = TestWireMiddleware();

    setUp(() async {
      print('> ===========================================================================');
      print('> $GROUP_2_TITLE ');
      print('> ===========================================================================');

      await Wire.purge(withMiddleware: true);

      Wire.add(SCOPE, SIGNAL_G2, listener);
      Wire.add(SCOPE, SIGNAL_G2_2, listener);
      Wire.attach(testWire);
      Wire.middleware(testMiddleware);
    });

    final TEST_CASE_2_1 = '2.1 Purge';

    test(TEST_CASE_2_1, () async {
      print('> ===========================================================================');
      print('> $TEST_CASE_2_1 ');
      print('> ===========================================================================');
      print('> 2.1.1 -> Wire.has(wire: testWire) == isTrue');
      expect(Wire.has(wire: testWire), isTrue);
      print('> 2.1.2 -> Wire.has(signal: SIGNAL) == isTrue');
      expect(Wire.has(signal: SIGNAL_G2), isTrue);

      print('> ======================= PURGE =======================');
      await Wire.purge(withMiddleware: true);

      print('> 2.1.4 -> Wire.send(SIGNAL) == isTrue');
      expect(await Wire.send(SIGNAL_G2), isTrue);
      print('> 2.1.5 -> Wire.has(wire: testWire) == isFalse');
      expect(Wire.has(wire: testWire), isFalse);
      print('> 2.1.6 -> Wire.has(signal: SIGNAL) == isFalse');
      expect(Wire.has(signal: SIGNAL_G2), isFalse);

      print('> 2.1.7 -> Wire.get(signal: SIGNAL_G2) == isEmpty');
      expect(Wire.get(signal: SIGNAL_G2), isEmpty);
      print('> 2.1.8 -> Wire.get(signal: SIGNAL_G2_2) == isEmpty');
      expect(Wire.get(signal: SIGNAL_G2_2), isEmpty);
      print('> 2.1.9 -> Wire.get(signal: testWire.signal) == isEmpty');
      expect(Wire.get(signal: testWire.signal), isEmpty);
      print('> 2.1.10 -> Wire.get(scope: SCOPE) == isEmpty');
      expect(Wire.get(scope: SCOPE), isEmpty);
      print('> 2.1.11 -> Wire.get(listener: listener) == isEmpty');
      expect(Wire.get(listener: listener), isEmpty);
    });

    final TEST_CASE_2_2 = '2.2 Remove';

    test(TEST_CASE_2_2, () async {
      print('> ===========================================================================');
      print('> $TEST_CASE_2_2 ');
      print('> ===========================================================================');
      Wire.add(SCOPE, SIGNAL_G2, (dynamic data, wid) async => {
        print('> \t\t $SIGNAL_G2 response with data: $data')
      });
      print('> 2.2.1 -> Wire.get(listener: listener) == isEmpty');
      expect(await Wire.send(SIGNAL_G2, payload: 'Dynamic Value'), isFalse);
      print('> 2.2.2 -> Wire.has(signal: SIGNAL_G2) == isTrue');
      expect(Wire.has(signal: SIGNAL_G2), isTrue);
      print('> ======================= REMOVE SIGNAL_G2 =======================');
      await Wire.remove(signal: SIGNAL_G2);
      print('> 2.2.3 -> Wire.has(signal: SIGNAL_G2) == isFalse');
      expect(Wire.has(signal: SIGNAL_G2), isFalse);
      expect(Wire.get(signal: SIGNAL_G2), isEmpty);
    });
  });

  group(GROUP_3_TITLE, () {});

  group(GROUP_4_TITLE, () {
    final DATA_KEY = 'DATA_KEY';

    final data_lockToken_one = WireDataLockToken();
    final data_lockToken_two = WireDataLockToken();

    setUp(() async {
      print('> ===========================================================================');
      print('> $GROUP_4_TITLE ');
      print('> ===========================================================================');
      await Wire.purge(withMiddleware: true);

      Wire.data(DATA_KEY).subscribe((value) async {
        print('> $DATA_KEY -> updated: $value');
      });

      Wire.data(DATA_KEY, value: 'initial value');
      Wire.data(DATA_KEY).lock(data_lockToken_one);
    });

    test('4.1 Lock data with token', () async {
      expect(Wire.data(DATA_KEY).isLocked, isTrue);
      expect(Wire.data(DATA_KEY).unlock(data_lockToken_one), isTrue);
      expect(Wire.data(DATA_KEY).isLocked, isFalse);

      Wire.data(DATA_KEY, value: 'can be changed');
      print('>\t Wire.data(DATA_KEY).lock(data_lockToken_one)');
      expect(Wire.data(DATA_KEY).lock(data_lockToken_one), isTrue);
      print('>\t Wire.data(DATA_KEY, value: cant be changed)');
      // expect(Wire.data(DATA_KEY, value: 'cant be changed'), throwsA(Exception(ERROR__DATA_IS_LOCKED)));
      // expect(Wire.data(DATA_KEY, value: 'cant be changed'), throwsA(TypeMatcher<Exception>()));
      // expect(Wire.data(DATA_KEY, value: 'cant be changed'), throwsA(isA<Exception>()));
      // expect(Wire.data(DATA_KEY, value: 'cant be changed'), throwsException);
      // expect(Wire.data(DATA_KEY, value: 'cant be changed'), throwsA(equals(ERROR__DATA_IS_LOCKED)));

      expect(Wire.data(DATA_KEY).lock(data_lockToken_one), isTrue);
      expect(Wire.data(DATA_KEY).lock(data_lockToken_one), isTrue);
      expect(Wire.data(DATA_KEY).lock(data_lockToken_two), isFalse);
    });
  });

  group(GROUP_5_TITLE, () {
    final DATA_KEY_USER_VO = 'dataKeyUserVO';
    final GET__USER_FULL_NAME = 'getUserFullName';
    final UserVO = {
      'firstName': 'Wires',
      'lastName': 'Ware',
    };

    setUp(() async {
      print('> ===========================================================================');
      print('> $GROUP_5_TITLE ');
      print('> ===========================================================================');
      await Wire.purge(withMiddleware: true);

      Wire.data(DATA_KEY_USER_VO, value: UserVO).subscribe((value) async {
        print('> $DATA_KEY_USER_VO -> updated: $value');
      });

      WireDataGetter<String> wireDataGetter = (WireData that) {
        final wireData = Wire.data(DATA_KEY_USER_VO);
        final userVO = wireData.value;
        print('> $GET__USER_FULL_NAME -> get: ${that.key} isSet ${that.isSet}');
        wireData.subscribe(that.refresh);
        return '${userVO['firstName']} ${userVO['lastName']}';
      };
      Wire.data<String>(GET__USER_FULL_NAME, getter: wireDataGetter).subscribe((value) async {
        print('> $GET__USER_FULL_NAME -> updated: $value');
      });
    });

    test('5.1 Getter', () {
      print('>\t Wire.data(GET__USER_FULL_NAME).isLocked');
      expect(Wire.data(GET__USER_FULL_NAME).isLocked, isTrue);
      expect(Wire.data(GET__USER_FULL_NAME).isGetter, isTrue);
      expect(Wire.data(GET__USER_FULL_NAME).value, equals('${UserVO['firstName']} ${UserVO['lastName']}'));
      final wireData = Wire.data(DATA_KEY_USER_VO);
      final userVO = wireData.value;
      userVO['lastName'] = 'Cores';
      Wire.data(DATA_KEY_USER_VO, value: userVO);
      expect(Wire.data(GET__USER_FULL_NAME).value, equals('${UserVO['firstName']} Cores'));
      // expect(Wire.data(GET__USER_FULL_NAME, value: 'new value'), throwsException);
      // expect(Wire.data(GET__USER_FULL_NAME, value: 'new value'), throwsA(Exception(ERROR__DATA_IS_GETTER)));
      // expect(Wire.data(GET__USER_FULL_NAME, value: 'new value'), throwsA(TypeMatcher<Exception>()));
    });
  });
}

class PutFindTestObject { }