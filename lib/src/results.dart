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
  List<WireSendError> get errors => _list.whereType<WireSendError>().toList();
  String get errorsString => errors.map((error) => '${error.message} (${error.error})').join('\n');
  List<dynamic> get list => _list;
  bool get signalHasNoSubscribers => _noSubscribers;
}

class WireSendError {
  WireSendError(String message, StateError error) {
    print('WireSendError -> constructor -> message: $message | error: $error');
    _message = message;
    _error = error;
  }
  late final StateError _error;
  late final String _message;
  String get message => _message;
  StateError get error => _error;
}
