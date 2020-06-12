library wire;

import 'dart:async';
import 'dart:collection';

part 'store.dart';
part 'layer.dart';
part 'data.dart';

///
/// Created by Vladimir Cores (Minkin) on 07/10/19.
/// Github: https://github.com/DQvsRA
/// License: MIT
///
class Wire
{
  static int _INDEX = 0;
  static WireLayer _LAYER = WireLayer();
  static WireStore _STORE = WireStore();

  ///
  /// The number of times that this item will respond.
  /// Default is 0 that means infinity times.
  ///
  int replies = 0;

  ///**************************************************
  ///  Protected / Private Properties
  ///**************************************************

  ///
  /// [read-only]
  /// The Wire SIGNAL associated with this Wire.
  ///
  /// @private
  String _signal;
  String get signal => _signal;

  ///
  /// [read-only]
  /// The closure method that this item was associated.
  ///
  /// @private
  Function _listener;

  ///
  /// [read-only] [internal use]
  /// Unique identification for this instance based on its attributes.
  ///
  /// @private
  int _hash;
  int get hash => _hash;

  Wire(String signal, Function listener, int replies)
  {
    _signal = signal;
    _listener = listener;
    this.replies = replies;

    _hash = ++_INDEX << 0x08;
    _LAYER.add(this);
  }

  ///**********************************************************************************************************
  ///
  ///  Public Methods
  ///
  ///**********************************************************************************************************
  void transfer([params])
  {
    // Call a listener in this Wire.
    _listener(params);
  }

  ///**********************************************************************************************************
  ///
  ///  Public Static Methods
  ///
  ///**********************************************************************************************************
  static Wire add(String signal, Function listener, [int replies = 0])
  { return Wire(signal, listener, replies); }

  static bool send(String signal, [args])
  { return _LAYER.send(signal, args); }

  static bool remove(String signal)
  { return _LAYER.remove(signal); }

  static WireData data(String param, [dynamic value])
  {
    var wd = _STORE.get(param);
    if (value != null) wd.value = value is Function ? value(wd.value) : value;
    return wd;
  }
}
