///
/// Created by Vladimir (Cores) Minkin on 12/10/22.
/// Github: https://github.com/vladimircores
/// License: APACHE LICENSE, VERSION 2.0
///
class WireSendResults {
  WireSendResults(List<dynamic> list, [bool noSubscribers = false]) {
    _list = list;
    _noSubscribers = noSubscribers;
  }

  late final List<dynamic> _list;
  late final bool _noSubscribers;

  bool get hasError => _list.any((element) => element is WireSendError);
  List<dynamic> get list => _list;
  bool get signalHasNoSubscribers => _noSubscribers;
}

class WireSendError {
  WireSendError(String message, Exception error) {
    _error = error;
    _message = message;
  }
  late final Exception _error;
  late final String _message;
  String get message => _message;
  Exception get error => _error;
}
