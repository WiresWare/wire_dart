library;

import 'package:wire/utils/wire_command_with_wire_data.dart';

abstract class WireCommandWithRequiredData<T> extends WireCommandWithWireData<T> {
  WireCommandWithRequiredData({List<String> requiredDataKeys = const []}) {
    if (requiredDataKeys.isNotEmpty) {
      whenRequiredDataReady = Future(() async {
        final dataMap = await getMany(requiredDataKeys);
        return Future.value(dataMap);
      });
    } else {
      whenRequiredDataReady = Future.value({});
    }
  }

  late Future<Map<String, dynamic>> whenRequiredDataReady;
}
