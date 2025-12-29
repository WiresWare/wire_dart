import 'package:test/test.dart';
import 'package:wire/utils/wire_command_with_wire_data.dart';
import 'package:wire/wire.dart';

class TestWireMiddleware extends WireMiddleware {
  TestWireMiddleware(this.simpleDataStorage);

  Map<String, dynamic> simpleDataStorage;

  @override
  Future<void> onAdd(Wire wire) async {
    print('> TestWireMiddleware -> onAdd: Wire.signal = ${wire.signal}');
  }

  @override
  Future<void> onData(String key, prevValue, nextValue) async {
    print('> TestWireMiddleware -> onData: key = '
        '${key} | $prevValue | $nextValue');
    if (nextValue != null)
      simpleDataStorage[key] = nextValue;
    else
      simpleDataStorage.remove(key);
  }

  @override
  Future<void> onRemove(String signal, [Object? scope, listener]) async {
    print('> TestWireMiddleware -> onRemove: signal = '
        '${signal} | $scope | $listener');
  }

  @override
  Future<void> onSend(String? signal, [data, scope]) async {
    print('> TestWireMiddleware -> onSend: signal = '
        '${signal} | $data | $scope');
  }

  @override
  Future<void> onDataError(error, String key, value) async {
    print('> TestWireMiddleware -> onDataError: key = '
        '${key} | $error | $value');
  }

  @override
  Future<void> onReset(String key, value) async {
    print('> TestWireMiddleware -> onReset: key = '
        '${key} | $value');
  }
}

void main() {
  final GROUP_1_TITLE = '1. Subscriptions';
  final GROUP_2_TITLE = '2. Purge and remove';
  final GROUP_3_TITLE = '3. Data access';
  final GROUP_4_TITLE = '4. Data lock/unlock';
  final GROUP_5_TITLE = '5. Data getters';
  final GROUP_6_TITLE = '6. Chain of commands';

  group(GROUP_1_TITLE, () {
    const SIGNAL_G1 = 'SIGNAL';
    const SIGNAL_COUNTER = 'SIGNAL_COUNTER';
    const SIGNAL_WITH_ERROR = 'SIGNAL_WITH_ERROR';
    const SIGNAL_NOT_REGISTERED = 'SIGNAL_NOT_REGISTERED';

    final TEST_CASE_1_0 = '1.0. Send Signal';
    final TEST_CASE_1_1 = '1.1. Has Signal';
    final TEST_CASE_1_2 = '1.2. Unregistered Signal';
    final TEST_CASE_1_3 = '1.3. Detach Signal';
    final TEST_CASE_1_4 = '1.4. Counter Signal with 2 replies';
    final TEST_CASE_1_5 = '1.5. Test put/find';
    final TEST_CASE_1_6 = '1.6. Add many and remove by scope';
    final TEST_CASE_1_7 = '1.7. Remove all by listener';

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
      await Wire.add<dynamic>(SCOPE, SIGNAL_G1, listener_dynamic);
      print('> 1: Setup -> Add signal $SIGNAL_G1 with string WireListener');
      await Wire.add<String>(SCOPE, SIGNAL_G1, listener_string);
      print('> 1: Setup -> Add signal $SIGNAL_G1 with boolean WireListener');
      await Wire.add<bool>(SCOPE, SIGNAL_G1, listener_boolean);
      print('> 1: Setup -> Attach pre-created signal ${wireToAttach.signal} with string WireListener');
      Wire.attach(wireToAttach);
      await Wire.add(SCOPE, SIGNAL_WITH_ERROR, (_, __) async {
        return 1;
      });
      await Wire.add(SCOPE, SIGNAL_WITH_ERROR, (_, __) async {
        throw Exception('Error processing signal');
      });
    });

    test(TEST_CASE_1_0, () async {
      print('> ===========================================================================');
      print('> $TEST_CASE_1_0 ');
      print('> ===========================================================================');
      print('> 1.0.1 -> Send signal: $SIGNAL_G1 data == null - all three WireListeners should receive the signal');
      expect((await Wire.send(SIGNAL_G1)).signalHasNoSubscribers, isFalse);
      print(
          '> 1.0.2 -> Send signal: $SIGNAL_G1 with STRING data - WireListeners that expect data type <String> receive or null');
      expect((await Wire.send(SIGNAL_G1, payload: 'STRING_DATA')).signalHasNoSubscribers, isFalse);
      print('> 1.0.3 -> Send signal: $SIGNAL_G1 with BOOLEAN data');
      expect((await Wire.send(SIGNAL_G1, payload: false)).signalHasNoSubscribers, isFalse);
      print('> 1.0.3 -> Send attached ${wireToAttach.signal} signal without data (=null)');
      expect((await Wire.send(wireToAttach.signal)).signalHasNoSubscribers, isFalse);
      print(
        '> 1.0.4 -> When one of the listener of the signal throw an error it will be catch and returned in the WireTransferError.results array. Wires that have replies wont be removed.',
      );
      expect(
          () => Wire.send(SIGNAL_WITH_ERROR).then((WireSendResults results) {
                if (results.hasError) throw results.list.firstWhere((item) => item is WireSendError);
              }),
          throwsA(isA<WireSendError>()));
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
      expect((await Wire.send(SIGNAL_NOT_REGISTERED)).signalHasNoSubscribers, isTrue);
      print('> 1.2.2 -> Wire.send("RANDOM") == isTrue');
      expect((await Wire.send('RANDOM')).signalHasNoSubscribers, isTrue);
    });

    test(TEST_CASE_1_3, () async {
      print('> ===========================================================================');
      print('> $TEST_CASE_1_3 ');
      print('> ===========================================================================');
      print('> 1.3.1 -> Wire.detach(wireToAttach) == isTrue');
      expect(await Wire.detach(wireToAttach), isTrue);
      print(
          '> 1.3.2 -> Wire.send(wireToAttach.signal) == isTrue - because there is no Wires (listeners) for that signal');
      expect((await Wire.send(wireToAttach.signal)).signalHasNoSubscribers, isTrue);
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
      expect((await Wire.send(SIGNAL_COUNTER)).signalHasNoSubscribers, isFalse);
      print(
          '> 1.4.2 -> Wire.send(SIGNAL_COUNTER) == isTrue - True means that there is not more wires with that signal left');
      expect((await Wire.send(SIGNAL_COUNTER)).signalHasNoSubscribers, isTrue);
    });

    test(TEST_CASE_1_5, () async {
      print('> ===========================================================================');
      print('> $TEST_CASE_1_5 ');
      print('> ===========================================================================');
      print('> TEST put/find instances by their type, the instance should be preserved');

      final putFindTestObject = PutFindTestObject();
      print('> 1.5.1 -> Put object of type ${putFindTestObject.runtimeType} to Wire');
      Wire.put<PutFindTestObject>(putFindTestObject);
      print('> 1.5.2 -> Find object of type ${putFindTestObject.runtimeType}');
      expect(Wire.find(PutFindTestObject) == putFindTestObject, isTrue);
    });

    test(TEST_CASE_1_6, () async {
      print('> ===========================================================================');
      print('> $TEST_CASE_1_6 ');
      print('> ===========================================================================');
      print('> TEST for add many signals/listener for the scope and remove them all by that scope');

      final scope = PutFindTestObject();
      final SIGNAL_NEW = 'SIGNAL_NEW';

      await Wire.addMany(scope, {
        SIGNAL_G1: (_, __) async {
          print('> $TEST_CASE_1_6 -> Hello from $SIGNAL_G1');
          return false;
        },
        SIGNAL_NEW: (_, __) async {
          print('> $TEST_CASE_1_6 -> Hello from $SIGNAL_NEW');
          return SIGNAL_NEW;
        },
        SIGNAL_COUNTER: (_, __) async {
          print('> $TEST_CASE_1_6 -> Hello from $SIGNAL_COUNTER');
          return 1;
        },
      });

      print('> 1.6.1 -> Check if added signals exist');
      expect(Wire.get(signal: SIGNAL_G1).isNotEmpty, isTrue);
      expect(Wire.get(signal: SIGNAL_NEW).isNotEmpty, isTrue);
      expect(Wire.get(signal: SIGNAL_COUNTER).isNotEmpty, isTrue);

      print('> 1.6.2 -> Send signal to verify their work');
      expect((await Wire.send(SIGNAL_G1)).list.first, false);
      expect((await Wire.send(SIGNAL_NEW)).list.first, SIGNAL_NEW);
      expect((await Wire.send(SIGNAL_COUNTER)).list.first, 1);

      print('> 1.6.3 -> Call Wire.removeAllByScope(scope) -> existed == true');
      expect(await Wire.remove(scope: scope), isTrue);
      expect(await Wire.remove(scope: scope), isFalse);

      print('> 1.6.4 -> Check no signals after removal - returned list is empty');
      expect(await Wire.get(scope: scope).isEmpty, isTrue);
    });

    test(TEST_CASE_1_7, () async {
      print('> ===========================================================================');
      print('> $TEST_CASE_1_7 ');
      print('> ===========================================================================');
      print('> TEST Remove all signals by listener');
      Wire wire = await Wire.add(PutFindTestObject(), 'some_random_signal', listener_dynamic);
      expect(Wire.has(wire: wire), isTrue);
      expect(Wire.get(listener: listener_dynamic).length, 2);
      expect(await Wire.remove(listener: listener_dynamic), isTrue);
      expect(await Wire.get(listener: listener_dynamic).isEmpty, isTrue);
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

    var testMiddleware = TestWireMiddleware({});

    setUp(() async {
      print('> ===========================================================================');
      print('> $GROUP_2_TITLE ');
      print('> ===========================================================================');

      await Wire.purge(withMiddleware: true);

      await Wire.add(SCOPE, SIGNAL_G2, listener);
      await Wire.add(SCOPE, SIGNAL_G2_2, listener);
      Wire.attach(testWire);
      Wire.middleware(testMiddleware);
    });

    final TEST_CASE_2_1 = '2.1 Purge';

    test(TEST_CASE_2_1, () async {
      print('> ===========================================================================');
      print('> $TEST_CASE_2_1 ');
      print('> ===========================================================================');
      print('> 2.1.1 -> Wire.has(wire: ${testWire}) == isTrue');
      expect(Wire.has(wire: testWire), isTrue);
      print('> 2.1.2 -> Wire.has(signal: $SIGNAL_G2) == isTrue');
      expect(Wire.has(signal: SIGNAL_G2), isTrue);

      print('> ======================= PURGE =======================');
      await Wire.purge(withMiddleware: true);

      print('> 2.1.4 -> Wire.send(SIGNAL) == isTrue');
      expect((await Wire.send(SIGNAL_G2)).signalHasNoSubscribers, isTrue);
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
      Wire.add(SCOPE, SIGNAL_G2, (dynamic data, wid) async => {print('> \t\t $SIGNAL_G2 response with data: $data')});
      print('> 2.2.1 -> Wire.get(listener: listener) == isEmpty');
      expect((await Wire.send(SIGNAL_G2, payload: 'Dynamic Value')).signalHasNoSubscribers, isFalse);
      print('> 2.2.2 -> Wire.has(signal: SIGNAL_G2) == isTrue');
      expect(Wire.has(signal: SIGNAL_G2), isTrue);
      print('> ======================= REMOVE SIGNAL_G2 =======================');
      await Wire.remove(signal: SIGNAL_G2);
      print('> 2.2.3 -> Wire.has(signal: SIGNAL_G2) == isFalse');
      expect(Wire.has(signal: SIGNAL_G2), isFalse);
      expect(Wire.get(signal: SIGNAL_G2), isEmpty);
    });
  });

  group(GROUP_3_TITLE, () {
    var simpleDataStorage = <String, dynamic>{};
    var testMiddleware = TestWireMiddleware(simpleDataStorage);

    final KEY_STRING = 'key';
    final DATA_STRING = 'value';

    setUp(() async {
      print('> ===========================================================================');
      print('> $GROUP_3_TITLE ');
      print('> ===========================================================================');
      await Wire.purge(withMiddleware: true);
      print('>\t -> add middleware with empty map - <String, dynamic>{}');
      Wire.middleware(testMiddleware);
    });

    test('3.1 Check data present in data container layer after being set', () async {
      print('>\t -> Set value and check WireData return type');
      expect(Wire.data(KEY_STRING).isSet, isFalse);
      expect(Wire.data(KEY_STRING, value: DATA_STRING), isInstanceOf<WireData>());
      expect(Wire.data(KEY_STRING), isInstanceOf<WireData>());
      expect(Wire.data(KEY_STRING).isSet, isTrue);
      expect(Wire.data(KEY_STRING).isLocked, isFalse);
      expect(Wire.data(KEY_STRING).value, DATA_STRING);
      print('>\t -> Set value and check WireData return type');
      expect(simpleDataStorage.containsKey(KEY_STRING), isTrue);
      expect(simpleDataStorage[KEY_STRING], DATA_STRING);

      print('>\t -> Remove WireData $KEY_STRING');
      await Wire.data(KEY_STRING).remove();
      expect(Wire.data(KEY_STRING).isSet, isFalse);
      expect(Wire.data(KEY_STRING).value, isNull);
      expect(simpleDataStorage.containsKey(KEY_STRING), isFalse);
    });

    test('3.2 Check generics', () async {
      final key = 'generic_key';
      Wire.data<int>(key, value: 10);
      expect(Wire.data<int>(key).value, 10);
    });

    test('3.3 onError callback', () async {
      final key = 'error_key';
      var errorCaught = false;
      final middleware = TestWireMiddleware({});
      middleware.onDataError = (error, key, value) async {
        errorCaught = true;
      };
      Wire.middleware(middleware);
      Wire.data(key).subscribe((value) async {
        throw Exception('Test Error');
      });
      await Wire.data(key).refresh();
      expect(errorCaught, isTrue);
    });

    test('3.4 listener execution modes', () async {
      final key = 'execution_mode_key';
      final wireData = Wire.data(key);
      var parallelCount = 0;

      wireData.listenersExecutionMode = WireDataListenersExecutionMode.PARALLEL;
      wireData.subscribe((value) async {
        await Future.delayed(Duration(milliseconds: 10));
        parallelCount++;
      });
      wireData.subscribe((value) async {
        parallelCount++;
      });

      await wireData.refresh();
      expect(parallelCount, 2);
    });

    test('3.5 async unsubscribe', () async {
      final key = 'unsubscribe_key';
      final wireData = Wire.data<int>(key);
      var listener1CallCount = 0;
      var listener2CallCount = 0;

      WireDataListener<int?> listener1 = (value) async {
        listener1CallCount++;
      };
      WireDataListener<int?> listener2 = (value) async {
        listener2CallCount++;
      };

      wireData.subscribe(listener1);
      wireData.subscribe(listener2);

      // First refresh, both should be called
      await wireData.refresh(1);
      expect(listener1CallCount, 1);
      expect(listener2CallCount, 1);

      // Unsubscribe listener1
      await wireData.unsubscribe(listener: listener1);

      // Second refresh, only listener2 should be called again
      await wireData.refresh(2);
      expect(listener1CallCount, 1, reason: 'Unsubscribed listener should not be called again');
      expect(listener2CallCount, 2, reason: 'Subscribed listener should still be called');
    });
  });

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
      print('>\t set initial value and lock');
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
      expect(() => Wire.data(DATA_KEY, value: 'cant be changed'), throwsA(isA<Exception>()));

      expect(Wire.data(DATA_KEY).lock(data_lockToken_one), isTrue);
      expect(Wire.data(DATA_KEY).lock(data_lockToken_one), isTrue);
      expect(Wire.data(DATA_KEY).lock(data_lockToken_two), isFalse);
    });
  });

  group(GROUP_5_TITLE, () {
    final DATA_KEY_USER_VO = 'dataKeyUserVO';
    final GET__USER_FULL_NAME = 'getUserFullName';
    final dataUserVO = {
      'firstName': 'Wires',
      'lastName': 'Ware',
    };

    final nameFormatter = (userVO) => '${userVO['firstName']} ${userVO['lastName']}';

    setUp(() async {
      print('> ===========================================================================');
      print('> $GROUP_5_TITLE ');
      print('> ===========================================================================');
      await Wire.purge(withMiddleware: true);

      Wire.data(DATA_KEY_USER_VO, value: dataUserVO).subscribe((value) async {
        print('> $DATA_KEY_USER_VO -> updated: $value');
      });

      WireDataGetter wireDataGetter = (WireData that) {
        final wireData = Wire.data(DATA_KEY_USER_VO);
        final userVO = wireData.value!;
        print('> $GET__USER_FULL_NAME -> get: ${that.key} isSet ${that.isSet}');
        wireData.subscribe(that.refresh);
        return nameFormatter(userVO);
      };
      Wire.data(GET__USER_FULL_NAME, getter: wireDataGetter);
    });

    test('5.1 Getter', () {
      print('>\t Wire.data(GET__USER_FULL_NAME).isLocked');
      expect(() => Wire.data(GET__USER_FULL_NAME).subscribe((value) async {}), throwsA(isA<Exception>()));
      expect(Wire.data(GET__USER_FULL_NAME).isLocked, isTrue);
      expect(Wire.data(GET__USER_FULL_NAME).isGetter, isTrue);
      expect(Wire.data(GET__USER_FULL_NAME).value, equals(nameFormatter(dataUserVO)));

      final wireData = Wire.data(DATA_KEY_USER_VO);
      final userVO = wireData.value;
      userVO['lastName'] = 'Cores';
      Wire.data(DATA_KEY_USER_VO, value: userVO);

      expect(Wire.data(GET__USER_FULL_NAME).value, equals('${dataUserVO['firstName']} Cores'));
      expect(() => Wire.data(GET__USER_FULL_NAME, value: 'new value'), throwsA(isA<Exception>()));
    });
  });

  group(GROUP_6_TITLE, () {
    const SIGNAL_CHAIN_EXECUTION = 'signal_chain_execution';
    final scope1 = new StringBuffer();
    final scope2 = new StringBuffer();

    setUp(() {
      print('> ===========================================================================');
      print('> $GROUP_6_TITLE');
      print('> ===========================================================================');
      Wire.addMany(scope1, {
        SIGNAL_CHAIN_EXECUTION: (_, __) =>
            ChainFirstCommand(_! as String).execute().then((output) => ChainSecondCommand(output).execute()),
      });
      Wire.add(scope2, SIGNAL_CHAIN_EXECUTION, (payload, wireId) async {
        prints('> scope2 -> signal "$SIGNAL_CHAIN_EXECUTION" processing, return nothing');
      });
      Wire.add(scope2, SIGNAL_CHAIN_EXECUTION, (payload, wireId) async {
        prints('> scope2 -> signal "$SIGNAL_CHAIN_EXECUTION" single execution');
      }, replies: 1);
    });

    test('6.1 Chain execution of sent signal', () async {
      final results = await Wire.send(SIGNAL_CHAIN_EXECUTION, payload: 'Test');
      print('>\t Wire: number of signals $SIGNAL_CHAIN_EXECUTION: ${Wire.get(signal: SIGNAL_CHAIN_EXECUTION).length}');
      expect(Wire.get(signal: SIGNAL_CHAIN_EXECUTION).length, 2);
      print('>\t WireSendResults.signalHasNoSubscribers = ${results.signalHasNoSubscribers}');
      expect(results.signalHasNoSubscribers, isFalse);
      print('>\t WireSendResults.list.length = ${results.list.length}');
      expect(results.list.length, 1);
    });
  });
}

class PutFindTestObject {}

class ChainFirstCommand extends WireCommandWithWireData<String> {
  ChainFirstCommand(this.value);
  final String value;
  @override
  Future<String> execute() async {
    return '$value | First Command';
  }
}

class ChainSecondCommand extends WireCommandWithWireData<String> {
  ChainSecondCommand(this.value);
  final String value;
  @override
  Future<String> execute() async {
    return '$value | Second Command';
  }
}
