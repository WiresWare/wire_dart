part of wire;

///
/// Created by Vladimir (Cores) Minkin on 12/10/22.
/// Github: https://github.com/vladimircores
/// License: APACHE LICENSE, VERSION 2.0
///
class WireSendResults {
  WireSendResults(List<dynamic> dataList, [bool noSubscribers = false]) {
    _dataList = dataList;
    _noSubscribers = noSubscribers;
  }

  late final List<dynamic> _dataList;
  late final bool _noSubscribers;

  List<dynamic> get dataList => _dataList;
  bool get signalHasNoSubscribers => _noSubscribers;
}
